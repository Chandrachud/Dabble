//
//  DBLViewProfileViewController.swift
//  Dabble
//
//  Created by Reddy on 7/20/15.
//  Copyright (c) 2015 Saxon Global Inc. All rights reserved.
//


import UIKit

class DBLViewProfileViewContorller : UIViewController {
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var scrollViewItemsHolder: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.contentSize = scrollViewItemsHolder.frame.size
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
