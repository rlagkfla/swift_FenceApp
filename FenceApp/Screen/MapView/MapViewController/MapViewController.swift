//
//  MapViewController.swift
//  FenceApp
//
//  Created by JeonSangHyeok on 10/16/23.
//


import MapKit
import SnapKit

class MapViewController: UIViewController {
    
    //MARK: - Services
    
    let firebaseLostService: FirebaseLostService
    let firebaseFoundService: FirebaseFoundService
    let locationManager: LocationManager
    
    //MARK: - Properties
    
    var filterModel = FilterModel(distance: 20, startDate: Calendar.yesterday, endDate: Calendar.today)
    
    var losts: [Lost] = []
    var founds: [Found] = []
    var pins: [MapPin] = []
    
    var annotationViewTapped: ( (Pinable) -> Void )?
    
    var filterTapped: ( (FilterModel) -> Void )?
    
    lazy var mainView: MapMainView = {
        let view = MapMainView()
        view.delegate = self
        return view
    }()
    
    
    //MARK: - Lifecycle
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        Task {
            do {
                
                setNavigationTitle()
                centerViewOnUserLocation()
                
                try await performAPIAndSetPins(segmentIndex: mainView.segmentedControl.selectedSegmentIndex)
                
            } catch {
                print(error)
            }
        }
        
    }
    
    //MARK: - Actions
    
    //MARK: - Helpers
    
    private func setPinUsingMKAnnotation(pinables: [Pinable]) {
        
        pins = pinables.map { MapPin(pinable: $0) }
        
        mainView.mapView.addAnnotations(pins)
    }
    
    private func centerViewOnUserLocation() {
        
        guard let location = locationManager.fetchLocation() else { return }
        
        let region = MKCoordinateRegion(center: location, latitudinalMeters: 2500, longitudinalMeters: 2500)
        
        mainView.mapView.setRegion(region, animated: true)
        
    }
    
    private func setNavigationTitle() {
        self.navigationItem.title = "거리 - 반경 5km 내 / 시간 - 3시간 이내"
    }
    
    
    
    private func getLosts() async throws {
        
        let lostResponseDTOs = try await firebaseLostService.fetchLosts(filterModel: filterModel)
        
        losts = LostResponseDTOMapper.makeLosts(from: lostResponseDTOs)
        
    }
    
    private func getFounds() async throws {
        
        let foundResponseDTOs = try await firebaseFoundService.fetchFounds(filterModel: filterModel)
        
        founds = FoundResponseDTOMapper.makeFounds(from: foundResponseDTOs)
        
        
    }
    
    private func clearPins() {
        mainView.mapView.removeAnnotations(pins)
        
    }
    
    private func performAPIAndSetPins(segmentIndex: Int) async throws {
        
        if segmentIndex == 0 {
            
            try await getLosts()
            clearPins()
            setPinUsingMKAnnotation(pinables: losts)
            
        } else {
            
            try await getFounds()
            clearPins()
            setPinUsingMKAnnotation(pinables: founds)
        }
    }
    
    
    //MARK: - Init
    
    init(firebaseLostService: FirebaseLostService, firebaseFoundService: FirebaseFoundService, locationManager: LocationManager) {
        
        self.firebaseLostService = firebaseLostService
        self.firebaseFoundService = firebaseFoundService
        self.locationManager = locationManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - MapMainView Delegate

extension MapViewController: MapMainViewDelegate {
    
    func segmentTapped(onIndex: Int) {
        
        Task {
            do {
                
                try await performAPIAndSetPins(segmentIndex: onIndex)
                
                
            } catch {
                print(error)
            }
        }
    }
    
    func petImageTappedOnMap(annotation: MKAnnotation) {
        
        if let pinable = (annotation as? MapPin)?.pinable {
            
            annotationViewTapped?(pinable)
            print(pinable.imageURL, pinable.latitude, pinable.longitude)
            
        }
        
        
    }
    
    func filterImageViewTapped() {
        filterTapped?(filterModel)
    }
    
    func locationImageViewTapped() {
        centerViewOnUserLocation()
    }
}

//MARK: - FilterModalViewController Delegate

extension MapViewController: CustomFilterModalViewControllerDelegate {
    func applyTapped(filterModel: FilterModel) {
        
        self.filterModel = filterModel
        
        Task {
            
            do {
                let segmentIndex = mainView.segmentedControl.selectedSegmentIndex
                
                try await performAPIAndSetPins(segmentIndex: segmentIndex)
                
            } catch {
                print(error)
            }
        }
        
    }
}
