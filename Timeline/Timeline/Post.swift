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
import CloudKit

class Post: SyncableObject, SearchableRecord, CloudkitManagedObject {
    
    static let kType = "Post"
    static let kPhotoData = "photoData"
    static let kTimestamp = "timestamp"
    
    convenience init(photo: NSData, timestamp: NSDate = NSDate(), context: NSManagedObjectContext = Stack.sharedStack.managedObjectContext) {
        
        guard let entity = NSEntityDescription.entityForName(Post.kType, inManagedObjectContext: context) else { fatalError() }
        
        self.init(entity: entity, insertIntoManagedObjectContext: context)
        self.photoData = photo
        self.timestamp = timestamp
        self.recordName = self.nameForManagedObject()
    }
    
    var photo: UIImage? {
        
        guard let photoData = self.photoData else { return nil }
        
        return UIImage(data: photoData)
    }
    
    lazy var temporaryPhotoURL: NSURL = {
        
        // Must write to temporary directory to be able to pass image file path url to CKAsset
        
        let temporaryDirectory = NSTemporaryDirectory()
        let temporaryDirectoryURL = NSURL(fileURLWithPath: temporaryDirectory)
        let fileURL = temporaryDirectoryURL.URLByAppendingPathComponent(self.recordName).URLByAppendingPathExtension("jpg")
        
        self.photoData?.writeToURL(fileURL, atomically: true)
        
        return fileURL
    }()
    
    // MARK: - Searchable Record Method
    
    func matchesSearchTerm(searchTerm: String) -> Bool {
        
        return (self.comment?.array as? [Comment])?.filter({$0.matchesSearchTerm(searchTerm)}).count > 0
    }
    
    // MARK: - CloudKitManagedObject Methods
    
    var recordType: String = Post.kType
    
    var cloudKitRecord: CKRecord? {
        
        let recordID = CKRecordID(recordName: recordName)
        let record = CKRecord(recordType: recordType, recordID: recordID)
        
        record[Post.kTimestamp] = timestamp
        record[Post.kPhotoData] = CKAsset(fileURL: temporaryPhotoURL)
        return record
        
        }
    
    convenience required init?(record: CKRecord, context: NSManagedObjectContext = Stack.sharedStack.managedObjectContext) {
        
        guard let timestamp = record.creationDate,
            let photoData = record[Post.kPhotoData] as? CKAsset else {
                return nil
        }
        
    guard let entity = NSEntityDescription.entityForName(Post.kType, inManagedObjectContext: context)
        else { fatalError("Error: CoreData failed to create entity from entity description. \(#function)") }
        
        self.init(entity: entity, insertIntoManagedObjectContext: context)
        
        self.timestamp = timestamp
        self.photoData = NSData(contentsOfURL: photoData.fileURL)
        self.recordIDData = NSKeyedArchiver.archivedDataWithRootObject(record.recordID)
        self.recordName = record.recordID.recordName
    }

    
}




