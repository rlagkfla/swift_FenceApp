//
//  EnrollView.swift
//  FenceApp
//
//  Created by t2023-m0067 on 10/19/23.
//

import UIKit
import SnapKit
import MapKit
import PhotosUI

class EnrollView: UIView {
  
    // camera
    var images: [UIImage] = []
    
    
    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.backgroundColor = .clear
        scroll.isDirectionalLockEnabled = true
        scroll.alwaysBounceHorizontal = false
        scroll.alwaysBounceVertical = true
        return scroll
    }()
    
    lazy var customBtnView: CustomBtnView = {
        let view = CustomBtnView()
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(customButtonTapped))
        view.addGestureRecognizer(tapGesture)
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal // 수평 스크롤
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private let lineLabel: UILabel = {
        let lb = UILabel()
        lb.layer.borderWidth = 1
        lb.layer.borderColor = UIColor.lightGray.cgColor
        return lb
    }()
    
    private let titleTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "제목을 입력하세요."
        tf.isUserInteractionEnabled = true
        tf.backgroundColor = .cyan
//        tf.delegate = self
//        tf.inputAccessoryView = UIView()  // 키보드 위에 Done 버튼 추가 (선택 사항)
        return tf
    }()
    
    private let lineLabel2: UILabel = {
        let lb = UILabel()
        lb.layer.borderWidth = 1
        lb.layer.borderColor = UIColor.lightGray.cgColor
        return lb
    }()
    
    lazy var segmentedControl: UISegmentedControl = {
        let items = ["강아지", "고양이", "기타 동물"]
        let control = UISegmentedControl(items: items)
        control.selectedSegmentIndex = 0 // 초기 선택 항목 설정
        control.tintColor = .blue // 세그먼트 컨트롤 색상 설정
        control.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        return control
    }()
    
    private let lineLabel3: UILabel = {
        let lb = UILabel()
        lb.layer.borderWidth = 1
        lb.layer.borderColor = UIColor.lightGray.cgColor
        return lb
    }()
    
    lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .dateAndTime // 날짜 및 시간 선택 모드 설정
        picker.locale = Locale(identifier: "ko_KR")
        picker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        return picker
    }()
    
    private let lineLabel4: UILabel = {
        let lb = UILabel()
        lb.layer.borderWidth = 1
        lb.layer.borderColor = UIColor.lightGray.cgColor
        return lb
    }()
    
    let mapView: MKMapView = {
        let map = MKMapView()
        return map
    }()
    
    private let lineLabel5: UILabel = {
        let lb = UILabel()
        lb.layer.borderWidth = 1
        lb.layer.borderColor = UIColor.lightGray.cgColor
        return lb
    }()
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.lightGray.cgColor
        return textView
    }()
    
    // 키보드 외 영역 클릭 시 키보드 사라지게 하기
    private let tapGestureRecognizer: UITapGestureRecognizer = {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        gestureRecognizer.cancelsTouchesInView = false
        return gestureRecognizer
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        configureUI()
        
        configureCollectionView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
            scrollView.contentInset = contentInset
            scrollView.scrollIndicatorInsets = contentInset

            // UITextView가 키보드 아래에 가려지지 않도록 조정
            if let selectedRange = textView.selectedTextRange {
                let caretRect = textView.caretRect(for: selectedRange.start)
                let caretY = caretRect.origin.y
                let visibleY = textView.frame.height - keyboardSize.height
                if caretY > visibleY {
                    let offsetY = caretY - visibleY
                    scrollView.setContentOffset(CGPoint(x: 0, y: offsetY), animated: true)
                }
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        let contentInset = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
        scrollView.scrollIndicatorInsets = contentInset
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        // 터치된 지점이 UITextView 내에 있는지 확인
        if !textView.frame.contains(sender.location(in: textView)) {
            // 터치된 지점이 UITextView 외부에 있으면 키보드를 숨깁니다.
            textView.resignFirstResponder()
        }
//        if !titleTextField.frame.contains(sender.location(in: titleTextField)) {
//            // 터치된 지점이 titleTextField 외부에 있으면 키보드를 숨깁니다.
//            titleTextField.resignFirstResponder()
//        }
    }
    
    
    
}


extension EnrollView: PHPickerViewControllerDelegate {
    
    @objc func customButtonTapped() {
        // PHPicker 구성
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 0 // 0은 제한 없음을 의미

        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self

        // PHPicker 화면 표시
        if let viewController = self.findViewController() {
            viewController.present(picker, animated: true, completion: nil)
        }
    }

    
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
                        self.collectionView.reloadData()
                    }
                }
            }
        }
        
    }
    
    
}

extension EnrollView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: "cell") // CustomCollectionViewCell은 셀을 표현하기 위한 사용자 정의 셀 클래스입니다.
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10) // 셀 간 여백 설정
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

// camera
extension UIView {
    func findViewController() -> UIViewController? {
        var responder: UIResponder? = self
        while responder != nil {
            if let viewController = responder as? UIViewController {
                return viewController
            }
            responder = responder?.next
        }
        return nil
    }
}


