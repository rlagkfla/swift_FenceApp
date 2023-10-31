//
//  MapViewController.swift
//  FenceApp
//
//  Created by JeonSangHyeok on 10/16/23.
//


import MapKit
import SnapKit

class MapViewController: UIViewController {
    
    //MARK: - Properties
    
    var lostResponseDTOs: [LostResponseDTO] = []
    var foundResponseDTOs: [FoundResponseDTO] = []
    var pinTogether: [Pinable] = []
    let firebaseLostService: FirebaseLostService
    let firebaseFoundService: FirebaseFoundService
    var pins: [MapPin] = []
    var filterTapped: (() -> Void)?
    
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
    
        setNavigationTitle()
        centerViewOnUserLocation()
        
        Task {
            do {
                lostResponseDTOs = try await firebaseLostService.fetchLosts()
                foundResponseDTOs = try await firebaseFoundService.fetchFounds()
                //                foundResponseDTOs = try await firebaseFoundService.fetchFounds(within: 10)
                                pinTogether = lostResponseDTOs + foundResponseDTOs
//                pinTogether = lostResponseDTOs
                setPinUsingMKAnnotation(pinables: pinTogether)
            } catch {
                print(error)
            }
        }
    }
    
    init(firebaseLostService: FirebaseLostService, firebaseFoundService: FirebaseFoundService, locationManager: LocationManager) {
        
        self.firebaseLostService = firebaseLostService
        self.firebaseFoundService = firebaseFoundService
        self.locationManager = locationManager
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
        pins = pinables.map({ pinable in
            MapPin(pinable: pinable)
        })
        
        mainView.mapView.addAnnotations(pins)
       
    }
    
    private func centerViewOnUserLocation() {
        
        guard let location = locationManager.fetchLocation() else { return }
        
        let region = MKCoordinateRegion(center: location, latitudinalMeters: 2500, longitudinalMeters: 2500)
        
        mainView.mapView.setRegion(region, animated: true)
        
    }
    
    private func setNavigationTitle() {
        self.navigationItem.title = "게시판"
    }
}

extension MapViewController: mapMainViewDelegate {
    func filterImageViewTapped() {
        filterTapped?()
    }
    
    func locationImageViewTapped() {
        centerViewOnUserLocation()
    }
}

extension MapViewController: CustomFilterModalViewControllerDelegate {
    func applyTapped(within: Double, fromDate: Date, toDate: Date) {
        
        Task {
            
            print(within, fromDate, toDate, "@@@@@@@@@")
            let a = try await firebaseLostService.fetchLosts(within: within, fromDate: fromDate, toDate: toDate)
            print(a.count, "!!!!!!")
            //
            //            var pins = pinTogether.map { MapPin(pinable: $0)}
            mainView.mapView.removeAnnotations(pins)
            pins = a.map { MapPin(pinable: $0)}
            mainView.mapView.addAnnotations(pins)
        }
    }
}
