//
//  DBLFAQsViewController.swift
//  Dabble
//
//  Created by Reddy on 25/10/15.
//  Copyright © 2015 Saxon Global Inc. All rights reserved.
//

import UIKit

class DBLFAQsViewController: UIViewController, UIWebViewDelegate
{
    @IBOutlet weak var faqWebView: UIWebView!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(animated: Bool)
    {
        faqWebView.delegate = self
        faqWebView.loadRequest(NSURLRequest(URL: NSURL(string:urlFaqRequest)!))
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool
    {
        appDelegate.showLoadingView(nil)
        return true
    }
    
    func webViewDidFinishLoad(webView: UIWebView)
    {
        appDelegate.hideLoadingView()
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?)
    {
        appDelegate.showToastMessage("Error", message: "We are not able to process the request. Please try again later.")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showMenu(sender: AnyObject)
    {
        let mainVC = self.mainSlideMenu()
        mainVC.openLeftMenu()
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
