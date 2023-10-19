//
//  MapViewController.swift
//  FenceApp
//
//  Created by JeonSangHyeok on 10/16/23.
//

import UIKit
import MapKit
import SnapKit

class MapPin: NSObject, MKAnnotation {
    
   
    
    var coordinate: CLLocationCoordinate2D
    let lost: Lost
    
    init(lost: Lost) {
        self.lost = lost
        self.coordinate = CLLocationCoordinate2D(latitude: lost.latitude, longitude: lost.longitude)
    }
}

final class LocationDataMapClusterView: MKAnnotationView {
    
    static let identifier = "LocationDataMapClusterView"
    
    // MARK: Initialization
    private let countLabel = UILabel()
    
    override var annotation: MKAnnotation? {
        didSet {
            guard let annotation = annotation as? MKClusterAnnotation else {
                assertionFailure("Using LocationDataMapClusterView with wrong annotation type")
                return
            }
            
            countLabel.text = annotation.memberAnnotations.count < 100 ? "\(annotation.memberAnnotations.count)" : "99+"
        }
    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        displayPriority = .defaultHigh
        collisionMode = .circle
        
        frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        centerOffset = CGPoint(x: 0, y: -frame.size.height / 2)
        
        
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Setup
    private func setupUI() {
        
    }
}

class CustomAnnotationView: MKAnnotationView {
    
    static let identifier = "CustomAnnotationView"
    
    override var annotation: MKAnnotation? {
        didSet {
            
            clusteringIdentifier = "shop"
            //            image = UIImage(systemName: "house")
        }
    }
    
    lazy var customImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        view.backgroundColor = .lightGray
        view.clipsToBounds = true
        return view
    }()
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        self.layer.cornerRadius = 40 / 2
        configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configUI() {
        self.clipsToBounds = true
        configureCustomImageView()
    }
    
    private func configureCustomImageView() {
        self.addSubview(customImageView)
        
        customImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setImage(image: UIImage) {
        customImageView.image = image
    }
    
    // Annotation도 재사용을 하므로 재사용 전 값을 초기화 시켜서 다른 값이 들어가는 것을 방지
    override func prepareForReuse() {
        super.prepareForReuse()
        customImageView.image = nil
        
    }
    
    
    
    // 이 메서드는 annotation이 뷰에서 표시되기 전에 호출됩니다.
    // 즉, 뷰에 들어갈 값을 미리 설정할 수 있습니다
    //    override func prepareForDisplay() {
    //        super.prepareForDisplay()
    //
    //        guard let annotation = annotation as? CustomAnnotation else { return }
    //
    //        titleLabel.text = annotation.title
    //
    //        guard let imageName = annotation.imageName,
    //              let image = UIImage(named: imageName) else { return }
    //
    //        customImageView.image = image
    //
    //        // 이미지의 크기 및 레이블의 사이즈가 변경될 수도 있으므로 레이아웃을 업데이트 한다.
    //        setNeedsLayout()
    //
    //        // 참고. drawing life cycle :
    //        // setNeedsLayout를 통해 다음 런루프에서 레이아웃을 업데이트하도록 예약
    //        // -> layoutSubviews을 통해 레이아웃 업데이트
    //
    //        // layoutSubviews를 쓰려면 setNeedsLayout도 항상 같이 사용해야 한다고 하네요.
    //    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
}

class ClusterAnnotationView: MKAnnotationView {
    
    static let identifier = "ClusterAnnotationView1"
    
    let label: UILabel = {
       let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
        override var annotation: MKAnnotation? {
            didSet {
                displayPriority = .defaultHigh

                
                collisionMode = .circle
                
                frame = CGRect(x: 0, y: 0, width: 40, height: 40)
                centerOffset = CGPoint(x: 0, y: -frame.size.height / 2)
                
            }
        }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.annotation = annotation
        configureUI()
    }
    
   
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        self.layer.cornerRadius = 20
        self.backgroundColor = .systemBlue
        addSubview(label)
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setTitle(count: Int) {
        label.text = String(count)
    }
}

class MapViewController: UIViewController {
    
    //MARK: - Properties
    
    
    
    let losts: [Lost] = Lost.dummyLost
    let imageLoader: ImageLoader
    let mapMainView = MapMainView()
    lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        
        mapView.delegate = self
        mapView.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: CustomAnnotationView.identifier)
        mapView.register(LocationDataMapClusterView.self, forAnnotationViewWithReuseIdentifier: LocationDataMapClusterView.identifier)
        
        mapView.register(ClusterAnnotationView.self, forAnnotationViewWithReuseIdentifier: ClusterAnnotationView.identifier)
        return mapView
    }()
    
    //MARK: - Lifecycle
    
//    override func loadView() {
//        view = mapMainView
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setPinUsingMKAnnotation(losts: losts)
      
    }
    
    init(imageLoader: ImageLoader) {
        self.imageLoader = imageLoader
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Actions
    
    //MARK: - Helpers
    
    //MARK: - UI
    
    private func configureUI() {
        configureMapView()
    }
    
    private func configureMapView() {
        view.addSubview(mapView)
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setPinUsingMKAnnotation(losts: [Lost]) {
        losts.forEach { lost in
            let pin1 = MapPin(lost: lost)
            mapView.addAnnotations([pin1])
            
        }
    }
}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
       
        
        if annotation is MKClusterAnnotation {
            //            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "mapItem", for: annotation) as! MKAnnotationView
            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: ClusterAnnotationView.identifier, for: annotation) as! ClusterAnnotationView
            let count = (annotation as! MKClusterAnnotation).memberAnnotations.count
            annotationView.setTitle(count: count)
            
            print(count)
            
            return annotationView
        } else {
            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: CustomAnnotationView.identifier, for: annotation) as! CustomAnnotationView
            //            annotationView.clusteringIdentifier = String(describing: LocationDataMapAnnotationView.self)
            
            Task {
                do {
                    let image = try await imageLoader.fetchPhoto(urlString: (annotation as! MapPin).lost.picture)
                    
                    annotationView.setImage(image: image)
                    
                } catch {
                    print(error)
                }
            }
            
            return annotationView
            
        }
    }
}

       
        
        
        
        





