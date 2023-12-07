//
//  CommentCompositionalLayout.swift
//  FenceApp
//
//  Created by Woojun Lee on 11/8/23.
//

import UIKit

struct CommentCompositionalLayout {
    
    func configureLayout() -> UICollectionViewCompositionalLayout {
        
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100)))
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100)), subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        section.boundarySupplementaryItems = [supplementaryHeaderItem()]
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func supplementaryHeaderItem() -> NSCollectionLayoutBoundarySupplementaryItem    {
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(20)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        return header
    }
}
