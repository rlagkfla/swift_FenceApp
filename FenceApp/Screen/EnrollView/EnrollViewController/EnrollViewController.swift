//
//  EnrollViewController.swift
//  FenceApp
//
//  Created by t2023-m0067 on 10/18/23.
//

import UIKit
import SnapKit
import PhotosUI
import MapKit

protocol EnrollViewControllerDelegate: AnyObject {
    func popEnrollViewController()
}

struct SelectedImage {
    let image: UIImage
    let index: Int
}

class EnrollViewController: UIViewController{
    
    private let enrollView = EnrollView()
    
    let firebaseLostService: FirebaseLostService
    
    let lostIdentifier: String?
    var lost: Lost!
    
    var lostList: [LostResponseDTO] = []
    
    weak var delegate: EnrollViewControllerDelegate?
    
    var isEdited: Bool = false
    
    // camera
    var images: [UIImage] = [] // 삭제 예정
    //    var selectedImages: [SelectedImage] = []
    var pickerViewController: PHPickerViewController?
    
    // map
    // 확인필요
    let locationManager: LocationManager
    var selectedCoordinate: CLLocationCoordinate2D? // 선택한 위치를 저장하기 위한 속성
    let annotation = MKPointAnnotation() // 지도 마커
    
    var finishUploadingLost: ((MissingType) -> ())?
    
    init(firebaseLostService: FirebaseLostService, locationManager: LocationManager, lostIdentifier: String? = nil) {
        self.firebaseLostService = firebaseLostService
        self.locationManager = locationManager
        self.lostIdentifier = lostIdentifier
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("EnrollViewController deinit")
        
    }
    
    
    override func loadView() {
        view = enrollView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // mapView의 delegate 설정
        enrollView.mapView.delegate = self
        
        print(images.count)
        configureNavBar()
        configureAction()
        configureCollectionView()
        configureMap()
        configureKeyboard()
        
        Task {
            do {
                try await getLost()
            } catch {
                print(error)
            }
        }
    }
    
    func getLost() async throws {
        guard isEdited == true else { return }
        let lostResponseDTO = try await firebaseLostService.fetchLost(lostIdentifier: self.lostIdentifier!)
        let lost = LostResponseDTOMapper.makeLost(from: lostResponseDTO)
        self.lost =  lost
        configureEditMode()
    }
    
