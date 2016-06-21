//
//  PostTableViewCell.swift
//  Timeline 2
//
//  Created by Eva Marie Bresciano on 6/21/16.
//  Copyright © 2016 Eva Bresciano. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var postImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateWithPost(post: Post) {
        
        postImageView.image = post.photo
        
    }


}
