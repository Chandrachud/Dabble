//
//  DBLMediaPickerController.swift
//  Dabble
//
//  Created by Reddy on 09/09/15.
//  Copyright (c) 2015 Saxon Global Inc. All rights reserved.
//

import UIKit

// Methods to send Picked images / videos to delegate viewcontroller.
protocol DatabackDelegateTwo
{
    func pickedImages(imagesDict: NSMutableArray)
    func pickedVideos(videos: NSMutableDictionary)
}

class DBLMediaPickerController: UIViewController, UzysAssetsPickerControllerDelegate, UIAlertViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, DBLServicesResponsesDelegate
{
    var imageView: UIImage!
    var collectionImages = NSMutableArray()
    var showPickingOption = false
    
    var deletingItem: AnyObject!
    var shouldPickImages = false
    var shouldPickVideos = false
    var pickedImages = NSMutableArray()
    var pickedVideos = NSMutableDictionary()

    var imagesToUpload = NSMutableArray()
    
    var sourceView = kSourceJobsCreated
    var moviePlayer: MPMoviePlayerViewController!
    var delegate: DatabackDelegateTwo!
    
    var videosData = NSMutableArray()
    var Server =  DBLServices()
    
    @IBOutlet weak var btnImage: UIButton!
    @IBOutlet weak var btnVideo: UIButton!
    @IBOutlet weak var myCollectionView: UICollectionView!
    
