//
//  Comment.swift
//  Timeline
//
//  Created by Eva Marie Bresciano on 6/13/16.
//  Copyright © 2016 Eva Bresciano. All rights reserved.
//

import Foundation
import CoreData
import CloudKit

class Comment: SyncableObject, SearchableRecord, CloudkitManagedObject {
    
    static let kType = "Comment"
    static let kText = "text"
    static let kPost = "post"
    static let kTimestamp = "timestamp"
    
    convenience init(post: Post, text: String, timestamp: NSDate = NSDate(), context: NSManagedObjectContext = Stack.sharedStack.managedObjectContext) {
        
        guard let entity = NSEntityDescription.entityForName(Comment.kType, inManagedObjectContext: context) else { fatalError() }
        
        self.init(entity: entity, insertIntoManagedObjectContext: context)
        
        self.text = text
        self.timestamp = timestamp
        self.post = post
        self.recordName = nameForManagedObject()
    }
    
    // MARK: - Searchable Record Methods
    
    
    func matchesSearchTerm(searchTerm: String) -> Bool {
        return text?.containsString(searchTerm) ?? false
    }
    
    // MARK: - CloudKit Managed Object Methods
    
    var recordType: String = kType
    
    var cloudKitRecord: CKRecord? {
        let recordID = CKRecordID(recordName: recordName)
        let record = CKRecord(recordType: recordType, recordID: recordID)
        
        record[Comment.kText] = text
        record[Comment.kTimestamp] = timestamp
        
        guard let post = post,
            postRecord = post.cloudKitRecord else {
                fatalError("Comment dont have no Post relationship. \(#function)")
        }
        
        record[Comment.kPost] = CKReference(record: postRecord, action: .DeleteSelf)
        return record
    }
    
    convenience required init?(record: CKRecord, context: NSManagedObjectContext = Stack.sharedStack.managedObjectContext) {
        guard let timestamp = record.creationDate,
            text = record[Comment.kText] as? String,
            postReference = record[Comment.kPost] as? CKReference else {
                return nil
        }
        
        guard let entity = NSEntityDescription.entityForName(Comment.kType, inManagedObjectContext: context)
            else {
                fatalError("Error: Core Data Failed to create Entity from Entity description \(#function)")
        }
        
        self.init(entity: entity, insertIntoManagedObjectContext: context)
        self.timestamp = timestamp
        self.text = text
        self.recordIDData = NSKeyedArchiver.archivedDataWithRootObject(record.recordID)
    
    
        if let post = PostController.sharedController.postWithName(postReference.recordID.recordName) {
            self.post = post 
        }
    
    }
    
}














