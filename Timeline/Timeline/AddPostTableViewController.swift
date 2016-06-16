//
//  AddPostTableViewController.swift
//  Timeline
//
//  Created by Eva Marie Bresciano on 6/13/16.
//  Copyright © 2016 Eva Bresciano. All rights reserved.
//

import UIKit

class AddPostTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var image: UIImage?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var captionTextField: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBOutlet weak var selectPhotoButton: UIButton!
        
    @IBAction func selectPhotoButtonTapped(sender: AnyObject) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        let actionSheet = UIAlertController(title: "Choose image source", message: nil, preferredStyle: .ActionSheet)
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .Default) { (_) in
            imagePicker.sourceType = .PhotoLibrary
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
        
        let cameraAction = UIAlertAction(title: "Camera", style: .Default) { (_) in
            imagePicker.sourceType = .Camera
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
        
        actionSheet.addAction(cancelAction)
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            actionSheet.addAction(cameraAction)
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
            actionSheet.addAction(photoLibraryAction)
        }
        
        presentViewController(actionSheet, animated: true, completion: nil)
    }
    
  
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        picker.dismissViewControllerAnimated(true, completion: nil)
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
        
        selectPhotoButton.setTitle(" ", forState: .Normal)
            imageView.image = image
        }
    }
    
    @IBAction func addPostButtonTapped(sender: AnyObject) {
        
        if let image = imageView.image,
        let caption = captionTextField.text {
            
            PostController.sharedController.createPost(image, caption: caption, completion: {
                
                
            })
            self.dismissViewControllerAnimated(true, completion: nil)
            
        } else {
            
            let alertController = UIAlertController(title: "Missing Information", message: "Add Caption.", preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .Cancel, handler: nil))
            
            presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
  
}