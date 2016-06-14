//
//  Comment.swift
//  Timeline
//
//  Created by Eva Marie Bresciano on 6/13/16.
//  Copyright © 2016 Eva Bresciano. All rights reserved.
//

import Foundation
import CoreData

class Comment {
    
    static let kType = "Comment"
    static let kText = "text"
    static let kPost = "post"
    static let kTimestamp = "timestamp"
    
    convenience init(post: Post, text: String, timestamp: NSDate = NSDate(), context: NSManagedObjectContext = Stack.sharedStack.managedObjectContext) {
        
        guard let entity = NSEntityDescription.entityForName(Comment.kType, inManagedObjectContext: context) else { fatalError() }
        
        self.init?(entity: entity, insertIntoManagedObjectContext: context)
        
        self.text = text
        self.timestamp = timestamp
        self.post = post

        
    }
    
}