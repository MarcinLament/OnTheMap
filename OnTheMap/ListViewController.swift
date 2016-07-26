//
//  ListViewController.swift
//  OnTheMap
//
//  Created by Marcin Lament on 14/05/2016.
//  Copyright © 2016 Marcin Lament. All rights reserved.
//

import Foundation
import UIKit

class ListViewController: UIViewController{
    
    @IBOutlet weak var checkinsTableView: UITableView!
    
    override func viewWillAppear(animated: Bool) {
        checkinsTableView.reloadData()
    }
    
    func refresh(){
        checkinsTableView.reloadData()
    }
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellReuseIdentifier = "CheckinsTableViewCell"
        let checkin = UserCheckinsStorage.instance.userCheckins[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as UITableViewCell!
        cell.textLabel!.text = checkin.firstName + " " + checkin.lastName
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserCheckinsStorage.instance.userCheckins.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let checkin = UserCheckinsStorage.instance.userCheckins[indexPath.row]
        UIApplication.sharedApplication().openURL(NSURL(string: checkin.mediaURL)!)
    }
}

