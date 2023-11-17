////
////  ChatViewController.swift
////  FenceApp
////
////  Created by JeonSangHyeok on 10/16/23.
////
//
//import UIKit
//import Kingfisher
//import MessageKit
//final class ChatViewController: UIViewController {
//    
//    // MARK: - Properties
//    var filterModel = FilterModel(distance: 20, startDate: Date().startOfTheDay(), endDate: Date().endOfTheDay())
//    
//    let firebaseFoundService: FirebaseFoundService
//    var foundList: [Found] = []
//    
//    var filterTapped: ((FilterModel) -> Void)?
//    var foundCellTapped: ( (Found) -> Void )?
//    
//    // MARK: - Properties
//    private lazy var chatView: ChatView = {
//        let view = ChatView()
//        view.delegate = self
//        return view
//        
//    }()
//    
//    init(firebaseFoundService: FirebaseFoundService) {
//        self.firebaseFoundService = firebaseFoundService
//        super.init(nibName: nil, bundle: nil)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    // MARK: - Life Cycle
//    override func loadView() {
//        view = chatView
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        configure()
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        getFoundList()
//    }
//    
//    func configure() {
//        view.backgroundColor = .white
//        
//        self.navigationItem.title = "발견한 동물"
//        // 우측 버튼(삭제 예정)
//        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(tapRightBarBtn))
//        configurefoundCollectionView()
//        getFoundList()
//    }
//    // 우측 버튼(삭제 예정)
//    @objc func tapRightBarBtn(){
//        let messageViewController = MessageViewController(recipientFCMToken: <#String#>)
//        messageViewController.hidesBottomBarWhenPushed = true
//        navigationController?.pushViewController(messageViewController, animated: true)
//    }
//
//    
//    func setFilterLabel() {
//        let convertDate = DateService().converToDateInFilterLabel(fromDate: filterModel.startDate, toDate: filterModel.endDate)
//        
//        chatView.filterLabel.text = "거리 - 반경 \(Int(filterModel.distance))km 내 / 시간 - \(convertDate)일 이내"
//    }
//}
//
//// MARK: - Private Method
//private extension ChatViewController {
//    func getFoundList() {
//        Task {
//            do {
//                let foundResponseDTDs = try await firebaseFoundService.fetchFounds()
//                
//                foundList = FoundResponseDTOMapper.makeFounds(from: foundResponseDTDs)
////                foundList = try await firebaseFoundService.fetchFounds()
//                chatView.foundCollectionView.reloadData()
//            } catch {
//                print("error")
//            }
//        }
//    }
//    
//    func getFoundListWithFilter() {
//        Task {
//            do {
//                let foundResponseDTOs = try await firebaseFoundService.fetchFounds(filterModel: filterModel)
//                
//                foundList = FoundResponseDTOMapper.makeFounds(from: foundResponseDTOs)
//                
//                foundList.sort { $0.date > $1.date }
//                
//                chatView.foundCollectionView.reloadData()
//            } catch {
//                print(error)
//            }
//        }
//    }
//    
//    func configurefoundCollectionView() {
//        chatView.foundCollectionView.dataSource = self
//        chatView.foundCollectionView.delegate = self
//    }
//}
//
//extension ChatViewController: ChatViewDelegate, CustomFilterModalViewControllerDelegate {
//    func applyTapped(filterModel: FilterModel) {
//        self.filterModel = filterModel
//        
//        getFoundListWithFilter()
//        setFilterLabel()
//    }
//    
//    func filterButtonTapped() {
//        filterTapped?(filterModel)
//    }
//}
//
//// MARK: - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
//extension ChatViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return foundList.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = chatView.foundCollectionView.dequeueReusableCell(withReuseIdentifier: ChatCollectionViewCell.identifier, for: indexPath) as! ChatCollectionViewCell
//        cell.setFoundImageView(foundImageUrl: foundList[indexPath.row].imageURL)
//        return cell
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: chatView.foundCollectionView.frame.width / 3 - 2, height: chatView.foundCollectionView.frame.width / 3 - 2)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        foundCellTapped?(foundList[indexPath.row])
//    }
//}
