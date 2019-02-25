//
//  CharacterViewerService.swift
//  Simpsons Character Viewer
//
//  Created by Nikhil Dasari on 2/21/19.
//  Copyright © 2019 Nikhil. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import AlamofireImage

class CharacterViewerService {
    
    fileprivate var dataRequests: [IndexPath: DataRequest] = [:]
    
    fileprivate func parseResponseJson(_ json: [JSON]) -> [Character] {
        var characters: [Character] = []
        
        for characterItem in json {
            if let character = Character(json: characterItem) {
                characters.append(character)
            }
        }
        return characters
    }
    
    func getCharacters(completionHandler: @escaping ([Character]) -> ()) {
        guard let characterViewerUrl = AppInfo.characterViewerServiceUrl else {
            print("Please check the charcter viewer service url")
            return
        }
        
        Alamofire.request(characterViewerUrl).validate().responseJSON{ response in
            guard let responseData = JSON(response.value as Any)["RelatedTopics"].array else {
                print("Invalid Response Data")
                return
            }
            let characters = self.parseResponseJson(responseData)
            completionHandler(characters)
        }
        
    }
    
    func retrieveImage(for url: URL, at indexPath: IndexPath, completionHandler: @escaping (Image) -> ()) {
        
        if let dataRequest = dataRequests[indexPath] {
            print("Cancel existing request at index path")
            dataRequest.cancel()
        }
        
        let request = Alamofire.request(url).validate().responseImage { (response) in
            switch response.result {
            case .failure(let error):
                print("Failed to retreive image, error description: \(error.localizedDescription)")
            case .success(let image):
                DispatchQueue.main.async {
                    completionHandler(image)
                }
            }
        }
        
        dataRequests[indexPath] = request
    }
    
}
