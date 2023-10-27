//
//  EnrollView.swift
//  FenceApp
//
//  Created by t2023-m0067 on 10/19/23.
//

import UIKit
import SnapKit
import MapKit

class EnrollView: UIView {
    
    let scrollView: UIScrollView = {
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
        view.isUserInteractionEnabled = true
        return view
    }()
    
    let collectionView: UICollectionView = {
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
    
    let titleTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "제목을 입력하세요."
        tf.isUserInteractionEnabled = true
        tf.backgroundColor = .clear
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
        let backgroundImage = UIImage()
        control.setBackgroundImage(backgroundImage, for: .normal, barMetrics: .default)
        control.setBackgroundImage(backgroundImage, for: .selected, barMetrics: .default)
        control.setBackgroundImage(backgroundImage, for: .highlighted, barMetrics: .default)
        let deviderImage = UIImage()
        control.setDividerImage(deviderImage, forLeftSegmentState: .selected, rightSegmentState: .normal, barMetrics: .default)
        control.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.gray], for: .normal)
        control.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(named: "AccentColor")], for: .selected)
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
        return picker
    }()
    
    private let lineLabel4: UILabel = {
        let lb = UILabel()
        lb.layer.borderWidth = 1
        lb.layer.borderColor = UIColor.lightGray.cgColor
        return lb
    }()
    
    let nameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "반려동물의 이름을 입력하세요."
        tf.isUserInteractionEnabled = true
        tf.backgroundColor = .clear
        return tf
    }()
    
    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.delegate = self
        textView.text = "상세 내용을 입력하세요. (반려 동물의 특징, 잃어버린 위치 등)"
        textView.textColor = nameTextField.attributedPlaceholder?.attribute(.foregroundColor, at: 0, effectiveRange: nil) as? UIColor
        textView.autocorrectionType = .no
        textView.backgroundColor = .clear
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.lightGray.cgColor
        return textView
    }()
    
    private let lineLabel5: UILabel = {
        let lb = UILabel()
        lb.layer.borderWidth = 1
        lb.layer.borderColor = UIColor.lightGray.cgColor
        return lb
    }()
    
    private let mapLable: UILabel = {
        let lb = UILabel()
        lb.text = "📍 잃어버린 위치"
        lb.font = UIFont.systemFont(ofSize: 15)
        lb.textColor = .darkGray
        return lb
    }()
    
    let mapView: MKMapView = {
        let map = MKMapView()
        map.layer.cornerRadius = 15
        return map
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        configureUI()
      
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}

extension EnrollView: UITextViewDelegate {
    
    // UITextViewDelegate를 준수하는 클래스 내에서 다음 메서드를 구현
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "상세 내용을 입력하세요. (반려 동물의 특징, 잃어버린 위치 등)" {
            textView.text = ""
            textView.textColor = .darkGray
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "상세 내용을 입력하세요. (반려 동물의 특징, 잃어버린 위치 등)"
            textView.textColor = nameTextField.attributedPlaceholder?.attribute(.foregroundColor, at: 0, effectiveRange: nil) as? UIColor
        }
    }
}

extension EnrollView {
    
    func configureUI(){
        self.addSubview(scrollView)
        scrollView.addSubviews(customBtnView, collectionView, lineLabel, titleTextField, lineLabel2, segmentedControl, lineLabel3, datePicker, lineLabel4, nameTextField, textView, lineLabel5, mapLable, mapView)
        
        
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
            $0.top.equalTo(scrollView.snp.top)
            $0.leading.equalTo(customBtnView.snp.trailing).offset(10) // 컬렉션뷰와 버튼 사이 여백 설정
            $0.trailing.equalTo(scrollView.snp.trailing).offset(-13)
            $0.bottom.equalTo(lineLabel.snp.top)
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
            $0.height.equalTo(40)
        }
        
        lineLabel4.snp.makeConstraints {
            $0.top.equalTo(datePicker.snp.bottom).offset(10)
            $0.leading.equalTo(scrollView.snp.leading).offset(13)
            $0.trailing.equalTo(scrollView.snp.trailing).offset(-13)
            $0.width.equalTo(scrollView.snp.width).offset(-26)
            $0.height.equalTo(0.7)
        }
        
        nameTextField.snp.makeConstraints {
            $0.top.equalTo(lineLabel4.snp.bottom).offset(10)
            $0.leading.equalTo(scrollView.snp.leading).offset(13)
            $0.trailing.equalTo(scrollView.snp.trailing).offset(-13)
            $0.width.equalTo(scrollView.snp.width).offset(-26)
            $0.height.equalTo(50)
        }
        
        textView.snp.makeConstraints {
            $0.top.equalTo(nameTextField.snp.bottom).offset(10)
            $0.leading.equalTo(scrollView.snp.leading).offset(13)
            $0.trailing.equalTo(scrollView.snp.trailing).offset(-13)
//            $0.bottom.equalTo(scrollView.snp.bottom).offset(-10)
            $0.width.equalTo(scrollView.snp.width).offset(-26)
            $0.height.equalTo(200)
        }
        
        lineLabel5.snp.makeConstraints {
            $0.top.equalTo(textView.snp.bottom).offset(15)
            $0.leading.equalTo(scrollView.snp.leading).offset(13)
            $0.trailing.equalTo(scrollView.snp.trailing).offset(-13)
            $0.width.equalTo(scrollView.snp.width).offset(-26)
            $0.height.equalTo(0.7)
        }
        
        mapLable.snp.makeConstraints {
            $0.top.equalTo(lineLabel5.snp.bottom).offset(15)
            $0.leading.equalTo(scrollView.snp.leading).offset(13)
            $0.trailing.equalTo(scrollView.snp.trailing).offset(-13)
        }
        
        mapView.snp.makeConstraints {
            $0.top.equalTo(mapLable.snp.bottom).offset(15)
            $0.leading.equalTo(scrollView.snp.leading).offset(13)
            $0.trailing.equalTo(scrollView.snp.trailing).offset(-13)
            $0.bottom.equalTo(scrollView.snp.bottom).offset(-20)
            $0.height.equalTo(250)
        }

    }
    
}
