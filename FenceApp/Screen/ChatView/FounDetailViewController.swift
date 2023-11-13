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
    let locationManager: LocationManager
    let foundIdentifier: String
//    let userIdentifier: String
    
    var found: Found!
    
    init(firebaseFoundService: FirebaseFoundService, locationManager: LocationManager, foundIdentifier: String) {
        self.firebaseFoundService = firebaseFoundService
        self.locationManager = locationManager
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
                getData()
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
    
    private func getData(){
        foundDetailView.configureCell(postTime: "\(found.date)", found: found)
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
