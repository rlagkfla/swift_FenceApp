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
    
    var lostResponseDTOs: [LostResponseDTO] = []
    var foundResponseDTOs: [FoundResponseDTO] = []
    var pinTogether: [Pinable] = []
    let firebaseLostService: FirebaseLostService
    let firebaseFoundService: FirebaseFoundService
    
    let filterTapped: () -> Void
    
    lazy var mainView: MapMainView = {
        let view = MapMainView()
        view.delegate = self
        return view
    }()
    
    let locationManager: LocationManager
    
   
    
    //MARK: - Lifecycle
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
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
    
    init(firebaseLostService: FirebaseLostService, firebaseFoundService: FirebaseFoundService, locationManager: LocationManager, filterTapped: @escaping () -> Void) {
        
        self.firebaseLostService = firebaseLostService
        self.firebaseFoundService = firebaseFoundService
        self.locationManager = locationManager
        self.filterTapped = filterTapped
        print("I am inited")
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Actions
    
    //MARK: - Helpers
    
    //MARK: - UI
    
    private func setPinUsingMKAnnotation(pinables: [Pinable]) {
        pinables.forEach { pinable in
            let pin1 = MapPin(pinable: pinable)
            mainView.mapView.addAnnotations([pin1])
            
        }
    }
    
    private func centerViewOnUserLocation() {
        
        guard let location = locationManager.fetchLocation() else { return }
        
        let region = MKCoordinateRegion(center: location, latitudinalMeters: 10000, longitudinalMeters: 10000)
        
        mainView.mapView.setRegion(region, animated: true)
        
    }
}

extension MapViewController: mapMainViewDelegate {
    func filterImageViewTapped() {
        filterTapped()

    }
    
    func locationImageViewTapped() {
        centerViewOnUserLocation()
        print("aaaaaaaaa")
    }
    
    
}