    @IBAction func savePickedImages(sender: AnyObject)
    {
//        if sourceView != kSourceJobsCreated
//        {
//            self.dismissViewControllerAnimated(true, completion: nil)
//            return
//        }
        
        if self.shouldPickImages == true
        {
            for image in collectionImages
            {
                if image.isKindOfClass(UIImage)
                {
                    imagesToUpload.addObject(image)
                }
            }
            
            if imagesToUpload.count != 0 && self.sourceView == kSourceJobsCreated
            {
                Server.processAddResource(["jobId": currentJob.jobId], images: imagesToUpload)
                return
            }
            self.delegate.pickedImages(self.pickedImages)
        }
        else
        {
            if videosData.count != 0 && sourceView == kSourceJobsCreated
            {
                Server.processAddVideos(["jobId" : currentJob.jobId], videos: videosData)
                return
            }
            self.delegate.pickedVideos(self.pickedVideos)
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func addResourceSuccess(responseObj: AnyObject!)
    {
        let responseDict = responseObj as! NSDictionary
        println("addResourceSuccess: \(responseDict)")
        
        if responseDict["code"] as! Int == 0
        {
            currentJob.isEdited = YES
            let payload = responseDict["payload"] as! NSDictionary
            
            if shouldPickImages == true
            {
                currentJob.images = currentJob.images.arrayByAddingObjectsFromArray(payload["images"] as! NSArray as [AnyObject])
                self.delegate.pickedImages(self.pickedImages)
//                currentJob.images
            }
            if shouldPickVideos == true
            {
                currentJob.images = currentJob.images.arrayByAddingObjectsFromArray(payload["images"] as! NSArray as [AnyObject])
                self.delegate.pickedVideos(self.pickedVideos)
            }
            
            self.dismissViewControllerAnimated(true) { () -> Void in
                self.navigationController?.popToRootViewControllerAnimated(true)
            }
        }
        else
        {
            appDelegate.showToastMessage("Dabble", message: responseDict["message"] as! String)
        }
    }
    
    func addResourceFailure(error: NSError)
    {
        println("addResourceFailure")
    }
    
    func getDataForVideoAssetURL(assetURL: NSURL)
    {
        let refURL = assetURL
        if let actualMediaURL = refURL as NSURL! {
            let assetLibrary = ALAssetsLibrary()
            assetLibrary.assetForURL(actualMediaURL , resultBlock: { (asset: ALAsset!) -> Void in
                if let actualAsset = asset as ALAsset?
                {
                    let data = ObjcUtils.getDataForAsset(actualAsset)
                    
                    let localVideoPath = (self.documentsDirectory() as NSString).stringByAppendingPathComponent("first.mp4")
                    let success = data?.writeToFile(localVideoPath, atomically: false)
                    
                    println(localVideoPath)
                    if (success != nil)
                    {
                        println("Successfully written the video file locally.")
//                        data = NSData.dataWithContentsOfMappedFile(localVideoPath) as! NSData
                    }
                    self.videosData.addObject(data)
                }
                }, failureBlock: { (error) -> Void in
            })
        }
    }
    
    func documentsDirectory() -> String
    {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
        return documentsPath as String
    }
    
    @IBAction func goBack(sender: AnyObject)
    {
//        if shouldPickImages == true
//        {
//            self.delegate.pickedImages(self.pickedImages)
//        }
//        if shouldPickVideos == true
//        {
//            self.delegate.pickedVideos(self.pickedVideos)
//        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    func fillCollectionImages()
    {
        if (self.shouldPickVideos == true)
        {
            self.collectionImages.addObjectsFromArray(self.pickedVideos.allValues)
        }
        else
        {
            self.collectionImages.addObjectsFromArray(self.pickedImages as [AnyObject])
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        Server.delegate = self
        UIButton.appearance().tintColor = UIColor.darkTextColor()
        UIButton.appearance().titleLabel?.font = kAppFont
        Utils.addCornerRadius(myCollectionView)
        
        self.fillCollectionImages()
        
        if showPickingOption == true
        {
            if shouldPickVideos == true
            {
                btnVideo.hidden = false
                btnImage.hidden = true
            }
            else
            {
                btnImage.hidden = false
                btnVideo.hidden = true
            }
        }
        else
        {
            btnImage.hidden = true
            btnVideo.hidden = true
        }
        
        if showPickingOption == true
        {
            let lpgr = UILongPressGestureRecognizer(target: self, action: Selector("handleLongPress:"))
            lpgr.minimumPressDuration = 1.0;
            self.myCollectionView.addGestureRecognizer(lpgr)
        }
    }

    func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer)
    {
        if gestureRecognizer.state != UIGestureRecognizerState.Ended
        {
            return
        }
        let p: CGPoint = gestureRecognizer.locationInView(self.myCollectionView)
        let indexPath: NSIndexPath! = self.myCollectionView.indexPathForItemAtPoint(p)!
        if indexPath == nil
        {
            println("couldn't find index path")
        }
        else
        {
            let alertView = UIAlertView(title: "Dabble", message: "Are you sure you want to delete?", delegate: self, cancelButtonTitle: "NO", otherButtonTitles: "YES")
            alertView.tag = indexPath.row;
            alertView.show()
        }
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int)
    {
        if (buttonIndex == 0)
        {
            println("Dont delete")
        }
        else
        {
            println("YES Delete!")
            
            if (self.shouldPickImages == true)
            {
                let item = self.pickedImages[alertView.tag]
                if item.isKindOfClass(NSString)
                {
                    println("Remove from server.")
                    self.deletingItem = item
                    
                    let postParams = ["resourceId":item as! String , "jobId": currentJob.jobId]
                    Server.processRemoveResource(postParams)
                    return
                }
                else
                {
                    self.pickedImages.removeObjectAtIndex(alertView.tag)
                    self.collectionImages.removeObjectAtIndex(alertView.tag)
                }
            }
            else
            {
                let item = self.collectionImages[alertView.tag]
                if item.isKindOfClass(NSString)
                {
                    self.deletingItem = item                    
                    println("Remove from server.")
                    let postParams = ["resourceId":item as! String , "jobId": currentJob.jobId]
                    Server.processRemoveResource(postParams)
                    return
                }
                else
                {
                    let allKeys = self.pickedVideos.allKeysForObject(self.collectionImages .objectAtIndex(alertView.tag)) as NSArray!
                    let url = allKeys.objectAtIndex(0) as! String
                    self.pickedVideos.removeObjectForKey(url)
                    self.collectionImages.removeObjectAtIndex(alertView.tag)
                }                
            }
            self.myCollectionView.reloadData()
        }
    }
    
    func removeResourceSuccess(responseDict: AnyObject!)
    {
        println("removeResourceSuccess")
        if sourceView == kSourceJobsCreated && self.showPickingOption == true && self.shouldPickImages == true
        {
            self.pickedImages.removeObject(deletingItem)
            self.collectionImages.removeObject(deletingItem)
            self.myCollectionView.reloadData()
        }
        else if sourceView == kSourceJobsCreated && self.showPickingOption == true && self.shouldPickVideos == true
        {
            self.pickedVideos.removeObjectForKey(deletingItem)
            self.collectionImages.removeObject(deletingItem)
            self.myCollectionView.reloadData()
        }
    }
    
    func removeResourceFailure(error: NSError)
    {
        println("removeResourceFailure")
    }
    
    @IBAction func btnAction(sender: UIButton)
    {
        let picker = UzysAssetsPickerController()
        picker.delegate = self
        if sender == btnImage
        {
            picker.maximumNumberOfSelectionVideo = 0;
            picker.maximumNumberOfSelectionPhoto = 5 - self.pickedImages.count;
            if (self.pickedImages.count == 5)
            {
                return;
            }
        }
        else if sender == self.btnVideo
        {
            picker.maximumNumberOfSelectionVideo = 1 - self.pickedVideos.count;
            picker.maximumNumberOfSelectionPhoto = 0;
            if (self.pickedVideos.count == 1)
            {
                return;
            }
        }
        self.presentViewController(picker, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK-  UzysAssetsPickerControllerDelegate methods
    
    func uzysAssetsPickerController(picker: UzysAssetsPickerController!, didFinishPickingAssets assets: [AnyObject]!) {
        println("assets are \(assets)")
        for var i = 0 ; i < assets.count; i++
        {
            let alAsset: ALAsset = assets[i] as! ALAsset
           
            if alAsset.valueForProperty("ALAssetPropertyType") as! String == "ALAssetTypePhoto"
            {
                let img = UIImage(CGImage: alAsset.thumbnail().takeUnretainedValue())
                self.pickedImages.addObject(img)
                self.collectionImages.addObject(img)
            }
            else
            {
                let img = UIImage(CGImage: alAsset.thumbnail().takeUnretainedValue())
                let representation = alAsset.defaultRepresentation()
                
                println(representation.filename())
                
//                let fileExtension = representation.filename().componentsSeparatedByString(".")
//                
//                if fileExtension.last!.caseInsensitiveCompare("mp4") == NSComparisonResult.OrderedSame || fileExtension.last!.caseInsensitiveCompare("mpeg4") == NSComparisonResult.OrderedSame || fileExtension.last!.caseInsensitiveCompare("mpeg-4") == NSComparisonResult.OrderedSame || fileExtension.last!.caseInsensitiveCompare("MPEG-4") == NSComparisonResult.OrderedSame
//                {
//                    
//                }
//                else
//                {
//                    appDelegate.showToastMessage(kAppName, message: "Please select Mp4/Mpeg4 file format.")
//                    return
//                }
                
                let movieURL = representation.url()
                let urlAsset = AVURLAsset(URL: movieURL)

                let duration = CMTimeGetSeconds(urlAsset.duration)
                
                if duration > 30
                {
                    appDelegate.showToastMessage(kAppName, message: "Video can not be more than 30 seconds. Please pick another.")
                    return
                }
                println(duration)

                self.pickedVideos.setValue(img, forKey: movieURL.absoluteString)
                if self.collectionImages.count != 0
                {
                    self.collectionImages.removeAllObjects()
                }
                self.collectionImages.addObjectsFromArray(self.pickedVideos.allValues)
                if (sourceView == kSourceJobsCreated || sourceView == kSourceSearchJobs)
                {
                    self.getDataForAssets()
                }
            }
        }
        self.myCollectionView.reloadData()
    }
    
    func getDataForAssets()
    {
        if videosData.count != 0
        {
            videosData.removeAllObjects()
        }
        for item in pickedVideos.allValues
        {
            if item.isKindOfClass(UIImage)
            {
                let allKeys = self.pickedVideos.allKeysForObject(item) as NSArray!
                let url = allKeys.objectAtIndex(0) as! String
                self.getDataForVideoAssetURL(NSURL(string:url)!)
            }
        }
    }
    
//    ALAssetRepresentation *representation = alAsset.defaultRepresentation;
//    NSURL *movieURL = representation.url;
//    
//    [self.pickedVideos setValue:img forKey:movieURL.absoluteString];
//    
//    if (self.collectionImages.count != 0)
//    {
//    [self.collectionImages removeAllObjects];
//    }
//    [self.collectionImages addObjectsFromArray:self.pickedVideos.allValues];
    
    
    func uzysAssetsPickerControllerDidExceedMaximumNumberOfSelection(picker: UzysAssetsPickerController!) {
        appDelegate.showToastMessage("Picker", message:"Exceed Maximum Number Of Selection")
    }
    
    func playVideoWithURL(urlString: String)
    {
        moviePlayer = MPMoviePlayerViewController(contentURL: NSURL(string: urlString))
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("moviePlaybackDidFinish:"), name: MPMoviePlayerPlaybackDidFinishNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("moviePlaybackStateChanged:"), name: MPMoviePlayerPlaybackStateDidChangeNotification , object: nil)
        
        moviePlayer.moviePlayer.prepareToPlay()
        moviePlayer.moviePlayer.shouldAutoplay = true
        

        self.presentViewController(moviePlayer, animated: true) { () -> Void in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        }
    }
    
    func moviePlaybackStateChanged(notification: AnyObject)
    {
        if moviePlayer.moviePlayer.playbackState == MPMoviePlaybackState.Playing
        {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
        println(moviePlayer.moviePlayer.playbackState)
    }
    
    func moviePlaybackDidFinish(player: MPMoviePlayerViewController)
    {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:MPMoviePlayerPlaybackDidFinishNotification , object: nil)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name:MPMoviePlayerPlaybackDidFinishNotification , object: nil)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return collectionImages.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        var identifier = "Cell"
        if self.shouldPickVideos
        {
            identifier = "VideoCell"
        }
        else
        {
            identifier = "Cell"
        }
        
        let cell: UICollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath) 
        let cellImageView = cell.viewWithTag(100) as! UIImageView
        
        cellImageView.image = UIImage(named: "avatar.png")
        Utils.addCornerRadius(cellImageView)
        cellImageView.layer.borderColor = primaryColorOfApp.CGColor
        cellImageView.layer.borderWidth = 1.0
        cellImageView.contentMode = .ScaleAspectFit
        if sourceView == kSourceJobsCreated || sourceView == kSourceJobsApplied || sourceView == kSourceSearchJobs
        {
            if (collectionImages[indexPath.row].isKindOfClass(NSString) == true)
            {
                let url = String(format: urlGetResource, currentJob.jobId , collectionImages.objectAtIndex(indexPath.row) as! String)
                self.downloadImage(url, imageView: cellImageView)
            }
            else
            {
                cellImageView.image = collectionImages.objectAtIndex(indexPath.row) as? UIImage
            }
        }
        else
        {
            cellImageView.image = collectionImages.objectAtIndex(indexPath.row) as? UIImage
        }
        cell.userInteractionEnabled = true
        return cell
    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        if self.shouldPickImages == true
        {
            return
        }
        
        if (sourceView == kSourceJobsCreated || sourceView == kSourceSearchJobs || sourceView == kSourceJobsApplied )
        {
            let url = String(format: urlGetResource, currentJob.jobId , collectionImages.objectAtIndex(indexPath.row) as! String)
            self.playVideoWithURL(url)
            return
        }
        if self.shouldPickVideos == true
        {
            let allKeys = self.pickedVideos.allKeysForObject(self.collectionImages .objectAtIndex(indexPath.row)) as NSArray!
            let url = allKeys.objectAtIndex(0) as! String
            self.playVideoWithURL(url)
        }
    }
    
    func downloadImage(url: String, imageView: UIImageView)
    {
        ImageLoader.sharedLoader.imageForUrl(url, completionHandler:{(image: UIImage?, url: String) in
            if image != nil
            {
                imageView.image = image
            }
        })
    }
}

