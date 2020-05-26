//
//  HomeMapViewController.swift
//  Dabble
//
//  Created by Reddy on 6/30/15.
//  Copyright (c) 2015 Saxon Global Inc. All rights reserved.
//

import UIKit

class HomeMapViewController: UIViewController {

    @IBAction func MoveBackToJobs(sender: AnyObject) {
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
