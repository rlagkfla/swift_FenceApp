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
    var nowPage: Int = 0
    
    // MARK: - Life Cycle
    override func loadView() {
        view = detailView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        view.backgroundColor = .white
        
        detailView.imageCollectionView.dataSource = self
        detailView.imageCollectionView.delegate = self
        
        
        detailView.pageControl.numberOfPages = 3
        detailView.pageControl.currentPage = 0
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension DetailViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = detailView.imageCollectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as! ImageCollectionViewCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: detailView.imageCollectionView.frame.width, height: detailView.imageCollectionView.frame.height)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if velocity.x > 0 {
            self.nowPage += 1
        } else if velocity.x < 0 {
            self.nowPage -= 1
            
            if self.nowPage < 0 {
                self.nowPage = 0
            }
        }
        detailView.pageControl.currentPage = nowPage
    }
}
