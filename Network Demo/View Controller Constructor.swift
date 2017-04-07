//
//  View Controller Constructor.swift
//  Network Demo
//
//  Created by Elon Rubin on 4/4/17.
//  Copyright © 2017 Elon Rubin. All rights reserved.
//

import Foundation
import UIKit

extension FeedViewController {
    
    func constructAlertController () -> UIAlertController {
    let alertController = UIAlertController(title: "Choose How You'd Like To Sort Posts", message: nil, preferredStyle: .actionSheet)
    
    
    let allPostsAction = UIAlertAction(title: "All Posts", style: .default) { (action) in
        self.posts = PostManager.allPosts.sorted{$0.date > $1.date}
        DispatchQueue.main.async {
            self.title = "All Posts"
            self.tableView.reloadData()
            self.dismiss(animated: true, completion: nil)
        }
    
    }
    alertController.addAction(allPostsAction)
    
    let textPostsAction = UIAlertAction(title: "Text Posts", style: .default) { (action) in
        
        let filteredPosts = PostManager.allPosts.filter{$0.type == "text"}.sorted{$0.date > $1.date}
        self.posts = filteredPosts
        
        DispatchQueue.main.async {
            self.title = "Text Posts"
            self.tableView.reloadData()
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    alertController.addAction(textPostsAction)
    
    
    let imagePostsAction = UIAlertAction(title: "Image Posts", style: .default) { (action) in
        
        let filteredPosts = PostManager.allPosts.filter {$0.type == "image"}.sorted{$0.date > $1.date}
        self.posts = filteredPosts
        
        DispatchQueue.main.async {
            self.title = "Image Posts"
            self.tableView.reloadData()
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    alertController.addAction(imagePostsAction)
    
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (action) in
        self.dismiss(animated: true, completion: nil)
        
    }
    alertController.addAction(cancelAction)
    
    return alertController
  
    }
}
