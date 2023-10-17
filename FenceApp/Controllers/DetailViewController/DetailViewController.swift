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
        
        view.backgroundColor = .white
        
        detailView.imageCollectionView.dataSource = self
        detailView.imageCollectionView.delegate = self
        
//        detailView.tableView.register(ImageCollectionViewCell.self, forCellReuseIdentifier: ImageCollectionViewCell.identifier)
//        detailView.tableView.register(WriterInfoTableViewCell.self, forCellReuseIdentifier: WriterInfoTableViewCell.identifier)
//        detailView.tableView.register(PostInfoTableViewCell.self, forCellReuseIdentifier: PostInfoTableViewCell.identifier)
        
        self.navigationController?.navigationBar.backgroundColor = .blue
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
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



//extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 3
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if indexPath.row == 0 {
//            let imageSlideCell = detailView.tableView.dequeueReusableCell(withIdentifier: ImageCollectionViewCell.identifier, for: indexPath)
//            
//            return imageSlideCell
//        } else if indexPath.row == 1 {
//            let writerInfoCell = detailView.tableView.dequeueReusableCell(withIdentifier: WriterInfoTableViewCell.identifier, for: indexPath)
//            
//            return writerInfoCell
//        } else {
//            let postInfoCell = detailView.tableView.dequeueReusableCell(withIdentifier: PostInfoTableViewCell.identifier, for: indexPath)
//            
//            return postInfoCell
//        }
//    }
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.row == 0 {
//            return 300
//        } else if indexPath.row == 1 {
//            return 200
//        } else {
//            return 300
//        }
//    }
//}