extension EnrollView {
    
    func configureUI(){
        self.addSubview(scrollView)
        scrollView.addSubviews(customBtnView, collectionView, lineLabel, titleTextField, lineLabel2, segmentedControl, lineLabel3, datePicker, lineLabel4, mapView, lineLabel5, textView)
        scrollView.addGestureRecognizer(tapGestureRecognizer)
        
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
        
        customBtnView.snp.makeConstraints {
            $0.top.equalTo(scrollView.snp.top).offset(15)
            $0.leading.equalTo(scrollView.snp.leading).offset(13)
            $0.width.height.equalTo(70)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(customBtnView.snp.top)
            $0.leading.equalTo(customBtnView.snp.trailing).offset(10) // 컬렉션뷰와 버튼 사이 여백 설정
            $0.trailing.equalTo(scrollView.snp.trailing).offset(-13)
            $0.height.equalTo(70) // 셀의 높이에 따라 조정
        }
        
        lineLabel.snp.makeConstraints {
            $0.top.equalTo(customBtnView.snp.bottom).offset(15)
            $0.leading.equalTo(scrollView.snp.leading).offset(13)
            $0.trailing.equalTo(scrollView.snp.trailing).offset(-13)
            $0.width.equalTo(scrollView.snp.width).offset(-26)
            $0.height.equalTo(0.7)
        }
        
        titleTextField.snp.makeConstraints {
            $0.top.equalTo(lineLabel.snp.bottom).offset(5)
            $0.leading.equalTo(scrollView.snp.leading).offset(13)
            $0.trailing.equalTo(scrollView.snp.trailing).offset(-13)
            $0.width.equalTo(scrollView.snp.width).offset(-26)
            $0.height.equalTo(50)
        }
        
        lineLabel2.snp.makeConstraints {
            $0.top.equalTo(titleTextField.snp.bottom).offset(5)
            $0.leading.equalTo(scrollView.snp.leading).offset(13)
            $0.trailing.equalTo(scrollView.snp.trailing).offset(-13)
            $0.width.equalTo(scrollView.snp.width).offset(-26)
            $0.height.equalTo(0.7)
        }
        
        segmentedControl.snp.makeConstraints {
            $0.top.equalTo(lineLabel2.snp.bottom).offset(10)
            $0.leading.equalTo(scrollView.snp.leading).offset(13)
            $0.trailing.equalTo(scrollView.snp.trailing).offset(-13)
            $0.height.equalTo(40)
        }
        
        lineLabel3.snp.makeConstraints {
            $0.top.equalTo(segmentedControl.snp.bottom).offset(10)
            $0.leading.equalTo(scrollView.snp.leading).offset(13)
            $0.trailing.equalTo(scrollView.snp.trailing).offset(-13)
            $0.width.equalTo(scrollView.snp.width).offset(-26)
            $0.height.equalTo(0.7)
        }
        
        datePicker.snp.makeConstraints {
            $0.top.equalTo(lineLabel3.snp.bottom).offset(10)
            $0.leading.equalTo(scrollView.snp.leading).offset(13)
            $0.trailing.equalTo(scrollView.snp.trailing).offset(-13)
            $0.width.equalTo(scrollView.snp.width).offset(-26)
            $0.height.equalTo(40)
        }
        
        lineLabel4.snp.makeConstraints {
            $0.top.equalTo(datePicker.snp.bottom).offset(10)
            $0.leading.equalTo(scrollView.snp.leading).offset(13)
            $0.trailing.equalTo(scrollView.snp.trailing).offset(-13)
            $0.width.equalTo(scrollView.snp.width).offset(-26)
            $0.height.equalTo(0.7)
        }
        
        textView.snp.makeConstraints {
            $0.top.equalTo(lineLabel4.snp.bottom).offset(10)
            $0.leading.equalTo(scrollView.snp.leading).offset(13)
            $0.trailing.equalTo(scrollView.snp.trailing).offset(-13)
//            $0.bottom.equalTo(scrollView.snp.bottom).offset(-10)
            $0.width.equalTo(scrollView.snp.width).offset(-26)
            $0.height.equalTo(250)
        }
        
        
        
        lineLabel5.snp.makeConstraints {
            $0.top.equalTo(textView.snp.bottom).offset(10)
            $0.leading.equalTo(scrollView.snp.leading).offset(13)
            $0.trailing.equalTo(scrollView.snp.trailing).offset(-13)
            $0.width.equalTo(scrollView.snp.width).offset(-26)
            $0.height.equalTo(0.7)
        }
        
        mapView.snp.makeConstraints {
            $0.top.equalTo(lineLabel5.snp.bottom).offset(10)
            $0.leading.equalTo(scrollView.snp.leading).offset(13)
            $0.trailing.equalTo(scrollView.snp.trailing).offset(-13)
            $0.bottom.equalTo(scrollView.snp.bottom).offset(-10)
            $0.height.equalTo(250)
        }

    }
    
}
