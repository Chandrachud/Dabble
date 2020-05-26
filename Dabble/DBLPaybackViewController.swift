//
//  DBLPaybackViewController.swift
//  Dabble
//
//  Created by Reddy on 11/09/15.
//  Copyright (c) 2015 Saxon Global Inc. All rights reserved.
//

import UIKit

class DBLPaybackViewController: UIViewController {
    
    @IBOutlet weak var routingNumberInput: UITextField!
    
    @IBOutlet weak var bankNameInput: UITextField!
    @IBOutlet weak var nameInput: UITextField!
    @IBOutlet weak var accountNumberInput: UITextField!
    
    @IBAction func moveBackToDashboard(sender: AnyObject)
    {
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
    
    @IBAction func proceedPayment(sender: AnyObject) {
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
