//
//  CloudKitManagedObject.swift
//  Timeline
//
//  Created by Eva Marie Bresciano on 6/16/16.
//  Copyright © 2016 Eva Bresciano. All rights reserved.
//

import Foundation
import CloudKit
import CoreData

@objc protocol CloudKitManagedObject {
    
    var timestamp: NSDate {get set}
    var recordIDData: NSData? {get set}
    var recordName: String {get set}
    var recordType: String {get}
    
    var cloudKitRecord: CKRecord? { get } // CoreData version of "dictionaryCopy"
    
    init?(record: CKRecord, context: NSManagedObjectContext)
}

extension CloudKitManagedObject {
    
    var isSynced: Bool {
        return recordIDData != nil
    }
    
    var cloudKitRecordID: CKRecordID? {
        guard let recordIDData = recordIDData,
            let recordID = NSKeyedUnarchiver.unarchiveObjectWithData(recordIDData) as? CKRecordID else { return nil
        }
        
        return recordID
    }
    
    var cloudKitReference: CKReference? {
        guard let recordID = cloudKitRecordID else {
            return nil
        }
        return CKReference(recordID: recordID, action: .None)
    }
    
    func update(record: CKRecord) {
        self.recordIDData = NSKeyedArchiver.archivedDataWithRootObject(record.recordID)
        do {
            try Stack.sharedStack.managedObjectContext.save()
        } catch {
            print("Unable to save Managed Object Context in \(#function) \nError: \(error)")
        }
    }
    
    func nameForManagedObject() -> String {
        return NSUUID().UUIDString
    }
}
