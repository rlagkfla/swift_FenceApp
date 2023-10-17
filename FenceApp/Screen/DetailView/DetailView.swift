//
//  DetailView.swift
//  FenceApp
//
//  Created by JeonSangHyeok on 10/17/23.
//

import UIKit
import SnapKit
import MapKit

class DetailView: UIView {
    
    // MARK: - UI Properties
//    lazy var tableView: UITableView = {
//        let tableView = UITableView()
////        tableView.register(ImageCollectionViewCell.self, forCellReuseIdentifier: ImageCollectionViewCell.identifier)
////        tableView.register(WriterInfoTableViewCell.self, forCellReuseIdentifier: WriterInfoTableViewCell.identifier)
////        tableView.register(PostInfoTableViewCell.self, forCellReuseIdentifier: PostInfoTableViewCell.identifier)
//        return tableView
//    }()
    
    lazy var imageCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
        collectionView.decelerationRate = .fast
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = 3
        pageControl.currentPage = 0
        return pageControl
    }()
    
    let writerProfileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "코주부 원숭이")
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.clear.cgColor
        
        return imageView
    }()
    
    let writerNickNameLabel: UILabel = {
        let label = UILabel()
        label.text = "코주부 원숭이"
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .left
        label.backgroundColor = .red
        return label
    }()
    
    let postWriteTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "\(Calendar.current.dateComponents([.minute], from: Date()))"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .systemGray
        label.textAlignment = .center
        label.backgroundColor = .yellow
        return label
    }()
    
    let postTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "강아지 찾아주세요"
        label.font = UIFont.systemFont(ofSize: 24)
        label.textAlignment = .left
        label.backgroundColor = .red
        return label
    }()
    
    let lostTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "잃어버린 시간: \(Date())"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .center
        label.backgroundColor = .yellow
        return label
    }()
    
    let postDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "강아지 잃어버렸어용ㅠㅠ강아지 잃어버렸어용ㅠㅠ강아지 잃어버렸어용ㅠㅠ강아지 잃어버렸어용ㅠㅠ강아지 잃어버렸어용ㅠㅠ강아지 잃어버렸어용ㅠㅠ강아지 잃어버렸어용ㅠㅠ강아지 잃어버렸어용ㅠㅠ강아지 잃어버렸어용ㅠㅠ강아지 잃어버렸어용ㅠㅠ강아지 잃어버렸어용ㅠㅠ"
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 18)
        label.backgroundColor = .red
        return label
    }()
//    
    let mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        return mapView
    }()

    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
        
        
        let center2 = CLLocationCoordinate2D(latitude: 37.336018, longitude: 126.851301)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: center2, span: span)
        
        mapView.setRegion(region, animated: true)
        
        createMark()
    }
    
    override func layoutSubviews() {
        writerProfileImageView.layer.cornerRadius = 25
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createMark() {
        let mark = MKPointAnnotation()
        
        mark.coordinate = CLLocationCoordinate2D(latitude: 37.336018, longitude: 126.851301)
        
        mark.title = "Home"
        
        mapView.addAnnotation(mark)
    }
}

// MARK: - AutoLayout
private extension DetailView {
    
    func configureUI() {
//        self.addSubview(tableView)
//        
//        tableView.snp.makeConstraints {
//            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top)
//            $0.leading.equalTo(self.safeAreaLayoutGuide.snp.leading)
//            $0.trailing.equalTo(self.safeAreaLayoutGuide.snp.trailing)
//            $0.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
//        }
        configureImageCollectionView()
        configurePageControl()
        configureWriterProfileImageView()
        configureWriterNickNameLabel()
        configurePostWriteTimeLabel()
        configurePostTitleLabel()
        configureLostTimeLabel()
        configurePostDescriptionLabel()
        configureMapView()
    }
    
    func configureImageCollectionView() {
        self.addSubview(imageCollectionView)
        
        imageCollectionView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            $0.leading.equalTo(self.safeAreaLayoutGuide.snp.leading)
            $0.trailing.equalTo(self.safeAreaLayoutGuide.snp.trailing)
            $0.height.equalTo(300)
        }
    }
    
    func configurePageControl() {
        self.addSubview(pageControl)
        
        pageControl.snp.makeConstraints {
            $0.centerY.equalTo(self.safeAreaLayoutGuide.snp.top).offset(285)
            $0.centerX.equalToSuperview()
        }
    }
    
    func configureWriterProfileImageView() {
        self.addSubview(writerProfileImageView)
        
        writerProfileImageView.snp.makeConstraints {
            $0.top.equalTo(imageCollectionView.snp.bottom).offset(10)
            $0.leading.equalTo(self.safeAreaLayoutGuide.snp.leading).offset(10)
            $0.width.height.equalTo(50)
        }
    }
    
    func configureWriterNickNameLabel() {
        self.addSubview(writerNickNameLabel)
        
        writerNickNameLabel.snp.makeConstraints {
            $0.centerY.equalTo(writerProfileImageView.snp.centerY)
            $0.leading.equalTo(writerProfileImageView.snp.trailing).offset(10)
            $0.width.equalTo(200)
            $0.height.equalTo(50)
        }
    }
    
    func configurePostWriteTimeLabel() {
        self.addSubview(postWriteTimeLabel)
        
        postWriteTimeLabel.snp.makeConstraints {
            $0.centerY.equalTo(writerProfileImageView.snp.centerY)
            $0.leading.equalTo(writerNickNameLabel.snp.trailing)
            $0.trailing.equalTo(self.safeAreaLayoutGuide.snp.trailing).offset(-10)
            $0.height.equalTo(50)
        }
    }
    
    func configurePostTitleLabel() {
        self.addSubview(postTitleLabel)
        
        postTitleLabel.snp.makeConstraints {
            $0.top.equalTo(writerProfileImageView.snp.bottom).offset(5)
            $0.leading.equalTo(self.safeAreaLayoutGuide.snp.leading).offset(10)
            $0.trailing.equalTo(self.safeAreaLayoutGuide.snp.trailing).offset(-10)
            $0.height.equalTo(30)
        }
    }
    
    func configureLostTimeLabel() {
        self.addSubview(lostTimeLabel)
        
        lostTimeLabel.snp.makeConstraints {
            $0.top.equalTo(postTitleLabel.snp.bottom).offset(5)
            $0.leading.equalTo(self.safeAreaLayoutGuide.snp.leading).offset(10)
            $0.trailing.equalTo(self.safeAreaLayoutGuide.snp.trailing).offset(-10)
            $0.height.equalTo(30)
        }
    }
    
    func configurePostDescriptionLabel() {
        self.addSubview(postDescriptionLabel)
        
        postDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(lostTimeLabel.snp.bottom).offset(5)
            $0.leading.equalTo(self.safeAreaLayoutGuide.snp.leading).offset(10)
            $0.trailing.equalTo(self.safeAreaLayoutGuide.snp.trailing).offset(-10)
//            $0.height.equalTo(100)
        }
    }
    
    func configureMapView() {
        self.addSubview(mapView)
        
        mapView.snp.makeConstraints {
            $0.top.equalTo(postDescriptionLabel.snp.bottom).offset(50)
            $0.leading.equalTo(self.safeAreaLayoutGuide.snp.leading).offset(10)
            $0.trailing.equalTo(self.safeAreaLayoutGuide.snp.trailing).offset(-10)
            $0.height.equalTo(250)
        }
    }
}
