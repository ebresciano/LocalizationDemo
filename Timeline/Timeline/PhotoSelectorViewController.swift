//
//  PhotoSelectorViewController.swift
//  Timeline
//
//  Created by Eva Marie Bresciano on 6/14/16.
//  Copyright © 2016 Eva Bresciano. All rights reserved.
//

import UIKit

class PhotoSelectorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var addPhotoButton: UIButton!
   
    var delegate: PhotoSelectorViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Action Buttons
    
    @IBAction func selectImageButtonTapped(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        
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
            
            delegate?.photoSelectViewControllerSelected(image)
            addPhotoButton.setTitle("", forState: .Normal)
            imageView.image = image
        }
        
    }
    
   }

protocol PhotoSelectorViewControllerDelegate: class {
    
    func photoSelectViewControllerSelected(image: UIImage)
}
