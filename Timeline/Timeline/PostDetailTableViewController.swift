//
//  PostDetailTableViewController.swift
//  Timeline
//
//  Created by Eva Marie Bresciano on 6/13/16.
//  Copyright © 2016 Eva Bresciano. All rights reserved.
//

import UIKit
import CoreData

class PostDetailTableViewController: UITableViewController {
    
    var post: Post?
    
    var comments: [Comment] = []
    
    var fetchedResultsController: NSFetchedResultsController?
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        self.tableView.estimatedRowHeight = 60
    }
    
    func updateWithPost(post: Post) {
        
        imageView.image = post.photo
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
        
        
}