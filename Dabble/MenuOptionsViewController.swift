//
//  MenuOptionsViewController.swift
//  Dabble
//
//  Created by Reddy on 7/8/15.
//  Copyright (c) 2015 Saxon Global Inc. All rights reserved.
//

import UIKit

class MenuOptionsViewController: AMSlideMenuLeftTableViewController
{
    override func viewDidLoad() {
        super.viewDidLoad()


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func abc(indexPath: NSIndexPath)
    {
        self.mainVC!.segueIdentifierForIndexPathInLeftMenu(indexPath)
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

func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
{
    return 10;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
{
    let cellIdentifier : String = "MenuCell";
    var jobCell : UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? UITableViewCell!
    if (jobCell == nil)
    {
        jobCell = UITableViewCell(style: UITableViewCellStyle.Default , reuseIdentifier: cellIdentifier)
    }
    return jobCell!;
}

func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
{
    print("%i", indexPath.row, terminator: "")
//    self.abc(indexPath)
    tableView.reloadData()
    
 /*
    NSString *segueIdentifier = [self.mainVC segueIdentifierForIndexPathInLeftMenu:indexPath];
    if (segueIdentifier && segueIdentifier.length > 0)
    {
        [self performSegueWithIdentifier:segueIdentifier sender:self];
    }
   */
}

