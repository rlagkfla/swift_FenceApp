//
//  ChatViewController.swift
//  FenceApp
//
//  Created by JeonSangHyeok on 10/16/23.
//

import UIKit
import Kingfisher

class ChatViewController: UIViewController {
    
    // MARK: - Properties
    var filterModel = FilterModel(distance: 20, startDate: Calendar.yesterday, endDate: Calendar.today)
    
    let firebaseFoundService: FirebaseFoundService
    var foundList: [Found] = []
    
    var filterTapped: ((FilterModel) -> Void)?
    
    // MARK: - Properties
    private lazy var chatView: ChatView = {
        let view = ChatView()
        view.delegate = self
        return view
    }()
    
    init(firebaseFoundService: FirebaseFoundService) {
        self.firebaseFoundService = firebaseFoundService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func loadView() {
        view = chatView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getFoundList()
    }
    
    func configure() {
        view.backgroundColor = .white
        
        self.navigationItem.title = "FoundList"
        
        configurefoundCollectionView()
        getFoundList()
    }
    
    func setFilterLabel() {
        let convertDate = DateService().converToDateInFilterLabel(fromDate: filterModel.startDate, toDate: filterModel.endDate)
        
        chatView.filterLabel.text = "거리 - 반경 \(Int(filterModel.distance))km 내 / 시간 - \(convertDate)일 이내 / 동물 - 전체"
    }
}

// MARK: - Private Method
private extension ChatViewController {
    func getFoundList() {
        Task {
            do {
                let foundResponseDTDs = try await firebaseFoundService.fetchFounds()
                
                foundList = FoundResponseDTOMapper.makeFounds(from: foundResponseDTDs)
//                foundList = try await firebaseFoundService.fetchFounds()
                chatView.foundCollectionView.reloadData()
            } catch {
                print("error")
            }
        }
    }
    
    func getFoundListWithFilter() {
        Task {
            do {
                let foundResponseDTOs = try await firebaseFoundService.fetchFounds(filterModel: filterModel)
                
                foundList = FoundResponseDTOMapper.makeFounds(from: foundResponseDTOs)
                
                foundList.sort { $0.date > $1.date }
                
                chatView.foundCollectionView.reloadData()
            } catch {
                print(error)
            }
        }
    }
    
    func configurefoundCollectionView() {
        chatView.foundCollectionView.dataSource = self
        chatView.foundCollectionView.delegate = self
    }
}

extension ChatViewController: ChatViewDelegate, CustomFilterModalViewControllerDelegate {
    func applyTapped(filterModel: FilterModel) {
        self.filterModel = filterModel
        
        getFoundListWithFilter()
        setFilterLabel()
    }
    
    func filterButtonTapped() {
        filterTapped?(filterModel)
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension ChatViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return foundList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = chatView.foundCollectionView.dequeueReusableCell(withReuseIdentifier: ChatCollectionViewCell.identifier, for: indexPath) as! ChatCollectionViewCell
        cell.setFoundImageView(foundImageUrl: foundList[indexPath.row].imageURL)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: chatView.foundCollectionView.frame.width / 3 - 2, height: chatView.foundCollectionView.frame.width / 3 - 2)
    }
}
