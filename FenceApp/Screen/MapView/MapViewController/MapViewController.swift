//
//  MapViewController.swift
//  FenceApp
//
//  Created by JeonSangHyeok on 10/16/23.
//

import UIKit
import MapKit
import SnapKit

class MapViewController: UIViewController {
    
    //MARK: - Properties
    
    let lostDTOs: [LostResponseDTO] = LostResponseDTO.dummyLost
    let imageLoader: ImageLoader
    let mapMainView = MapMainView()
    lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        
        mapView.delegate = self
        mapView.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: CustomAnnotationView.identifier)
        
        
        mapView.register(ClusterAnnotationView.self, forAnnotationViewWithReuseIdentifier: ClusterAnnotationView.identifier)
        return mapView
    }()
    
    //MARK: - Lifecycle
    
//    override func loadView() {
//        view = mapMainView
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "제목을 바꿔요 손모가지 검"
        configureUI()
        setPinUsingMKAnnotation(lostDTOs: lostDTOs)
      
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
    
    func setPinUsingMKAnnotation(lostDTOs: [LostResponseDTO]) {
        lostDTOs.forEach { lostDTO in
            let pin1 = MapPin(lostDTO: lostDTO)
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
                    let image = try await imageLoader.fetchPhoto(urlString: (annotation as! MapPin).lostDTO.pictureURL)
                    
                    annotationView.setImage(image: image)
                    
                } catch {
                    print(error)
                }
            }
            
            return annotationView
            
=======
import FirebaseAuth


class MapViewController: UIViewController {
    private lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    private let userInfoService = UserInfoService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Task { await fetchAndDisplayUserEmail() }
        view.backgroundColor = .yellow
        setupEmailLabel()
        
    }
    
    private func setupEmailLabel() {
        view.addSubview(emailLabel)
        emailLabel
            .centerX()
            .centerY()
    }
    
    private func fetchAndDisplayUserEmail() async {
        guard let user = Auth.auth().currentUser else { print("Failed \(#function)"); return}
        
        do {
            guard let userEmail =
                    try await userInfoService.fetchUserEmail(for: user.uid) else {print("Failed \(#function) - Email not found");return}
            emailLabel.text = userEmail
            
        } catch {
            print(error.localizedDescription)
        }
    }
}

       
        
        
        
        





