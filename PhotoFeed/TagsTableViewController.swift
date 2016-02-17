//
//  TagsTableViewController.swift
//  PhotoFeed
//
//  Created by Mike Spears on 2016-01-10.
//  Copyright © 2016 YourOganisation. All rights reserved.
//

import UIKit
import CoreData

class TagsTableViewController: UITableViewController {
  
  var fetchedResults : NSFetchedResultsController!
  
  
  override func viewWillAppear(animated: Bool) {
    do{
      try self.fetchedResults.performFetch()
    } catch {
      fatalError("failed to fetch results")
    }
  }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.fetchedResults.sections!.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.fetchedResults.sections![section].objects!.count
    }

  
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tagCell", forIndexPath: indexPath)
        let tag = fetchedResults.objectAtIndexPath(indexPath) as! Tag
        cell.textLabel?.text = tag.title

        // Configure the cell...

        return cell
    }
  

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

  
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
      
      if segue.identifier == "showImages"{
        let imageFeedVC = segue.destinationViewController as! ImageFeedTableViewController
        let tag = self.fetchedResults.objectAtIndexPath(self.tableView.indexPathForSelectedRow!) as! Tag
        
        var feedItems = [FeedItem]()
        if let images = tag.images?.allObjects as? [Image]{
          
          for image in images{
            feedItems.append(FeedItem(title: image.title!, imageURL: NSURL(string: image.imageURL!)!))
            
          }
        
        }
        
        let feed : Feed = Feed(items: feedItems, sourceURL: NSURL())
        
        imageFeedVC.feed = feed
      }
    }
  

}
