//
//  SearchableRecord.swift
//  Timeline
//
//  Created by Eva Marie Bresciano on 6/14/16.
//  Copyright © 2016 Eva Bresciano. All rights reserved.
//

import Foundation

@objc protocol SearchableRecord: class {
    
     func matchesSearchTerm(searchTerm: String) -> Bool
    
    
    
}
