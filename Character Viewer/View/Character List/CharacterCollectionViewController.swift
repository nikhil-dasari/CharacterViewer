//
//  CharacterCollectionViewController.swift
//  Simpsons Character Viewer
//
//  Created by Nikhil Dasari on 2/21/19.
//  Copyright © 2019 Nikhil. All rights reserved.
//

import UIKit

private enum ReuseIdentifier: String {
    case listCell = "ListCell"
    case gridCell = "GridCell"
}

class CharacterCollectionViewController: UICollectionViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var toggleButton: UIBarButtonItem!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    // MARK: - View model
    
    lazy var characterViewModel: CharacterCollectionViewModel = {
        let vm = CharacterCollectionViewModel(self)
        vm.delegate = self
        return vm
    }()
    
    // MARK: - Life cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicatorView.startAnimating()
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }
    
    // MARK: - IBActions
    
    @IBAction func switchLayout(_ sender: Any) {
        characterViewModel.switchLayout(for: self)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowCharacterDetail", let selectedIndexPath = collectionView.indexPathsForSelectedItems?.first {
            let characterAtIndexPath = characterViewModel.character(at: selectedIndexPath)
            let characterDetailViewModel = CharacterDetailViewModel(image: characterAtIndexPath.image ?? #imageLiteral(resourceName: "contacts"), title: characterAtIndexPath.title, description: characterAtIndexPath.description)
            
            let detailController = (segue.destination as! UINavigationController).topViewController as! CharacterDetailViewController
            detailController.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
            detailController.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
            detailController.navigationItem.leftItemsSupplementBackButton = true
            detailController.viewModel = characterDetailViewModel
        }
    }
    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return characterViewModel.numberOfSections
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return characterViewModel.numberOfItems(inSection: section)
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch characterViewModel.viewLayout {
        case .list:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseIdentifier.listCell.rawValue, for: indexPath) as! CharacterListCollectionViewCell
            cell.titleLabel.text = characterViewModel.title(forItemAt: indexPath)
            return cell
        case .grid:
             let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseIdentifier.gridCell.rawValue, for: indexPath) as! CharacterGridCollectionViewCell
            cell.imageViewLabel.image = characterViewModel.image(forItemAt: indexPath)
            return cell
        }
    }
 
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowCharacterDetail", sender: nil)
    }
}

// MARK: - CharacterCollectionViewControllerDelegate

extension CharacterCollectionViewController: CharacterCollectionViewControllerDelegate {
    func ViewModel(_ viewModel: CharacterCollectionViewModel, didGetImage image: UIImage, for indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CharacterGridCollectionViewCell else { return }
        cell.imageViewLabel.image = image
    }
    
    func reloadCharacterListViewController(_ viewModel: CharacterCollectionViewModel) {
        self.activityIndicatorView.stopAnimating()
        collectionView.reloadData()
    }
}
