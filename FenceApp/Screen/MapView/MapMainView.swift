//
//  MapMainView.swift
//  FenceApp
//
//  Created by Woojun Lee on 10/17/23.
//

import UIKit
import SnapKit
import MapKit

protocol MapMainViewDelegate: AnyObject {
    
    func locationImageViewTapped()
    
    func filterImageViewTapped()
    
    func petImageTappedOnMap(annotation: MKAnnotation)
    
    func segmentTapped(onIndex: Int)
}

class MapMainView: UIView {
    
    
    //MARK: - Properties
    
    weak var delegate: MapMainViewDelegate?
    
    lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.showsUserLocation = true
        mapView.delegate = self
        mapView.isRotateEnabled = false
        mapView.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: CustomAnnotationView.identifier)
        mapView.register(ClusterAnnotationView.self, forAnnotationViewWithReuseIdentifier: ClusterAnnotationView.identifier)
        mapView.register(MKUserLocationView.self, forAnnotationViewWithReuseIdentifier: "user")
        return mapView
    }()
    
    lazy var segmentedControl: UISegmentedControl = {
        let view = UISegmentedControl()
        view.isUserInteractionEnabled = true
        view.tintColor = .white
        view.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        view.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .normal)
        view.backgroundColor = .white
        view.selectedSegmentTintColor = CustomColor.pointColor
        view.insertSegment(withTitle: "Lost", at: 0, animated: true)
        view.insertSegment(withTitle: "Found", at: 1, animated: true)
        view.selectedSegmentIndex = 0
        view.addTarget(self, action: #selector(segmentTapped(_:)), for: .valueChanged)
        return view
    }()
    
    private lazy var filterImageView: UIImageView = {
        let iv = UIImageView()
        
        let image = UIImage(systemName: "line.3.horizontal.decrease.circle.fill", withConfiguration:UIImage.SymbolConfiguration(weight: .medium))?
            .applyingSymbolConfiguration(UIImage.SymbolConfiguration(paletteColors:[.white, .systemGray2]))
        iv.image = image
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(filterImageViewTapped)))
        
        return iv
    }()
    
    private lazy var locationImageView: UIImageView = {
        let iv = UIImageView()
        let image = UIImage(systemName: "location.circle.fill", withConfiguration:UIImage.SymbolConfiguration(weight: .medium))?
            .applyingSymbolConfiguration(UIImage.SymbolConfiguration(paletteColors:[.white, .label, .systemGray2]))
        iv.image = image
        //UIColor(hexCode: "55BCEF")
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(locationImageViewTapped)))
        iv.isUserInteractionEnabled = true

        return iv
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        configureUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        mapView.layer.cornerRadius = mapView.frame.height / 40
    }
    
    //MARK: - Actions
    
    @objc func segmentTapped(_ sender: UISegmentedControl) {
        delegate?.segmentTapped(onIndex: sender.selectedSegmentIndex)
    }
    
    @objc func filterImageViewTapped() {
        delegate?.filterImageViewTapped()
        
    }
    
    @objc func locationImageViewTapped() {
        delegate?.locationImageViewTapped()
    }
    
    //MARK: - Helpers
    
}

extension MapMainView: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKClusterAnnotation {
            
            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: ClusterAnnotationView.identifier, for: annotation) as! ClusterAnnotationView
            
            let count = (annotation as! MKClusterAnnotation).memberAnnotations.count
            
            annotationView.setTitle(count: count)
            
            print(count)
            
            return annotationView
            
        } else if annotation is MKUserLocation {
            
            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "user", for: annotation)
            
            return annotationView
            
        } else {
            
            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: CustomAnnotationView.identifier, for: annotation) as! CustomAnnotationView
            
            annotationView.delegate = self
            
            annotationView.setImage(urlString: (annotation as! MapPin).pinable.imageURL)
             
            return annotationView
        }
    }
}

extension MapMainView: CustomAnnotationViewDelegate {
    
    func annotationViewTapped(annotation: MKAnnotation) {
        delegate?.petImageTappedOnMap(annotation: annotation)
    }
}

//MARK: - UI


extension MapMainView {
    
    
    private func configureUI() {
        configureMapView()
        configureSegmentedControl()
        configureLocationImageView()
        configureOptionImageView()
    }
    
    
    private func configureMapView() {
        addSubview(mapView)
        mapView.snp.makeConstraints { make in
            make.top.equalToSuperview()
//            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    
    private func configureSegmentedControl() {
        addSubview(segmentedControl)
        segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.centerX.equalToSuperview()
            make.width.equalTo(170)
            make.height.equalTo(40)
        }
    }
    
    
    private func configureLocationImageView() {
        addSubview(filterImageView)
        filterImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(30)
            make.width.height.equalTo(60)
        }
    }
    
    
    private func configureOptionImageView() {
        addSubview(locationImageView)
        locationImageView.snp.makeConstraints { make in
            make.bottom.equalTo(filterImageView.snp.top).offset(-20)
            make.trailing.equalToSuperview().inset(10)
            make.width.height.equalTo(60)
        }
    }
}

