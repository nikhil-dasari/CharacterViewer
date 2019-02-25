//
//  Character.swift
//  Simpsons Character Viewer
//
//  Created by Nikhil Dasari on 2/21/19.
//  Copyright © 2019 Nikhil. All rights reserved.
//

import Foundation
import AlamofireImage
import SwiftyJSON

struct Character {
    var image: Image?
    let imageUrl: URL?
    let title: String
    let description: String
    
    init?(json: JSON) {
        
        guard let description = json["Text"].rawValue as? String else { return nil }
        let title = description.components(separatedBy: " -")[0]
        let imageUrlString = json["Icon"]["URL"].rawValue as? String ?? ""
        
        self.imageUrl = URL(string: imageUrlString)
        self.image = nil
        self.title = title
        self.description = description
    }
}
