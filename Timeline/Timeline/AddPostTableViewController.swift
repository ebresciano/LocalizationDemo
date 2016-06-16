//
//  AddPostTableViewController.swift
//  Timeline
//
//  Created by Eva Marie Bresciano on 6/13/16.
//  Copyright © 2016 Eva Bresciano. All rights reserved.
//

import UIKit

class AddPostTableViewController: UITableViewController {
    
    var image: UIImage?
    
    @IBOutlet weak var captionTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func addPostButtonTapped(sender: AnyObject) {
        
        if let image = image,
        let caption = captionTextField.text {
            
            PostController.sharedController.createPost(image, caption: caption, completion: {
                
                self.dismissViewControllerAnimated(true, completion: nil)
            })
            
        } else {
            
            let alertController = UIAlertController(title: "Missing Information", message: "Add Caption.", preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .Cancel, handler: nil))
            
            presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "containerToImageView" {
            
            let embedViewController = segue.destinationViewController as? PhotoSelectorViewController
            embedViewController?.delegate = self
        }
    }
}

extension AddPostTableViewController: PhotoSelectorViewControllerDelegate {
    
    func photoSelectViewControllerSelected(image: UIImage) {
        
        self.image = image
    }
}