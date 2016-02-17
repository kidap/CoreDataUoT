//
//  ImageFeedTableViewController.swift
//  PhotoFeed
//
//  Created by Mike Spears on 2016-01-08.
//  Copyright © 2016 YourOganisation. All rights reserved.
//

import UIKit
import CoreData

class ImageFeedTableViewController: UITableViewController {

    var feed: Feed? {
        didSet {
            self.tableView.reloadData()
        }
    }

    var urlSession: NSURLSession!

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        self.urlSession = NSURLSession(configuration: configuration)
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.urlSession.invalidateAndCancel()
        self.urlSession = nil
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.feed?.items.count ?? 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ImageFeedItemTableViewCell", forIndexPath: indexPath) as! ImageFeedItemTableViewCell
        
        let item = self.feed!.items[indexPath.row]
        cell.itemTitle.text = item.title


        
        let request = NSURLRequest(URL: item.imageURL)
        
        cell.dataTask = self.urlSession.dataTaskWithRequest(request) { (data, response, error) -> Void in
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                if error == nil && data != nil {
                    let image = UIImage(data: data!)
                    cell.itemImageView.image = image
                }
            })
            
        }
        
        
        
        cell.dataTask?.resume()
        
        return cell
    }

    override func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = cell as? ImageFeedItemTableViewCell {
            cell.dataTask?.cancel()
        }
    }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    var alertController = UIAlertController(title: "Add tag", message: "Please enter a tag name", preferredStyle: UIAlertControllerStyle.Alert)
    
    //Add cancel action
    var cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
    alertController.addAction(cancelAction)
    
    alertController.addTextFieldWithConfigurationHandler(nil)
    
    var addAction = UIAlertAction(title: "Add", style: UIAlertActionStyle.Default) { (action) -> Void in
      if let tagName = alertController.textFields![0].text{
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.dataController.tagFeedItem(tagName, feedItem: self.feed!.items[indexPath.row])
      }
    }
    
    alertController.addAction(addAction)
    self.presentViewController(alertController, animated: true, completion: nil)
    
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "showTags"{
      let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
      
      let tagsViewController = segue.destinationViewController as? TagsTableViewController
      let fetchRequest = NSFetchRequest(entityName: "Tag")
      
      fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
      
      tagsViewController?.fetchedResults = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: appDelegate.dataController.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
      
    }
    
  }

}
