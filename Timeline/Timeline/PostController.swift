//
//  PostController.swift
//  Timeline
//
//  Created by Eva Marie Bresciano on 6/13/16.
//  Copyright © 2016 Eva Bresciano. All rights reserved.
//

import Foundation
import UIKit

class PostController {
    
    static let sharedController = PostController()
    
    func saveContext() {
        do {
            try Stack.sharedStack.managedObjectContext.save()
        } catch {
            print("Could not save")
       }
    }
    
    func createPost(image: UIImage, caption: String, completion: (() -> Void)?) {
        guard let data = UIImageJPEGRepresentation(image, 0.8) else { return }
        
        let post = Post(photo: data)
        
        addCommentToPost(caption, post: post, completion: nil)
        
        saveContext()
        
        }
    
    func addCommentToPost(text: String, post: Post, completion: ((success: Bool) -> Void)?) {
        
        _ = Comment(post: post, text: text)
        
        saveContext()
    
    }
}
    
