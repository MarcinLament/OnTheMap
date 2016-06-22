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
    
    var userCheckins: [UserCheckin] {
        return OTMClient.sharedInstance().userCheckins
//        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
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
        
        /* Get cell type */
        let cellReuseIdentifier = "CheckinsTableViewCell"
        let checkin = userCheckins[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as UITableViewCell!
        
        /* Set cell defaults */
        cell.textLabel!.text = checkin.firstName + " " + checkin.lastName
//        cell.imageView!.image = UIImage(named: "Film")
//        cell.imageView!.contentMode = UIViewContentMode.ScaleAspectFit
//        
//        if let posterPath = movie.posterPath {
//            TMDBClient.sharedInstance().taskForGETImage(TMDBClient.PosterSizes.RowPoster, filePath: posterPath, completionHandlerForImage: { (imageData, error) in
//                if let image = UIImage(data: imageData!) {
//                    performUIUpdatesOnMain {
//                        cell.imageView!.image = image
//                    }
//                } else {
//                    print(error)
//                }
//            })
//        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userCheckins.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let checkin = userCheckins[indexPath.row]
        UIApplication.sharedApplication().openURL(NSURL(string: checkin.mediaURL)!)

//        let controller = storyboard!.instantiateViewControllerWithIdentifier("MovieDetailViewController") as! MovieDetailViewController
//        controller.movie = movies[indexPath.row]
//        navigationController!.pushViewController(controller, animated: true)
    }
    
//    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        return 100
//    }
}

