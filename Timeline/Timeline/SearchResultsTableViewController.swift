//
//  SearchResultsTableViewController.swift
//  Timeline
//
//  Created by Eva Marie Bresciano on 6/13/16.
//  Copyright © 2016 Eva Bresciano. All rights reserved.
//

import UIKit

class SearchResultsTableViewController: UITableViewController {
    
    var resultsArray: [SearchableRecord] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        print(resultsArray)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print(resultsArray.count)
        return resultsArray.count 
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        print(resultsArray)
         guard let cell = tableView.dequeueReusableCellWithIdentifier("resultsCell", forIndexPath: indexPath) as? PostTableViewCell,
        let result = resultsArray[indexPath.row] as? Post else {
            return UITableViewCell()
        }
        cell.updateWithPost(result)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        self.presentingViewController?.performSegueWithIdentifier("toPostDetailFromSearch", sender: cell)
    }

}