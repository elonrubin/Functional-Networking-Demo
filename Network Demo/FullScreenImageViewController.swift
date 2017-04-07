//
//  FullScreenImageViewController.swift
//  Network Demo
//
//  Created by Elon Rubin on 4/4/17.
//  Copyright © 2017 Elon Rubin. All rights reserved.
//

import UIKit

class FullScreenImageViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!

    var postTuple = (id: String(), url: String())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = UIColor.white
        PostManager.fetchImageFromCache(urlString: postTuple.url, id: postTuple.id, for: imageView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}
