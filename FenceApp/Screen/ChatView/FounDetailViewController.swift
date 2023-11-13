//
//  FounDetailViewController.swift
//  FenceApp
//
//  Created by t2023-m0067 on 11/13/23.
//

import UIKit

class FounDetailViewController: UIViewController {

//    lazy var foundDetailView: FoundDetailView = {
//        let view = FoundDetailView()
//        view.delegate = self
//        return view
//    }()
    
    private let foundDetailView = FoundDetailView()
    
    let firebaseFoundService: FirebaseFoundService
    let locationManager: LocationManager
    let foundIdentifier: String
    
    var found: Found!
    var foundList: [Found] = []
    
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
            } catch {
                print(error)
            }
        }
        
    }
    
    func getFound() async throws {
        let foundResponseDTO = try await firebaseFoundService.fetchFound(foundIdentifier: self.foundIdentifier)
        let found = FoundResponseDTOMapper.makeFound(from: foundResponseDTO)
        self.found = found
    }

    private func configureCollectionView(){
        foundDetailView.imageCollectionView.dataSource = self
        foundDetailView.imageCollectionView.delegate = self
    }
}

extension FounDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FoundDetailCollectionViewCell.identifier, for: indexPath) as! FoundDetailCollectionViewCell
//        print("111")
//        let foundPost = foundList[indexPath.row]
//        print("222")
//        cell.setImage(urlString: foundPost.imageURL)
//        print("333")
//        foundDetailView.imageCollectionView.reloadData()
//        print("444")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}
