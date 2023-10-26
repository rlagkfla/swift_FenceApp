//
//  MapMainView.swift
//  FenceApp
//
//  Created by Woojun Lee on 10/17/23.
//

import UIKit
import SnapKit
import MapKit

protocol mapMainViewDelegate: AnyObject {
    func locationImageViewTapped()
    
    func filterImageViewTapped()
}

class MapMainView: UIView {
    
    
    //MARK: - Properties
    
    weak var delegate: mapMainViewDelegate?
    
    lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.showsUserLocation = true
        mapView.delegate = self
        
        mapView.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: CustomAnnotationView.identifier)
        mapView.register(ClusterAnnotationView.self, forAnnotationViewWithReuseIdentifier: ClusterAnnotationView.identifier)
        mapView.register(MKUserLocationView.self, forAnnotationViewWithReuseIdentifier: "user")
        return mapView
    }()
    
    private let segmentedControl: UISegmentedControl = {
        let view = UISegmentedControl()
        view.isUserInteractionEnabled = true
        view.backgroundColor = .white
        view.insertSegment(withTitle: "lost", at: 0, animated: true)
        view.insertSegment(withTitle: "found", at: 1, animated: true)
        view.selectedSegmentIndex = 0
        return view
    }()
    
    private lazy var filterImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "line.3.horizontal.decrease.circle")
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(filterImageViewTapped)))
        iv.tintColor = .gray
        return iv
    }()
    
    private lazy var locationImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "location.circle")
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(locationImageViewTapped)))
        iv.isUserInteractionEnabled = true
        iv.tintColor = .gray
        return iv
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Actions
    
    @objc func filterImageViewTapped() {
        delegate?.filterImageViewTapped()
        
    }
    
    @objc func locationImageViewTapped() {
        delegate?.locationImageViewTapped()
        
        
    }
    
    //MARK: - Helpers
    
    //MARK: - UI
    
    private func configureUI() {
        configureMapView()
        configureSegmentedControl()
        configureLocationImageView()
        configureOptionImageView()
    }
    
    private func configureMapView() {
        addSubview(mapView)
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func configureSegmentedControl() {
        addSubview(segmentedControl)
        segmentedControl.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(50)
            make.centerX.equalToSuperview()
            make.width.equalTo(150)
            make.height.equalTo(40)
        }
    }
    
    private func configureLocationImageView() {
        addSubview(locationImageView)
        locationImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(100)
            make.width.height.equalTo(45)
        }
    }
    
    private func configureOptionImageView() {
        addSubview(filterImageView)
        filterImageView.snp.makeConstraints { make in
            make.bottom.equalTo(locationImageView.snp.top).offset(-20)
            make.trailing.equalToSuperview().inset(10)
            make.width.height.equalTo(45)
        }
    }
}

extension MapMainView: MKMapViewDelegate {
    
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
            //            annotationView.clusteringIdentifier = String(describing: LocationDataMapAnnotationView.self)
            
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