    func configureAction(){
        // 사진 추가 버튼 클릭 시
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(customButtonTapped))
        enrollView.customBtnView.addGestureRecognizer(tapGesture)
        // datePicker 클릭 시
        enrollView.datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
    }
    
    func configureKeyboard(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // 키보드 외 영역 클릭 시 키보드 사라지게 하기
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGestureRecognizer.cancelsTouchesInView = false
        enrollView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func configureEditMode() {
        guard let lost = self.lost else { return }
        enrollView.titleTextField.text = lost.title
        enrollView.nameTextField.text = lost.petName
        enrollView.textView.text = lost.description
        enrollView.datePicker.date = lost.lostDate
        switch lost.kind {
        case "dog":
            enrollView.segmentedControl.selectedSegmentIndex = 0
        case "cat":
            enrollView.segmentedControl.selectedSegmentIndex = 1
        default:
            enrollView.segmentedControl.selectedSegmentIndex = 2
        }
        let center = CLLocationCoordinate2D(latitude: lost.latitude, longitude: lost.longitude)
        //        selectedCoordinate = center
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 500, longitudinalMeters: 500)
        enrollView.mapView.setRegion(region, animated: true)
    }
    
    
    @objc func customButtonTapped() {
        // 이미지 배열 비우기 (데이터 저장 로직 수정 후 삭제 예정)
        images.removeAll()
        
        // PHPicker 구성
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1 // 0은 제한 없음을 의미
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        
        // 뷰 컨트롤러에 참조 저장
        self.pickerViewController = picker
        
        // PHPicker 화면 표시
        self.present(picker, animated: true, completion: nil)
        
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일 a h시 mm분"
        let selectedDate = dateFormatter.string(from: sender.date)
        print("Selected Date: \(selectedDate)")
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
            enrollView.scrollView.contentInset = contentInset
            enrollView.scrollView.scrollIndicatorInsets = contentInset
            
            // UITextView가 키보드 아래에 가려지지 않도록 조정
            if let selectedRange = enrollView.textView.selectedTextRange {
                let caretRect = enrollView.textView.caretRect(for: selectedRange.start)
                let caretY = caretRect.origin.y
                let visibleY = enrollView.textView.frame.height - keyboardSize.height
                if caretY > visibleY {
                    let offsetY = caretY - visibleY
                    enrollView.scrollView.setContentOffset(CGPoint(x: 0, y: offsetY), animated: true)
                }
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        let contentInset = UIEdgeInsets.zero
        enrollView.scrollView.contentInset = contentInset
        enrollView.scrollView.scrollIndicatorInsets = contentInset
        
        // 키보드 숨겨질 때 커서의 위치 확인
        if let selectedRange = enrollView.textView.selectedTextRange {
            let caretRect = enrollView.textView.caretRect(for: selectedRange.start)
            let caretY = caretRect.origin.y
            let contentOffset = enrollView.scrollView.contentOffset.y
            
            if caretY < contentOffset {
                // 커서가 화면에서 가려져 있는 경우 스크롤하여 보이도록 함
                let offsetY = max(0, contentOffset - (contentOffset - caretY))
                enrollView.scrollView.setContentOffset(CGPoint(x: 0, y: offsetY), animated: true)
            }
        }
        
    }
    
    @objc func dismissKeyboard() {
        enrollView.endEditing(true)
    }
    
    
    @objc func tapLeftBarBtn(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func handleMapTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            // 탭한 포인트를 지도의 좌표로 변환
            let point = sender.location(in: enrollView.mapView)
            let coordinate = enrollView.mapView.convert(point, toCoordinateFrom: enrollView.mapView)
            
            // 선택한 위치 저장
            selectedCoordinate = coordinate
            
            // 이후에 선택한 위치를 지도 중앙에 유지하려면 다음과 같이 지도 중앙을 설정합니다.
            enrollView.mapView.setCenter(coordinate, animated: true)
            
            if let selectedCoordinate = selectedCoordinate {
                annotation.coordinate = selectedCoordinate
            }
            
            // 마커를 지도 뷰에 추가합니다.
            enrollView.mapView.addAnnotation(annotation)
        }
    }
    
    
    @objc func tapRightBarBtn(){
        
        // 사진 수정 예정
        guard let picture = images.first else {
            showAlert(message: "이미지를 선택하세요.")
            return
        }
        //        guard let picture = selectedImages.first else {
        //            showAlert(message: "이미지를 선택하세요.")
        //            return
        //        }
        guard let enrollTitle = enrollView.titleTextField.text, !enrollTitle.isEmpty else {
            showAlert(message: "제목을 입력하세요.")
            return
        }
        guard let enrollName = enrollView.nameTextField.text, !enrollName.isEmpty else {
            showAlert(message: "반려동물의 이름을 입력하세요.")
            return
        }
        guard let selectedCoordinate else {
            showAlert(message: "위치를 선택하세요.")
            return
        }
        guard let enrollSeg = enrollView.segmentedControl.titleForSegment(at: enrollView.segmentedControl.selectedSegmentIndex) else {return}
        
        // 로딩 인디케이터 추가
        let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        activityIndicator.center = self.view.center
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        var kind: String
        
        switch enrollSeg {
        case "강아지":
            kind = "dog"
        case "고양이":
            kind = "cat"
        case "기타 동물":
            kind = "etc"
        default:
            kind = "unknown"
        }
        
        Task{
            do {
                let alertTitle: String = isEdited ? "수정 중입니다." : "등록 중입니다."
                let alertController = UIAlertController(title: alertTitle, message: "잠시만 기다려주세요.", preferredStyle: .alert)
                self.present(alertController, animated: true)
                let url = try await FirebaseImageUploadService.uploadLostImage(image: picture)
                
                guard let user = CurrentUserInfo.shared.currentUser else { throw PetError.noUser}
                
                let lostResponseDTO = LostResponseDTO(latitude: selectedCoordinate.latitude, longitude: selectedCoordinate.longitude, userIdentifier: user.userIdentifier, userProfileImageURL: user.profileImageURL, userNickName: user.nickname, title: enrollTitle, postDate: Date(), lostDate: enrollView.datePicker.date, pictureURL: url, petName: enrollName, description: enrollView.textView.text, kind: kind, userFCMToken: CurrentUserInfo.shared.userToken ?? "")
                
                if isEdited == false {
                    try await firebaseLostService.createLost(lostResponseDTO: lostResponseDTO)
                    delegate?.popEnrollViewController()
                } else {
                    let editLostResponseDTO =  LostResponseDTO(lostIdentifier: lost!.lostIdentifier, latitude: selectedCoordinate.latitude, longitude: selectedCoordinate.longitude, userIdentifier: user.userIdentifier, userProfileImageURL: user.profileImageURL, userNickName: user.nickname, title: enrollTitle, postDate: lost.postDate, lostDate: enrollView.datePicker.date, pictureURL: url, petName: enrollName, description: enrollView.textView.text, kind: kind, userFCMToken: CurrentUserInfo.shared.userToken!)
                    delegate?.popEnrollViewController()
                    try await firebaseLostService.editLost(on: editLostResponseDTO)
                }
                
                print("lostResponseDTO - \(lostResponseDTO)")
                
                // 작업이 완료되면 로딩 인디케이터를 제거하고 페이지를 닫음
                activityIndicator.stopAnimating()
                activityIndicator.removeFromSuperview()
                self.view.isUserInteractionEnabled = true
                alertController.dismiss(animated: true)
                self.navigationController?.popViewController(animated: true)
                
                // pop시 delegate로 테이블뷰 페이지 이동
                finishUploadingLost?(.lost)
            }catch{
                print(error)
            }
        }
        
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "필수 입력", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }

    
}

