//
//  LostListViewController.swift
//  FenceApp
//
//  Created by JeonSangHyeok on 10/16/23.
//

import UIKit
import SnapKit
import Kingfisher
import FirebaseFirestore

class LostListViewController: UIViewController {
    
    //MARK: - Services
    
    let fireBaseLostService: FirebaseLostService
    let firebaseLostCommentService: FirebaseLostCommentService
    let firebaseAuthService: FirebaseAuthService
    let firebaseUserService: FirebaseUserService
    
    // MARK: - Properties
    lazy var lostListView: LostListView = {
        let view = LostListView()
        view.delegate = self
        return view
    }()
    
    var filterModel = FilterModel(distance: 1, startDate: Calendar.yesterday, endDate: Calendar.today)
    
    var lostList: [Lost] = []
    
    var filterTapped: ( (FilterModel) -> Void)?
    
    let lostCellTapped: ( (Lost) -> Void )
    
    private var lostWithDocument: LostWithDocument?
    
    init(fireBaseLostService: FirebaseLostService, firebaseLostCommentService: FirebaseLostCommentService, firebaseAuthService: FirebaseAuthService, firebaseUserService: FirebaseUserService, lostCellTapped: @escaping (Lost) -> Void) {
        self.fireBaseLostService = fireBaseLostService
        self.firebaseLostCommentService = firebaseLostCommentService
        self.firebaseAuthService = firebaseAuthService
        self.firebaseUserService = firebaseUserService
        self.lostCellTapped = lostCellTapped
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func loadView() {
        view = lostListView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getLostList()
        
        //        loadNextPage()
        
        configureTableView()
        
        configureNavBar()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getLostList()
        
    }
    
    
    @objc func tapRightBarBtn(){
        let enrollVC = EnrollViewController(firebaseAuthService: firebaseAuthService, firebaseLostService: fireBaseLostService, firebaseUserService: firebaseUserService, firebaseLostCommentService: firebaseLostCommentService)
        
        enrollVC.delegate = self
        // 탭바 숨기기
        enrollVC.hidesBottomBarWhenPushed = true
        
        self.navigationController?.pushViewController(enrollVC, animated: true)
    }
    
    private func configureTableView(){
        lostListView.lostTableView.dataSource = self
        lostListView.lostTableView.delegate = self
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height
        if bottomEdge >= scrollView.contentSize.height {
            getLostList()
        }
    }
    
    private func getLostList() {
        Task {
            do {
                if let nextLostWithDocument = self.lostWithDocument {
//                    guard var lostWithDocument1 = self.lostWithDocument else {return}
                    // 이전 페이지의 마지막 도큐먼트를 사용하여 다음 페이지를 가져오도록 변경
                    lostWithDocument = try await fireBaseLostService.fetchLostsWithPagination(int: 10, lastDocument: nextLostWithDocument.lastDocument)
                    
                    let nextLostList = LostResponseDTOMapper.makeLosts(from: lostWithDocument!.lostResponseDTOs)
                    
                    lostList += nextLostList
                } else {
                    // 처음 페이지를 가져올 때는 lastDocument를 nil로 전달
                    lostWithDocument = try await self.fireBaseLostService.fetchLostsWithPagination(int: 10)
                                        
                    lostList = LostResponseDTOMapper.makeLosts(from: lostWithDocument!.lostResponseDTOs)
                }

                lostList.sort { $0.postDate > $1.postDate }
                
                lostListView.lostTableView.reloadData()
            } catch {
                print(error)
            }
        }
    }
    
    private func getLostListWithFilter(){
        Task {
            do{
                let lostResponseDTOs = try await fireBaseLostService.fetchLosts(filterModel: filterModel)
                
                lostList = LostResponseDTOMapper.makeLosts(from: lostResponseDTOs)
                
                // 날짜에 따라 lostList 배열을 정렬 (최신 날짜가 맨 위로)
                lostList.sort { $0.postDate > $1.postDate }
                
                lostListView.lostTableView.reloadData()
                
            }catch{
                print(error)
            }
        }
    }
    
    func setFilterLabel() {
        let convertDate = DateService().converToDateInFilterLabel(fromDate: filterModel.startDate, toDate: filterModel.endDate)
        
        lostListView.filterLabel.text = "거리 - 반경 \(Int(filterModel.distance))km 내 / 시간 - \(convertDate)일 이내"
    }
   

    
}

extension LostListViewController {
    
    func configureNavBar() {
        self.navigationItem.title = "게시판"
        self.navigationController?.navigationBar.backgroundColor = .white
        // (네비게이션바 설정관련) iOS버전 업데이트 되면서 바뀐 설정:별:️:별:️:별:️
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground() // 불투명으로
        
        // 우측 버튼
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(tapRightBarBtn))
        navigationItem.rightBarButtonItem?.tintColor = UIColor(hexCode: "55BCEF")
    }
    
}

extension LostListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lostList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LostListViewCell", for: indexPath) as! LostListViewCell
        
        cell.selectionStyle = .none
        
        let lostPost = lostList[indexPath.row]
        
        cell.configure(lostPostImageUrl: lostPost.imageURL, lostPostTitle: lostPost.title, lostPostDate: "\(lostPost.postDate)", lostPostUserNickName: lostPost.userNickName)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // 여기에서 각 행에 대한 높이를 동적으로 반환합니다.
        return 150
    }
}

extension LostListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        lostCellTapped(lostList[indexPath.row])
    }
}

extension LostListViewController: EnrollViewControllerDelegate {
    func popEnrollViewController() {
        getLostList()
    }
}

extension LostListViewController: lostListViewDelegate {
    func tapFilterButton() {
        filterTapped?(filterModel)
        
    }
}

extension LostListViewController: CustomFilterModalViewControllerDelegate {
    func applyTapped(filterModel: FilterModel) {
        
        self.filterModel = filterModel
        
        getLostListWithFilter()
        setFilterLabel()
    }
}

