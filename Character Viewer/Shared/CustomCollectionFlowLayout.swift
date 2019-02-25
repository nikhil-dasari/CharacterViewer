//
//  CustomCollectionFlowLayout.swift
//  Simpsons Character Viewer
//
//  Created by Nikhil Dasari on 2/21/19.
//  Copyright © 2019 Nikhil. All rights reserved.
//

import UIKit

class CustomCollectionFlowLayout: UICollectionViewFlowLayout {

    private var minColumnWidth: CGFloat = 300.0
    private var cellHeight: CGFloat = 40.0
    
    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView, let characterCollectionVC = collectionView.dataSource as? CharacterCollectionViewController else { return }
        let viewLayout = characterCollectionVC.characterViewModel.viewLayout
        
        switch viewLayout {
        case .list:
            minColumnWidth = 300.0
            cellHeight = 40.0
        case .grid:
            minColumnWidth = 60.0
            cellHeight = 60.0
        }
        
        let availableWidth = collectionView.bounds.inset(by: collectionView.layoutMargins).width
        let maxNumColumns = Int(availableWidth / minColumnWidth)
        let cellWidth = (availableWidth / CGFloat(maxNumColumns)).rounded(.down)
        
        self.itemSize = CGSize(width: cellWidth, height: cellHeight)
        self.sectionInset = UIEdgeInsets(top: self.minimumInteritemSpacing, left: 0.0, bottom: 0.0, right: 0.0)
        self.sectionInsetReference = .fromSafeArea
    }
}
