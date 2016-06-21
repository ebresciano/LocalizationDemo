//
//  PostDetailTableViewController.swift
//  Timeline
//
//  Created by Eva Marie Bresciano on 6/13/16.
//  Copyright © 2016 Eva Bresciano. All rights reserved.
//

import UIKit
import CoreData
import CloudKit

class PostDetailTableViewController: UITableViewController {
    
    var post: Post?
    
    var comments: [Comment] = []
    
    var fetchedResultsController: NSFetchedResultsController?
    
    @IBOutlet weak var followButton: UIBarButtonItem!
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        self.tableView.estimatedRowHeight = 60
    }
    
    func updateWithPost(post: Post) {
        
        imageView.image = post.photo
        
        PostController.sharedController.checkSubscriptionToPostComments(post) { (subscribed) in
            
            dispatch_async(dispatch_get_main_queue(), {
                self.followButton.title = subscribed ? "Unfollow Post" : "Follow Post"
            })
        }
    }
    
    func presentCommentAlert() {
        let alertController = UIAlertController(title: "Add Comment", message: nil, preferredStyle: .Alert)
    
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = " "
        }
        let addCommentAction = UIAlertAction(title: "Add Comment", style: .Default) { (action) in
            
            guard let commentText = alertController.textFields?.first?.text,
                let post = self.post else { return }
            
            PostController.sharedController.addCommentToPost(commentText, post: post, completion:nil)
        }
        alertController.addAction(addCommentAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
        // MARK: - Actions
        
        @IBAction func commentButton(sender: AnyObject) {
            presentCommentAlert()
        }
        
        @IBAction func shareButton(sender: AnyObject) {
            presentActivityViewController()
        }
        
        @IBAction func followButton(sender: AnyObject) {
            guard let post = post else { return }
            
            PostController.sharedController.togglePostCommentSubscription(post) { (success, isSubscribed, error) in
                
                self.updateWithPost(post)
            }
        }
        // MARK: - Table view data source
        
        override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
            guard let sections = fetchedResultsController?.sections else { return 1 }
            return sections.count
            
        }
        
        override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            guard let sections = fetchedResultsController?.sections else { return 0 }
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        
        override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCellWithIdentifier("postDetailCell", forIndexPath: indexPath)
            if let comment = fetchedResultsController?.objectAtIndexPath(indexPath) as? Comment {
                
              cell.textLabel?.text = comment.text
               cell.detailTextLabel?.text = comment.recordName
                
            }
            
            return cell
    }
    
    func presentActivityViewController() {
        
        guard let photo = post?.photo,
            let comment = post?.comment?.firstObject as? Comment,
            let text = comment.text else { return }
        
        let activityViewController = UIActivityViewController(activityItems: [photo, text], applicationActivities: nil)
        presentViewController(activityViewController, animated: true, completion: nil)
    }
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Delete:
            guard let indexPath = indexPath else {return}
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        case .Insert:
            guard let newIndexPath = newIndexPath else {return}
            tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Automatic)
        case .Move:
            guard let indexPath = indexPath,
                newIndexPath = newIndexPath else {return}
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Automatic)
        case .Update:
            guard let indexPath = indexPath else {return}
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        switch type {
        case .Delete:
            tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Automatic)
        case .Insert:
            tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Automatic)
        default:
            break
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }
    
        
}