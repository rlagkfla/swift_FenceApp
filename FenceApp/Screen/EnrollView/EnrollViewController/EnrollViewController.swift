//
//  EnrollViewController.swift
//  FenceApp
//
//  Created by t2023-m0067 on 10/18/23.
//

import UIKit
import SnapKit
import PhotosUI

class EnrollViewController: UIViewController {

    private let enrollView = EnrollView()
    
    // camera
    var images: [UIImage] = []
    
    var pickerViewController: PHPickerViewController?
    
    override func loadView() {
        view = enrollView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavBar()

        configureAction()
        
        configureCollectionView()
        
        configureKeyboard()
    }
    
    
    func configureAction(){
        // 사진 추가 버튼 클릭 시
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(customButtonTapped))
        enrollView.customBtnView.addGestureRecognizer(tapGesture)
        // 세그먼트 클릭 시
        enrollView.segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
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

    
    @objc func customButtonTapped() {
        // PHPicker 구성
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 0 // 0은 제한 없음을 의미

        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self

        // 뷰 컨트롤러에 참조 저장
        self.pickerViewController = picker

        // PHPicker 화면 표시
        self.present(picker, animated: true, completion: nil)
        
    }
    
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        let selectedIndex = sender.selectedSegmentIndex
        print("Selected Index: \(selectedIndex)")
        // 선택된 항목에 따라 원하는 작업을 수행할 수 있습니다.
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
    
    @objc func tapRightBarBtn(){
        print("clickRight")
        
    }
    
    @objc func tapLeftBarBtn(){
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension EnrollViewController {
    func configureNavBar(){
        self.title = "게시글 등록"
        let appearance = UINavigationBarAppearance()
        // 불투명한 색상의 백그라운드 생성 (불투명한 그림자를 한겹을 쌓는다)
        appearance.configureWithOpaqueBackground()
        // 우측 버튼
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(tapRightBarBtn))
        // NavigationItem back 버튼 숨기기
        navigationItem.hidesBackButton = true
        // 좌측 버튼
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "multiply"), style: .plain, target: self, action: #selector(tapLeftBarBtn))
    }
}

extension EnrollViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    private func configureCollectionView() {
        enrollView.collectionView.delegate = self
        enrollView.collectionView.dataSource = self
        enrollView.collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: "cell") // CustomCollectionViewCell은 셀을 표현하기 위한 사용자 정의 셀 클래스입니다.
        enrollView.collectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10) // 셀 간 여백 설정
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PhotoCollectionViewCell
        
        cell.backgroundColor = .white
        
        // images 배열에서 해당 인덱스의 이미지를 가져와서 셀에 표시
        let image = images[indexPath.row]
        cell.imageView.image = image
        
        return cell
    }
}

extension EnrollViewController: PHPickerViewControllerDelegate {

    // picker가 종료되면 동작 합니다.
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)

        // 선택한 이미지 처리
        for result in results {
            // 이미지 아이템 제공자에서 이미지를 가져옵니다.
            result.itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                if let image = image as? UIImage {
                    // 이미지를 배열에 추가
                    self.images.append(image)

                    // 컬렉션 뷰 새로 고침
                    DispatchQueue.main.async {
                        self.enrollView.collectionView.reloadData()
                    }
                }
            }
        }
        
    }
    
    
}

