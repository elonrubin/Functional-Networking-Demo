//
//  Networking Client.swift
//  Networking Demo
//
//  Created by Elon Rubin on 4/3/17.
//  Copyright © 2017 Elon Rubin. All rights reserved.
//

import Foundation
import Alamofire

class Post {
    
    var id = String()
    var type = String()
    var date = Date()
    var data = String()

    init?(id: String?, type: String?, date: String?, data: String?) {
        
        // 1 - First check if data exists. If no, don't initialize
        guard let unwrappedData = data, let id = id, let date = date, let unwrappedType = type else {
            return nil
        }
        
        guard date != "" else {
            return nil
        }
        
        
        if unwrappedType == "image" {
            
            guard (PostManager.urlContainsProperSyntax(urlString: unwrappedData)) else {
                return nil
            }
            self.data = unwrappedData
            
        } else {
          
            switch (unwrappedData.contains("<br>")) {
            case true:
                self.data = unwrappedData.replacingOccurrences(of: "<br>", with: "\n\n")
            default:
                 self.data = unwrappedData
            }
            
        }
        
        self.date = PostManager.convertStringToDate(date: date)
        self.type = unwrappedType
        self.id = id
        

        }
    

    }
