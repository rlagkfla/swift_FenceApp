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
    let imageLoader: ImageLoader
    var lostResponseDTOs: [LostResponseDTO] = []
    var foundResponseDTOs: [FoundResponseDTO] = []
    var pinTogether: [Pinable] = []
    let firebaseLostService: FirebaseLostService
    let firebaseFoundService: FirebaseFoundService
    
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
        
        
        Task {
            do {
                lostResponseDTOs = try await firebaseLostService.fetchLosts()
                foundResponseDTOs = try await firebaseFoundService.fetchFounds()
                pinTogether = lostResponseDTOs + foundResponseDTOs
                setPinUsingMKAnnotation(pinables: pinTogether)
            } catch {
                print(error)
            }
        }
      
    }
    
    init(imageLoader: ImageLoader,firebaseLostService: FirebaseLostService, firebaseFoundService: FirebaseFoundService) {
        self.imageLoader = imageLoader
        self.firebaseLostService = firebaseLostService
        self.firebaseFoundService = firebaseFoundService
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
    
    func setPinUsingMKAnnotation(pinables: [Pinable]) {
        pinables.forEach { pinable in
            let pin1 = MapPin(pinable: pinable)
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
                    let image = try await imageLoader.fetchPhoto(urlString: (annotation as! MapPin).pinable.imageURL)
                    
                    annotationView.setImage(image: image)
                    
                } catch {
                    print(error)
                }
            }
            
            return annotationView
        }
    }
}

