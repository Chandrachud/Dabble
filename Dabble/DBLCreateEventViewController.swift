//
//  DBLCreateEventViewController.swift
//  Dabble
//
//  Created by Reddy on 18/08/15.
//  Copyright (c) 2015 Saxon Global Inc. All rights reserved.
//

import UIKit

class DBLCreateEventViewController: UIViewController {

    @IBOutlet weak var eventItemsHolder: UIView!
    @IBOutlet weak var eventScroller: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    override func viewDidLoad() {
        super.viewDidLoad()

        eventScroller.contentSize = eventItemsHolder.frame.size
        eventScroller.pagingEnabled = true
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
