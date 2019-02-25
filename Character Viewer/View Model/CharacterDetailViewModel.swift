//
//  CharacterDetailViewModel.swift
//  Simpsons Character Viewer
//
//  Created by Nikhil Dasari on 2/23/19.
//  Copyright © 2019 Nikhil. All rights reserved.
//

import Foundation
import AlamofireImage

class CharacterDetailViewModel {
    let image: Image
    let title: String
    let description: String
    
    init(image: UIImage, title: String, description: String) {
        self.image = image
        self.title = title
        self.description = description
    }
}

extension CharacterDetailViewModel {
    
    func setUpView(for detailViewController: CharacterDetailViewController) {
        let userInterfaceIdiom = UIDevice.current.userInterfaceIdiom
        let characterDescription = description.components(separatedBy: " -")[1]
        switch userInterfaceIdiom {
        case .phone:
            detailViewController.navigationItem.title = title
            detailViewController.infoLabel.text = characterDescription
        default:
            detailViewController.navigationItem.title = AppInfo.appName ?? "App Name Not Found"
            detailViewController.infoLabel.text = "\(title) \n\n \(characterDescription)"
        }
        detailViewController.imageView.image = image
    }

}
