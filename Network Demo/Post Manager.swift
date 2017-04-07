//
//  API Client.swift
//  Networking Demo
//
//  Created by Elon Rubin on  4/3/17.
//  Copyright © 2017 Elon Rubin. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage
import SwiftyJSON

typealias PhotoVerificationCompletionHandler = (_ isValidated: Bool) -> Void

class PostManager {
    
    
   // static var posts = [Post]()
    static var textPosts = [Post]()
    static var imagePosts = [Post]()
    static var allPosts = PostManager.textPosts + PostManager.imagePosts
    
    private static let imageCache = AutoPurgingImageCache()
    private static let downloader = ImageDownloader()
    
    
    static var numberOfPhotoPosts = 0 {
        didSet {
       //     print(numberOfPhotoPosts, numberOfPhotoPostsWhereValidationIsComplete)
        }
        
    }
    static var numberOfPhotoPostsWhereValidationIsComplete = 0 {
        didSet {
       //     print(numberOfPhotoPosts, numberOfPhotoPostsWhereValidationIsComplete)
            if numberOfPhotoPostsWhereValidationIsComplete == numberOfPhotoPosts {
                
                NotificationCenter.default.post(name: Notification.Name(rawValue: "postsExtracted"), object: nil)
            }
        }
    }
    
    
    static func getPosts() {
        
        // 1 - Make HTTP Request To Server
        Alamofire.request("http://quizzes.fuzzstaging.com/quizzes/mobile/1/data.json").responseJSON { (responseData) -> Void in
            
            // 2 - Guard against JSON not extracting
            guard let rawData = responseData.result.value else {
                return
            }
           
            let postsRawData = JSON(rawData).arrayValue
            
            // 3 - Handle JSON Data
            
            let extractedPosts = postsRawData.map{ // 3a - map JSON data,
                   
                Post(id: $0["id"].stringValue, type: $0["type"].stringValue, date: $0["date"].stringValue, data: $0["data"].stringValue) // Initialize each element with fallable initilizer using shorthand arguments. If element does not meet conditions in Post.swift, returns nil.
                
                }.filter {
                    $0 != nil
                    
                }.map {
                    $0!
                }
            
            // 4 - Validate Pictures
            
                self.textPosts = extractedPosts.filter{$0.type == "text"} //4a - extract text posts to data source posts
            
            
                //4b - for each image post, validate whether it is valid through isImageValidated function. Called async. When the function completes, it passes a isValidated bool to an escaping completion handler. Validated photos are added to data source. numberOfPhotoPostsWhereValidationIsComplete int is incremented by one
                for post in extractedPosts where post.type == "image" {
                   isImageValidated(from: post.data, completion: { (isValidated) in
                    if (isValidated) {
                        self.imagePosts.append(post)
                        self.numberOfPhotoPostsWhereValidationIsComplete += 1
                        print("validated")
                    } else {
                        self.numberOfPhotoPostsWhereValidationIsComplete += 1
                        print("not validated")
                    }
                    
                   })
                }

           
        }

        
    }
    
    static func urlContainsProperSyntax (urlString: String) -> Bool {
        guard (urlString.contains(".jpg")) || (urlString.contains(".png")) ||
            (urlString.contains(".gif")) || (urlString.contains(".jpeg")) else {
                return false
        }
        numberOfPhotoPosts += 1 // increment number of picture posts by one
        return true
    }
    
    
    
    static func isImageValidated (from urlString: String, completion: @escaping PhotoVerificationCompletionHandler) {
     
        var request = URLRequest(url: NSURL.init(string: urlString) as! URL)
        request.timeoutInterval = 5 // make sure to add this to stack overflow // timeout if request doesn't get a response within 5 seconds 
        Alamofire.request(request)
        .validate(statusCode: 200..<300) // validate status code
        .validate(contentType: ["image/png", "image/jpeg"]) // validate matching content type
        .responseData { response in
         
            
            guard response.result.error == nil else {
                print(response.result.error)
                completion(false)
                return
            }
            
            let contentType = String(describing: response.response?.allHeaderFields["Content-Type"])
            print(contentType)
            completion(true)
            
        }
    }
    
     static func convertStringToDate(date string: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/mm/yy"
        return dateFormatter.date(from: string)!
    }
    
    static func getImageForPost (post: Post, for imageView: UIImageView) {
        
        let urlRequest = URLRequest(url: URL(string: post.data)!)
        if let image = imageCache.image(for: urlRequest, withIdentifier: post.id) {
           print("got from cache")
            imageView.image = image
        } else {
            let urlRequest = URLRequest(url: URL(string: post.data)!)
            downloader.download(urlRequest) { response in
             
                if let image = response.result.value {
                    imageCache.add(image, for: urlRequest, withIdentifier: post.id)
                    print("downloaded image")
                 DispatchQueue.main.async {
                    imageView.image = image
                    }
                } else {
                     DispatchQueue.main.async {
                    imageView.image = nil
                    }
                }
                    
            }
        }
    }
    
    static func fetchImageFromCache (urlString: String, id: String, for imageView: UIImageView) {
        
        let urlRequest = URLRequest(url: URL(string: urlString)!)
        let image = imageCache.image(for: urlRequest, withIdentifier: id)
       DispatchQueue.main.async {
        imageView.image = image
        }
    }
}
