//
//  CharacterDetailViewController.swift
//  Simpsons Character Viewer
//
//  Created by Nikhil Dasari on 2/21/19.
//  Copyright © 2019 Nikhil. All rights reserved.
//

import UIKit

class CharacterDetailViewController: UIViewController {

    static var storyboardId = String(describing: CharacterDetailViewController.self)
    
    // MARK: - IBoutlets
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var infoLabel: UILabel!
    
    // MARK: - View model
    
    var viewModel: CharacterDetailViewModel?
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.setUpView(for: self)
    }
    
}
