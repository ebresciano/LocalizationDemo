//
//  PostListTableViewController.swift
//  Timeline 2
//
//  Created by Eva Marie Bresciano on 6/21/16.
//  Copyright © 2016 Eva Bresciano. All rights reserved.
//

import UIKit
import CoreData

class PostListTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var fetchedResultsController: NSFetchedResultsController?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 60
        setUpFetchedResultsController()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        guard let sections = fetchedResultsController?.sections else { return 1 }
        return sections.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController?.sections else {return 0}
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }
    
    func setUpFetchedResultsController() {
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier("PotsTableViewCell", forIndexPath: indexPath) as? PostTableViewCell,
        let post = fetchedResultsController?.objectAtIndexPath(indexPath) as? Post else {
            return PostTableViewCell()
        }

        return cell
    }
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toPostDetail" {
            if let PostDetailTableViewController = segue.destinationViewController as?
                PostDetailTableViewController,
            let indexPath = self.tableView.indexPathForSelectedRow,
            let post = fetchedResultsController?.objectAtIndexPath(indexPath) as? Post {
                
                PostDetailTableViewController.post = post
            }
        }
    }


}
