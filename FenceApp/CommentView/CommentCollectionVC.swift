//
//  CommentCollectionVC.swift
//  FenceApp
//
//  Created by Woojun Lee on 11/23/23.
//

import UIKit

class CommentCollectionVC: UICollectionViewController {
    
    //MARK: - Properties
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, Comment>!
    
    var alertMethod: ( (Comment) -> Void )?
    
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDataSource()
    }
    
    
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
        configureCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    func makeSnapshot(comments: [Comment]) {
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Comment>()
        
        snapshot.appendSections([.first])
        snapshot.appendItems(comments)
        dataSource.apply(snapshot)
        
    }
    
    func collectionViewScrollTo(commentTo: CommentTo) {
        if commentTo == .last {
            
            collectionView.scrollToItem(at: IndexPath(item: dataSource.snapshot(for: .first).items.count, section: 0), at: .bottom, animated: true)
        } else if commentTo == .next {
            collectionView.scrollToItem(at: IndexPath(item: 10, section: 0), at: .top, animated: true)
        }
    }
    
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, comment in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CommentCell.identifier, for: indexPath) as! CommentCell
            
            
            cell.setLabel(urlString: comment.userProfileImageURL, nickName: comment.userNickname, description: comment.commentDescription, date: comment.commentDate)
            cell.writtenByMe = CurrentUserInfo.shared.isWrittenByCurrentUser(userIdentifier: comment.userIdentifier)
            
            cell.alertMethod = { [weak self] in
                guard let self else { return }
                
               alertMethod?(comment)
            }
            
            return cell
        })
        
        dataSource.supplementaryViewProvider = { [weak self] (collectionView, kind, indexPath) in
            
            let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CommentHeaderView.identifier, for: indexPath) as! CommentHeaderView
            sectionHeader.setText(number: self?.dataSource.snapshot(for: .first).items.count ?? 0)
            return sectionHeader
        }
    }
    
    
    private func configureCollectionView() {
        
        collectionView.register(CommentCell.self, forCellWithReuseIdentifier: CommentCell.identifier)
        collectionView.register(CommentHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CommentHeaderView.identifier)
        
    }
}

