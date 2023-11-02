//
//  LostListViewController.swift
//  FenceApp
//
//  Created by JeonSangHyeok on 10/16/23.
//

import UIKit
import SnapKit
import Kingfisher

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
    
    var currentUserResponseDTO: UserResponseDTO!
    
    
    

    let itemsPerPage = 5 // 페이지당 10개의 아이템을 표시
    
    init(fireBaseLostService: FirebaseLostService, firebaseLostCommentService: FirebaseLostCommentService, firebaseAuthService: FirebaseAuthService, firebaseUserService: FirebaseUserService) {
        self.fireBaseLostService = fireBaseLostService
        self.firebaseLostCommentService = firebaseLostCommentService
        self.firebaseAuthService = firebaseAuthService
        self.firebaseUserService = firebaseUserService
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
        
        getCurrentUser()
        //        loadNextPage()
        
        configureTableView()
        
        configureNavBar()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        lostListView.lostTableView.reloadData()
    }
    
    
    @objc func tapRightBarBtn(){
        let enrollVC = EnrollViewController(firebaseAuthService: firebaseAuthService, firebaseLostService: fireBaseLostService, firebaseUserService: firebaseUserService, firebaseLostCommentService: firebaseLostCommentService, currentUserResponseDTO: currentUserResponseDTO)
        
        enrollVC.delegate = self
        // 탭바 숨기기
        enrollVC.hidesBottomBarWhenPushed = true
        
        self.navigationController?.pushViewController(enrollVC, animated: true)
    }
    
    private func configureTableView(){
        lostListView.lostTableView.dataSource = self
        lostListView.lostTableView.delegate = self
    }
    
    private func getLostList(){
        Task {
            do{
                let lostResponseDTOs = try await fireBaseLostService.fetchLosts()
                
                lostList = LostResponseDTOMapper.makeLosts(from: lostResponseDTOs)
                
                // 날짜에 따라 lostList 배열을 정렬 (최신 날짜가 맨 위로)
                lostList.sort { $0.postDate > $1.postDate }
                
                lostListView.lostTableView.reloadData()
            }catch{
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
    
    private func getCurrentUser() {
        Task {
            do {
                let userIdentifier = try self.firebaseAuthService.getCurrentUser().uid
                let userResponseDTO = try await self.firebaseUserService.fetchUser(userIdentifier: userIdentifier)
                currentUserResponseDTO = userResponseDTO
            } catch {
                print(error)
            }
        }
    }
    
    //    func loadNextPage() {
    //        // fetchLostsWithPagination 함수를 호출하여 다음 페이지의 데이터 가져오기
    //        Task {
    //            do {
    //                let result = try await fireBaseLostService.fetchLostsWithPagination(int: itemsPerPage, lastDocument: lastDocument)
    //                let newItems = result.lostResponseDTOs
    //                lastDocument = result.lastDocument
    //
    //                // 가져온 데이터를 데이터 원본에 추가
    //                lostList.append(contentsOf: newItems)
    //
    //                // 테이블 뷰 업데이트
    //                lostListView.lostTableView.reloadData()
    //            } catch {
    //                print(error)
    //            }
    //        }
    //    }
    //
    //    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    //        // 스크롤이 특정 위치까지 도달하면 다음 페이지 로드
    //        let threshold: CGFloat = 100.0 // 스크롤을 어느 정도 내려야 다음 페이지 로드
    //        let contentOffsetY = scrollView.contentOffset.y
    //        let contentHeight = scrollView.contentSize.height
    //        let distanceToBottom = contentHeight - contentOffsetY - scrollView.bounds.size.height
    //
    //        if distanceToBottom < threshold {
    //            loadNextPage()
    //        }
    //    }
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
 
    }
    
}

extension LostListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lostList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LostListViewCell", for: indexPath) as! LostListViewCell
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
        let DetailVC = DetailViewController(lost: lostList[indexPath.row], firebaseCommentService: firebaseLostCommentService, firebaseUserService: firebaseUserService, firebaseAuthService: firebaseAuthService, currentUserResponseDTO: currentUserResponseDTO)
        self.navigationController?.pushViewController(DetailVC, animated: true)
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
    }
}

