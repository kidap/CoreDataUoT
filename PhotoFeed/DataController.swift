//
//  DataController.swift
//  PhotoFeedCoreData
//
//  Created by Karlo Pagtakhan on 02/16/2016.
//  Copyright © 2016 YourOganisation. All rights reserved.
//

import Foundation
import CoreData


class DataController{
  let managedObjectContext: NSManagedObjectContext
  
  init(moc: NSManagedObjectContext){
    managedObjectContext = moc
  }
  
  
  convenience init?(){
    guard let modelURL = NSBundle.mainBundle().URLForResource("Model", withExtension: "momd") else {
      return nil
    }
    
    guard let mom = NSManagedObjectModel(contentsOfURL: modelURL) else{
      return nil
    }
    
    let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
    let moc = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
    
    moc.persistentStoreCoordinator = psc
    
    let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
    let persistentStoreFileURL = urls[0].URLByAppendingPathComponent("Bookmarks.sqlite")
    
    do {
      try psc.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: persistentStoreFileURL, options: nil)
    } catch {
      fatalError("Errod adding store")
    }
    
    self.init(moc: moc)
    
  }
  
  func tagFeedItem(tagTitle: String, feedItem: FeedItem){
    
    //Create a predicate that will filter the title to the tag title sent to this func
    var fetchRequest = NSFetchRequest(entityName: "Tag")
    fetchRequest.predicate = NSPredicate(format: "title = %@", tagTitle)
    
    var fetchedTags: [Tag]
    do{
      fetchedTags = try self.managedObjectContext.executeFetchRequest(fetchRequest) as! [Tag]
    } catch{
      fatalError("fetch failed")
    }
  
    
    //If the tag does not yet exist, create the tag entity
    var tag: Tag
    if fetchedTags.count == 0{
      tag = NSEntityDescription.insertNewObjectForEntityForName("Tag", inManagedObjectContext: managedObjectContext) as! Tag
      tag.title = tagTitle
    } else{
      tag = fetchedTags[0]
    }
    
    //Check if the image has already been assigned that tag
    fetchRequest = NSFetchRequest(entityName: "Image")
    fetchRequest.predicate = NSPredicate(format: "imageURL = %@", feedItem.imageURL.absoluteString)
    
    var fetchedImages = [Image]()
    do{
      fetchedImages = try self.managedObjectContext.executeFetchRequest(fetchRequest) as! [Image]
    } catch {
      
    }
    
    //Create the image entity
    if fetchedImages.count == 0{
      var newImage: Image
      newImage = NSEntityDescription.insertNewObjectForEntityForName("Image", inManagedObjectContext: managedObjectContext) as! Image
      newImage.title = tagTitle
      newImage.imageURL = feedItem.imageURL.absoluteString
      newImage.tag = tag
      
      do{
        try self.managedObjectContext.save()
      } catch{
        
      }
    }
    
  
  }
  
  
  
  
}

