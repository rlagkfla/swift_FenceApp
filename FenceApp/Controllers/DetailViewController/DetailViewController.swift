//
//  DetailViewController.swift
//  FenceApp
//
//  Created by JeonSangHyeok on 10/16/23.
//

import UIKit

class DetailViewController: UIViewController {
    
    // MARK: - Properties
    private let detailView = DetailView()
    
    // MARK: - Life Cycle
    override func loadView() {
        view = detailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        detailView.detailCollectionView.dataSource = self
        detailView.detailCollectionView.delegate = self
        
        self.navigationController?.navigationBar.backgroundColor = .blue
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension DetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return 1
        } else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let imageCell = detailView.detailCollectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath)
            return imageCell
        } else if indexPath.section == 1 {
            let writerCell = detailView.detailCollectionView.dequeueReusableCell(withReuseIdentifier: WriterInfoCollectionViewCell.identifier, for: indexPath)
            return writerCell
        } else {
            let postCell = detailView.detailCollectionView.dequeueReusableCell(withReuseIdentifier: PostInfoCollectionViewCell.identifier, for: indexPath)
            return postCell
        }
    }
}
