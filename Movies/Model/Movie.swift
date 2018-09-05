//
//  Movie.swift
//  Movies
//
//  Created by Edvin Lellhame on 9/5/18.
//  Copyright © 2018 Edvin Lellhame. All rights reserved.
//

import Foundation

struct Movie {
    var title: String
    var id: Int
    var description: String
    var imagePath: String?
    
    
    init(data: [String: AnyObject]) {
        self.title = data["title"] as! String
        self.id = data["id"] as! Int
        self.description = data["overview"] as! String
        self.imagePath = data["poster_path"] as? String
    }
    
   
}
