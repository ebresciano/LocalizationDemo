//
//  PostListTableViewController.swift
//  Timeline
//
//  Created by Eva Marie Bresciano on 6/13/16.
//  Copyright © 2016 Eva Bresciano. All rights reserved.
//

import UIKit
import CoreData

class PostListTableViewController: UITableViewController, NSFetchedResultsControllerDelegate,

    UISearchResultsUpdating {
    
    var fetchedResultsController: NSFetchedResultsController?
    
    var searchController: UISearchController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpFetchedResultsController()
        setUpSearchController()
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
        
        let request = NSFetchRequest(entityName: "Post")
        let dateSortDescription = NSSortDescriptor(key: "timestamp", ascending: false)
        
        request.returnsObjectsAsFaults = false
        request.sortDescriptors = [dateSortDescription]
        
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: Stack.sharedStack.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try fetchedResultsController?.performFetch()
        } catch let error as NSError {
            print("Unable to fetch results")
        }
        
        fetchedResultsController?.delegate = self
    }
    
    func setUpSearchController() {
        let resultsController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("SearchResultsTableViewController")
        searchController?.searchResultsUpdater = self
        searchController = UISearchController(searchResultsController: resultsController)
        tableView.tableHeaderView = searchController?.searchBar
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        guard let searchResultsController = searchController.searchResultsController as? SearchResultsTableViewController,
            let searchTerm = searchController.searchBar.text,
            let posts = fetchedResultsController?.fetchedObjects as? [Post] else {
                return
        }
        
        searchResultsController.resultsArray = posts.filter({$0.matchesSearchTerm(searchTerm)})
        searchResultsController.tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier("postTableViewCell", forIndexPath: indexPath)  as? PostTableViewCell,
            let post = fetchedResultsController?.objectAtIndexPath(indexPath) as? Post else {
                return PostTableViewCell()
        }
        
        cell.updateWithPost(post)
        
        return cell
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toDetailSegue" {
            if let PostDetailTableViewController = segue.destinationViewController as? PostDetailTableViewController,
                let indexPath = self.tableView.indexPathForSelectedRow,
                let post = fetchedResultsController?.objectAtIndexPath(indexPath) as? Post {
                
                PostDetailTableViewController.post = post
            }
        }
    }
    
}
