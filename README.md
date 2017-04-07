# Functional Networking Demo

## Installation Instructions
* (1) Unzip file
* (2) Install Pods
  * Open Terminal
  * Type "cd + \(filepathToRootDirectory)"
    * You can drag the file directory to terminal   
  * Once you are in, type "pod install"

## Notes
* Coded in XCode 8.2.1 and Swift 3.0.1
* Build Target - iOS 9.0+
* Cocoapods: Alamofire, Alamoimage, SwiftyJSON, Swift Spinner
* Launches provided endpoint, which is used to create model
* Ability to sort feed based upon all, text and images
* Tapping on a tableview cell with a text item opens a web browser with the provided link
* Tapping on a tableview cell with a image item opens the selected image in a full page viewer

## Other Notes
* The model is comprised of a Post object and a Post Manager class. 
* The Post Manager, in a static method, getPosts, makes a request to the provided endpoint via an Alamofire request. The response is converted to JSON, then mapped. Each property of the Post object is inputted into the Post initilizer, which is failable.
* All Post properties are required for proper initialzer and an image type must include proper syntax, otherwise the initialization returns a nil object. Additionally, the date string is converted into a Date .
* Once all elements are put through the failiable initilizer, the array filters out nil values, then force unwraps each Post object.
* In the Post Helper class, each image is then inputted into the isImageValidated method. Many links provided return errors, time out or don't match the content requested. A request to the inputted link is made, validating for statuscode and content type. A timeout intraval of 5 seconds is also added. The method has an escaping completion handler. If an image is valid, it returns true, and the post is added to the posts array. 
* In addition, the Post Helper class has a property that keeps track of how many image requests were made and how many returned. A property observer is added to the returned int property. If the amount of calls equal the amount of requests returned, a notification is sent, triggering the load tableview method in the main view controller, FeedViewController.
* Posts are filtered by date, with newest posts showing first. You can tap the filter button to filter by text or image.
* The tableview methods are in an extention of the FeedViewController. When there is an image cell, the getImageforPost method in the Post Helper is called. The Post Helper has an image cache. If an image doesn't exist in the cache, it is downloaded and added to the cache. If it exists, it is loaded. This increases performance of the tableview.
