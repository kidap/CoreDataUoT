//
//  Tag+CoreDataProperties.swift
//  PhotoFeedCoreData
//
//  Created by Karlo Pagtakhan on 02/15/2016.
//  Copyright © 2016 YourOganisation. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Tag {

    @NSManaged var title: String?
    @NSManaged var images: NSSet?

}
