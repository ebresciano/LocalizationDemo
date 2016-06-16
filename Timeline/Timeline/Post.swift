//
//  Post.swift
//  Timeline
//
//  Created by Eva Marie Bresciano on 6/13/16.
//  Copyright © 2016 Eva Bresciano. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Post: SyncableObject, SearchableRecord {
    
    static let kType = "Post"
    static let kPhotoData = "photoData"
    static let kTimestamp = "timestamp"
    
    convenience init(photo: NSData, timestamp: NSDate = NSDate(), context: NSManagedObjectContext = Stack.sharedStack.managedObjectContext) {
        
        guard let entity = NSEntityDescription.entityForName(Post.kType, inManagedObjectContext: context) else { fatalError() }
        
        self.init(entity: entity, insertIntoManagedObjectContext: context)
        
        self.photoData = photo
        
        self.timestamp = timestamp
        
        self.recordName = NSUUID().UUIDString
        
    }
    
    var photo: UIImage? {
        
        guard let photoData = self.photoData else {
            return nil
        }
        
        return UIImage(data: photoData)
    }
    
    func matchesSearchTerm(searchTerm: String) -> Bool {
        
        return (self.comment?.array as? [Comment])?.filter({$0.matchesSearchTerm(searchTerm)}).count < 0
    }
    
    
}




