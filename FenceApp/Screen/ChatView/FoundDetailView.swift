//
//  FoundDetailView.swift
//  FenceApp
//
//  Created by t2023-m0067 on 11/13/23.
//

import UIKit
import SnapKit
import MapKit

class FoundDetailView: UIView {
    
    var imageUrl: String!
//    var nowPage: Int = 0
    
//    func getImageUrl(urlString: String) {
//        imageUrl = urlString
//    }

    var mapPin: MapPin?
    
    lazy var imageCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(FoundDetailCollectionViewCell.self, forCellWithReuseIdentifier: FoundDetailCollectionViewCell.identifier)
        cv.isPagingEnabled = true
        cv.showsHorizontalScrollIndicator = false
//        cv.dataSource = self
//        cv.delegate = self
        return cv
    }()
    
    private let writerProfileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        return imageView
    }()
    
    private let writerNickNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.text = "nickname"
        label.textAlignment = .left
        return label
    }()
    
    private let postWriteTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.text = "6분전"
        label.textColor = .systemGray2
        label.textAlignment = .right
        return label
    }()
    
    private let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray4
        return view
    }()
    
    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.showsUserLocation = true
        mapView.register(ClusterAnnotationView.self, forAnnotationViewWithReuseIdentifier: ClusterAnnotationView.identifier)
        mapView.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: CustomAnnotationView.identifier)
        mapView.register(MKUserLocationView.self, forAnnotationViewWithReuseIdentifier: "user")
        mapView.delegate = self
        mapView.clipsToBounds = true
        mapView.layer.cornerRadius = 10
        mapView.layer.borderWidth = 1
        mapView.layer.borderColor = UIColor.systemGray.cgColor
        return mapView
    }()
    
    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    override func layoutSubviews() {
        writerProfileImageView.layer.cornerRadius = 25
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(found: Found){
        writerNickNameLabel.text = found.userNickname
        writerProfileImageView.kf.setImage(with: URL(string: found.userProfileImageURL))
        postWriteTimeLabel.text = (found.date).dateToString()
        setPin(pinable: found)
    }
    
    private func setPin(pinable: Pinable) {
        mapPin = MapPin(pinable: pinable)
        mapView.addAnnotation(mapPin!)
        
        let region = MKCoordinateRegion(center: mapPin!.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        
        mapView.setRegion(region, animated: true)
    }
    
    func clearPin() {
        guard let pin = mapPin else { return }
        mapView.removeAnnotation(pin)
    }
}

extension FoundDetailView: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        
        if annotation is MKClusterAnnotation {
            //            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "mapItem", for: annotation) as! MKAnnotationView
            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: ClusterAnnotationView.identifier, for: annotation) as! ClusterAnnotationView
            
            let count = (annotation as! MKClusterAnnotation).memberAnnotations.count
            
            annotationView.setTitle(count: count)
            
            print(count)
            
            return annotationView
            
        } else if annotation is MKUserLocation {
            
            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "user", for: annotation)
            //                    annotationView.displayPriority = .defaultHigh
            return annotationView
            
        } else {
            
            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: CustomAnnotationView.identifier, for: annotation) as! CustomAnnotationView
            
            annotationView.setImage(urlString: (annotation as! MapPin).pinable.imageURL)
            
            return annotationView
        }
    }
    
}


// MARK: - AutoLayout
private extension FoundDetailView {
    func configureUI() {
        self.addSubviews(imageCollectionView, writerProfileImageView, writerNickNameLabel, postWriteTimeLabel, dividerView, mapView)
    
        imageCollectionView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(300)
        }
        
        writerProfileImageView.snp.makeConstraints {
            $0.top.equalTo(imageCollectionView.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(15)
            $0.width.height.equalTo(50)
        }
        
        writerNickNameLabel.snp.makeConstraints {
            $0.top.equalTo(imageCollectionView.snp.bottom).offset(10)
            $0.leading.equalTo(writerProfileImageView.snp.trailing).offset(15)
            $0.width.equalTo(200)
            $0.height.equalTo(30)
        }
        
        postWriteTimeLabel.snp.makeConstraints { 
            $0.top.equalTo(writerNickNameLabel.snp.bottom).offset(5)
            $0.leading.equalTo(writerProfileImageView.snp.trailing).offset(15)
            $0.height.equalTo(20)
        }
        
        dividerView.snp.makeConstraints {
            $0.top.equalTo(postWriteTimeLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(15)
            $0.height.equalTo(0.5)
        }
        
        mapView.snp.makeConstraints {
            $0.top.equalTo(dividerView.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(15)
            $0.trailing.equalToSuperview().offset(-15)
            $0.height.equalTo(250)
        }
    }
    
}

