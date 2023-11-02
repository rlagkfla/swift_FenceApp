//
//  PostInfoTableViewCell.swift
//  FenceApp
//
//  Created by JeonSangHyeok on 10/17/23.
//

import UIKit
import SnapKit
import MapKit

class PostInfoCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    static let identifier: String = "PostInfoCell"
    let locationManager = LocationManager()
    var mapPin: MapPin!
    
    //    let pin: MapPin?
    
    // MARK: - UI Properties
    private let postTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24)
        label.textAlignment = .left
        return label
    }()
    
    private let lostTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .left
        return label
    }()
    
    private let postDescriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    let dividerView3: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray4
        return view
    }()
    
    let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray4
        return view
    }()
    
    let dividerView2: UIView = {
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(postTitle: String, postDescription: String, lostTime: Date, lost: Lost) {
        postTitleLabel.text = postTitle
        postDescriptionLabel.text = postDescription
        
        let lostTimeDate = lostTime.convertToDate(lostTime: lostTime)
        lostTimeLabel.text = "실종 시간: \(lostTimeDate)"
        
        setPin(pinable: lost)
    }
}

// MARK: - Private Method
private extension PostInfoCollectionViewCell {
    private func setLabel(lostTime: Date) {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 MM월 dd일 HH시 mm분"
        
        let converDate = formatter.string(from: lostTime)
        
        lostTimeLabel.text = "잃어버린 시간: \(String(describing: converDate))"
    }
    
    private func setPin(pinable: Pinable) {
        mapPin = MapPin(pinable: pinable)
        mapView.addAnnotation(mapPin)
        
        let region = MKCoordinateRegion(center: mapPin.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        
        mapView.setRegion(region, animated: true)
    }
}

// MARK: - AutoLayout
private extension PostInfoCollectionViewCell {
    func configureUI() {
        configureDividerView3()
        configurePostTitleLabel()
        configureDividerView()
        configureLostTimeLabel()
        configurePostDescriptionLabel()
        configureMapView()
        
    }
    
    func configureDividerView3() {
        contentView.addSubview(dividerView3)
        
        dividerView3.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.height.equalTo(0.5)
        }
    }
    
    func configurePostTitleLabel() {
        contentView.addSubview(postTitleLabel)
        
        postTitleLabel.snp.makeConstraints {
            $0.top.equalTo(dividerView3.snp.top).offset(10)
            $0.leading.trailing.equalToSuperview().inset(10)
//            $0.height.equalTo(30)
        }
    }
    
    func configureDividerView() {
        contentView.addSubview(dividerView)
        
        dividerView.snp.makeConstraints {
            $0.top.equalTo(postTitleLabel.snp.bottom).offset(5)
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.height.equalTo(0.5)
        }
    }
    
    func configureLostTimeLabel() {
        contentView.addSubview(lostTimeLabel)
        
        lostTimeLabel.snp.makeConstraints {
            $0.top.equalTo(dividerView.snp.bottom).offset(5)
            $0.leading.equalTo(contentView.snp.leading).offset(10)
            $0.trailing.equalTo(contentView.snp.trailing).offset(-10)
            $0.height.equalTo(30)
        }
    }
    
    
    func configurePostDescriptionLabel() {
        contentView.addSubview(postDescriptionLabel)
        
        postDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(lostTimeLabel.snp.bottom).offset(5)
            $0.leading.equalTo(contentView.snp.leading).offset(10)
            $0.trailing.equalTo(contentView.snp.trailing).offset(-10)
            $0.height.equalTo(24)
        }
    }
    
    func configureMapView() {
        contentView.addSubview(mapView)
        
        mapView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.top.equalTo(postDescriptionLabel.snp.bottom).offset(10)
            $0.leading.equalTo(contentView.snp.leading).offset(10)
            $0.trailing.equalTo(contentView.snp.trailing).offset(-10)
            $0.height.equalTo(250)
        }
    }
}

// MARK: - MKMapViewDelegate
extension PostInfoCollectionViewCell: MKMapViewDelegate {
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
