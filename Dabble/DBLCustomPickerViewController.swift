//
//  DBLCustomPickerViewController.swift
//  Dabble
//
//  Created by Reddy on 7/14/15.
//  Copyright (c) 2015 Saxon Global Inc. All rights reserved.
//

import UIKit

protocol CustomDatePickerDelegate
{
    func hidePickerView(sender: UIBarButtonItem)->Void
    func pickedDate(sender: NSDate)->Void
}

protocol customPickerDelegate
{
    func hidePickerView(sender: UIBarButtonItem)->Void
    func pickValue(sender: NSDate)->Void
}

class DBLCustomPickerViewController: UIViewController
{
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet var dateTimePicker: UIDatePicker!
    
    var delegate:CustomDatePickerDelegate?
//    var pickerDelegate: customPickerDelegate?
    
    @IBAction func pickDate(sender: UIBarButtonItem)
    {
        self.delegate?.pickedDate(dateTimePicker.date)
    }
    
    @IBAction func cancelDatePicker(sender: UIBarButtonItem)
    {
        self.delegate?.hidePickerView(sender)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

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
