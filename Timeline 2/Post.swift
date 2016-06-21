//
//  Post.swift
//  Timeline 2
//
//  Created by Eva Marie Bresciano on 6/21/16.
//  Copyright © 2016 Eva Bresciano. All rights reserved.
//

import Foundation
import CoreData
import UIKit


class Post: SyncableObject {
    
    var photo: UIImage? {
    guard let photoData = self.photoData else { return nil }
    return UIImage(data: photoData)
    }
    
    static let kType = "Post"
    static let kPhotoData = "photoData"
    static let kTimestamp = "timestamp"
    
    convenience init(photo: NSData, timestamp: NSDate = NSDate(), context: NSManagedObjectContext = Stack.sharedStack.managedObjectContext) {
        
        guard let entity = NSEntityDescription.entityForName(Post.kType, inManagedObjectContext: context) else { fatalError() }
        
        self.init(entity: entity, insertIntoManagedObjectContext: context)
        self.photoData = photo
        self.timestamp = timestamp
        self.recordName = recordName //self.nameForManagedObject()
    }


}
