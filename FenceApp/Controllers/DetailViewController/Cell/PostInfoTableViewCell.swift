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
    let postTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "강아지 찾아주세요"
        label.font = UIFont.systemFont(ofSize: 24)
        label.textAlignment = .left
        return label
    }()
    
    let lostTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .left
        return label
    }()
    
    let postDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "강아지 잃어버렸어용ㅠㅠ강아지 잃어버렸어용ㅠㅠ강아지 잃어버렸어용ㅠㅠ강아지 잃어버렸어용ㅠㅠ강아지 잃어버렸어용ㅠㅠ강아지 잃어버렸어용ㅠㅠ강아지 잃어버렸어용ㅠㅠ강아지 잃어버렸어용ㅠㅠ강아지 잃어버렸어용ㅠㅠ강아지 잃어버렸어용ㅠㅠ강아지 잃어버렸어용ㅠㅠ강아지 잃어버렸어용ㅠㅠ강아지 잃어버렸어용ㅠㅠ강아지 잃어버렸어용ㅠㅠ강아지 잃어버렸어용ㅠㅠ강아지 잃어버렸어용ㅠㅠ"
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.showsUserLocation = true
        mapView.register(ClusterAnnotationView.self, forAnnotationViewWithReuseIdentifier: ClusterAnnotationView.identifier)
        mapView.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: CustomAnnotationView.identifier)
        mapView.register(MKUserLocationView.self, forAnnotationViewWithReuseIdentifier: "user")
        mapView.delegate = self
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
    
    func configureCell(postTitle: String, postDescription: String, lostTime: Date, lostDTO: LostResponseDTO) {
        postTitleLabel.text = postTitle
        postDescriptionLabel.text = postDescription
        setLabel(lostTime: lostTime)
        setPin(pinable: lostDTO)
        centerViewOnUserLocation()
    }
    
    private func setLabel(lostTime: Date) {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 MM월 dd일 HH시 mm분"
        
        let converDate = formatter.string(from: lostTime)
        
        lostTimeLabel.text = "잃어버린 시간: \(String(describing: converDate))"
    }
    
    private func centerViewOnUserLocation() {
        
        guard let location = locationManager.fetchLocation() else { return }
        
        let region = MKCoordinateRegion(center: location, latitudinalMeters: 10000, longitudinalMeters: 10000)
        
        mapView.setRegion(region, animated: true)
    }
    
    private func setPin(pinable: Pinable) {
        mapPin = MapPin(pinable: pinable)
        mapView.addAnnotation(mapPin)
    }
}

// MARK: - AutoLayout
private extension PostInfoCollectionViewCell {
    func configureUI() {
        configurePostTitleLabel()
        configureLostTimeLabel()
        configureMapView()
        configurePostDescriptionLabel()
    }
    
    func configurePostTitleLabel() {
        contentView.addSubview(postTitleLabel)
        
        postTitleLabel.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.top).offset(5)
            $0.leading.equalTo(contentView.snp.leading).offset(10)
            $0.trailing.equalTo(contentView.snp.trailing).offset(-10)
            $0.height.equalTo(30)
        }
    }
    
    func configureLostTimeLabel() {
        contentView.addSubview(lostTimeLabel)
        
        lostTimeLabel.snp.makeConstraints {
            $0.top.equalTo(postTitleLabel.snp.bottom).offset(5)
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
            $0.bottom.equalTo(mapView.snp.top).offset(-5)
        }
    }
    
    func configureMapView() {
        contentView.addSubview(mapView)
        
        mapView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.leading.equalTo(contentView.snp.leading).offset(10)
            $0.trailing.equalTo(contentView.snp.trailing).offset(-10)
            $0.height.equalTo(250)
        }
    }
}


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
