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
  
}

