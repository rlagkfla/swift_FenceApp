//
//  FounDetailViewController.swift
//  FenceApp
//
//  Created by t2023-m0067 on 11/13/23.
//

import UIKit

class FounDetailViewController: UIViewController {

    private let foundDetailView = FoundDetailView()
    // user정보 필요 -> userservice 가져오기
    let firebaseFoundService: FirebaseFoundService
//    let firebaseUserService: FirebaseUserService
//    let locationManager: LocationManager
    let foundIdentifier: String
//    let userIdentifier: String
    
    var menu = UIMenu()
    
    var found: Found!
    
    init(firebaseFoundService: FirebaseFoundService, foundIdentifier: String) {
        self.firebaseFoundService = firebaseFoundService
        self.foundIdentifier = foundIdentifier
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = foundDetailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        Task {
            do {
                try await getFound()
                configureCollectionView()
                configureMenu()
                foundDetailView.configureCell(found: self.found)
            } catch {
                print(error)
            }
        }
        
    }
    
    private func getFound() async throws {
        let foundResponseDTO = try await firebaseFoundService.fetchFound(foundIdentifier: self.foundIdentifier)
        let found = FoundResponseDTOMapper.makeFound(from: foundResponseDTO)
        self.found = found
        
//        let userResponseDTO = try await firebaseUserService.fetchUser(userIdentifier: )
    }

    private func configureCollectionView(){
        foundDetailView.imageCollectionView.dataSource = self
        foundDetailView.imageCollectionView.delegate = self
    }
    
    func configureMenu() {
        let impossibleAlertController = UIAlertController(title: "불가능합니다", message: "본인 게시글이 아니므로 불가능합니다.", preferredStyle: .alert)
        let deleteAlertController = UIAlertController(title: "삭제하기", message: "정말로 삭제하시겠습니까?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        let confirmAction = UIAlertAction(title: "삭제하기", style: .default) { [weak self] _ in
            Task {
                do {
                    try await self!.firebaseFoundService.deleteFound(foundIdentifier: self!.found.foundIdentifier)
                    self?.navigationController?.popViewController(animated: true)
                } catch {
                    print(error)
                }
            }
        }
        impossibleAlertController.addAction(cancelAction)
        deleteAlertController.addAction(cancelAction)
        deleteAlertController.addAction(confirmAction)
        
        let deleteAction = UIAction(title: "삭제하기") { [weak self] _ in
            if self?.found.userIdentifier == CurrentUserInfo.shared.currentUser?.userIdentifier {
                self!.present(deleteAlertController, animated: true)
            } else {
                self!.present(impossibleAlertController, animated: true)
            }
        }
        
        let reportAction = UIAction(title: "신고하기") { _ in
            let reportViewController = ReportViewController(found: self.found, postKind: .found)
            self.navigationController?.pushViewController(reportViewController, animated: true)
        }
        
        
        if self.found.userIdentifier == CurrentUserInfo.shared.currentUser?.userIdentifier  {
            self.menu = UIMenu(title: "메뉴", options: .displayInline, children: [deleteAction])
        } else {
            self.menu = UIMenu(title: "메뉴", options: .displayInline, children: [reportAction])
        }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: nil, image: UIImage(systemName: "ellipsis"), target: self, action: nil, menu: menu)
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor(hexCode: "55BCEF")
    }
}

extension FounDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FoundDetailCollectionViewCell.identifier, for: indexPath) as! FoundDetailCollectionViewCell

        cell.setImage(urlString: found.imageURL)

        foundDetailView.imageCollectionView.reloadData()
  
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}