extension EnrollViewController {
    func configureNavBar(){
        self.title = "게시글 등록"
        let appearance = UINavigationBarAppearance()
        // 불투명한 색상의 백그라운드 생성 (불투명한 그림자를 한겹을 쌓는다)
        //        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        // 우측 버튼
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(tapRightBarBtn))
        navigationItem.rightBarButtonItem?.tintColor = UIColor(hexCode: "55BCEF")
        // NavigationItem back 버튼 숨기기
        navigationItem.hidesBackButton = true
        // 좌측 버튼
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "multiply"), style: .plain, target: self, action: #selector(tapLeftBarBtn))
        navigationItem.leftBarButtonItem?.tintColor = UIColor(hexCode: "55BCEF")
    }
}

extension EnrollViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private func configureCollectionView() {
        enrollView.collectionView.delegate = self
        enrollView.collectionView.dataSource = self
        enrollView.collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        enrollView.collectionView.contentInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15) // 셀 간 여백 설정
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return images.count // 삭제 예정
        //        return selectedImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as! PhotoCollectionViewCell
        
        cell.backgroundColor = .white
        
        // selectedImages 배열에서 해당 인덱스의 이미지를 가져와서 셀에 표시
        //        let selectedImage = selectedImages[indexPath.row]
        //        cell.imageView.image = selectedImage.image
        
        // images 배열에서 해당 인덱스의 이미지를 가져와서 셀에 표시 -> 삭제 예정
        
        let image = images[indexPath.row]
        cell.imageView.image = image
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // UICollectionView의 크기를 가져와서 사용
        let collectionViewHeight = collectionView.bounds.height - 15
        let collectionViewWidth = collectionViewHeight
        
        // 각 셀의 크기를 UICollectionView의 크기와 일치하도록 설정
        return CGSize(width: collectionViewWidth, height: collectionViewHeight)
    }
    
}

extension EnrollViewController: PHPickerViewControllerDelegate {
    
    // picker가 종료되면 동작 합니다.
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        
        // 선택한 이미지 처리
        //        for (index, result) in results.enumerated() {
        //            // 이미지 아이템 제공자에서 이미지를 가져옵니다.
        //            result.itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
        //                if let image = image as? UIImage {
        //                    // 이미지를 배열에 추가
        ////                    self.images.append(image)
        //
        //                    // 이미지와 순서 정보를 함께 저장
        //                    self.selectedImages.append(SelectedImage(image: image, index: index))
        //
        //                    // 컬렉션 뷰 새로 고침
        //                    DispatchQueue.main.async {
        //                        self.enrollView.collectionView.reloadData()
        //                    }
        //                }
        //            }
        //        }
        
        for result in results {
            // 이미지 아이템 제공자에서 이미지를 가져옵니다.
            result.itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                if let image = image as? UIImage {
                    // 이미지를 배열에 추가
                    //                    self.images.append(image)
                    
                    // 이미지 배열에 새 이미지 설정 (삭제 예정)
                    self.images = [image]
                    
                    // 컬렉션 뷰 새로 고침
                    DispatchQueue.main.async {
                        self.enrollView.collectionView.reloadData()
                    }
                }
            }
        }
        
    }
    
}

extension EnrollViewController: MKMapViewDelegate {
    
    func configureMap(){
        if let location = locationManager.fetchLocation() {
            let center = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            let span = MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002) // 지도 확대/축소 정도
            let region = MKCoordinateRegion(center: center, span: span)
            enrollView.mapView.setRegion(region, animated: true)
            
            // 현재 위치에 대한 지도 마커
            annotation.coordinate = center
            
            // 마커 추가
            enrollView.mapView.addAnnotation(annotation)
            
            // 마커를 가운데에 고정하기 / 확인필요
            //            enrollView.mapView.setUserTrackingMode(.follow, animated: true)
            
            // 탭 제스처 인식기를 생성하고 지도 뷰에 추가
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleMapTap))
            enrollView.mapView.addGestureRecognizer(tapGesture)
        }
        
        
        
    }
    
    
}
