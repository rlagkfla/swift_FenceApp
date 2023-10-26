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
    
    private lazy var mapView: MKMapView = {
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

// MARK: - MKMapViewDelegate
extension PostInfoCollectionViewCell: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKClusterAnnotation {
            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: ClusterAnnotationView.identifier, for: annotation) as! ClusterAnnotationView
            let count = (annotation as! MKClusterAnnotation).memberAnnotations.count
            annotationView.setTitle(count: count)
            return annotationView
        } else if annotation is MKUserLocation {
            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "user", for: annotation)
            return annotationView
        } else {
            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: CustomAnnotationView.identifier, for: annotation) as! CustomAnnotationView
            
            Task {
                do {
                    let image = try await ImageLoader.fetchPhoto(urlString: (annotation as! MapPin).pinable.imageURL)
                    annotationView.setImage(image: image)
                } catch {
                    print(error)
                }
            }
            return annotationView
        }
    }
}
