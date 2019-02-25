//
//  CharacterCollectionViewModel.swift
//  Simpsons Character Viewer
//
//  Created by Nikhil Dasari on 2/21/19.
//  Copyright © 2019 Nikhil. All rights reserved.
//

import Foundation
import UIKit

protocol CharacterCollectionViewControllerDelegate: class {
    func reloadCharacterListViewController(_ viewModel: CharacterCollectionViewModel)
    func ViewModel(_ viewModel: CharacterCollectionViewModel, didGetImage image: UIImage, for indexPath: IndexPath)
}

enum ViewLayout {
    case list
    case grid
}

class CharacterCollectionViewModel {
    
    // MARK: - Variable
    
    fileprivate var characters: [Character] = []
    fileprivate var _viewLayout: ViewLayout = .list
    fileprivate var characterCollectionViewController: CharacterCollectionViewController!
    fileprivate let flowLayout = CustomCollectionFlowLayout()
    fileprivate let characterViewerService = CharacterViewerService()
    var viewLayout: ViewLayout { return _viewLayout }
    weak var delegate: CharacterCollectionViewControllerDelegate?
    
    // MARK: - Initializer
    
    init(_ characterCollectionViewController: CharacterCollectionViewController) {
        self.characterCollectionViewController = characterCollectionViewController
        characterViewerService.getCharacters(completionHandler: { (characters) in
            self.characters = characters
            self.delegate?.reloadCharacterListViewController(self)
        })
        customizeNavigationBarTitle()
        customizeNavigationBarButton()
    }
    
    // MARK: - Private helper methods
    
    fileprivate func setToggleButtonTitle() {
        let title = _viewLayout == .list ? "Grid View" : "List View"
        characterCollectionViewController.navigationItem.rightBarButtonItem?.title = title
    }
    
    fileprivate func downloadImage(at indexPath: IndexPath, isRequiredToUpdate: Bool = false) {
        let characterAtIndexPath = characters[indexPath.row]
        guard let characterUrl = characterAtIndexPath.imageUrl else {
            print("character image URL not available")
            return
        }
        
        characterViewerService.retrieveImage(for: characterUrl, at: indexPath) { (image) in
            self.characters[indexPath.row].image = image
            if isRequiredToUpdate {
                self.delegate?.ViewModel(self, didGetImage: image.af_imageAspectScaled(toFit: CGSize(width: 60.00, height: 60.00)), for: indexPath)
            }
        }
    }
    
    fileprivate func customizeNavigationBarTitle() {
        if DeviceInfo.isPhone {
            characterCollectionViewController.navigationItem.title = AppInfo.appName
        }
    }
    
    fileprivate func customizeNavigationBarButton() {
        if DeviceInfo.isPhone {
            setToggleButtonTitle()
        }else {
            removeToggleButton()
        }
    }
    
    fileprivate func removeToggleButton() {
         characterCollectionViewController.navigationItem.rightBarButtonItems = []
    }
    
}

// MARK: - Public APIs

extension CharacterCollectionViewModel {
    
    var numberOfSections: Int {
        return 1
    }
    
    func numberOfItems(inSection section: Int) -> Int {
        return self.characters.count
    }
    
    func title(forItemAt indexPath: IndexPath) -> String {
        if self.characters[indexPath.row].image == nil { downloadImage(at: indexPath) }
        return self.characters[indexPath.row].title
    }
    
    func image(forItemAt indexPath: IndexPath) -> UIImage {
        let characterAtIndexPath = characters[indexPath.row]
        if let characterImage = characterAtIndexPath.image { return characterImage.af_imageAspectScaled(toFit: CGSize(width: 60, height: 60.00)) }

        // Download Image
        downloadImage(at: indexPath, isRequiredToUpdate: true)
        return #imageLiteral(resourceName: "contacts")
    }
    
    func switchLayout(for viewController: CharacterCollectionViewController) {
        switch _viewLayout {
        case .list:
            _viewLayout = .grid
        case .grid:
            _viewLayout = .list
        }
        setToggleButtonTitle()
        viewController.collectionView.reloadData()
    }
    
    func character(at indexPath: IndexPath) -> Character {
        return characters[indexPath.row]
    }
    
}
