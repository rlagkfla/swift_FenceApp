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
    
    var filterModel = FilterModel(distance: 20, startDate: Calendar.current.date(byAdding: .day, value: -1, to: Date())!, endDate: Calendar.current.date(byAdding: .day, value: 0, to: Date())!)
    
    var lostResponseDTOs: [LostResponseDTO] = []
    var foundResponseDTOs: [FoundResponseDTO] = []
    var pinTogether: [Pinable] = []
    
    let firebaseLostService: FirebaseLostService
    let firebaseFoundService: FirebaseFoundService
    let locationManager: LocationManager
    var lostPins: [MapPin] = []
    var foundPins: [MapPin] = []
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
    
        setNavigationTitle()
        centerViewOnUserLocation()
        
        Task {
            do {
                lostResponseDTOs = try await firebaseLostService.fetchLosts(filterModel: filterModel)
//                foundResponseDTOs = try await firebaseFoundService.fetchFounds()
                //                foundResponseDTOs = try await firebaseFoundService.fetchFounds(within: 10)
//                                pinTogether = lostResponseDTOs + foundResponseDTOs
//                pinTogether = lostResponseDTOs
                setPinUsingMKAnnotation(pinables: lostResponseDTOs)
            } catch {
                print(error)
            }
        }
    }
    
    init(firebaseLostService: FirebaseLostService, firebaseFoundService: FirebaseFoundService, locationManager: LocationManager) {
        
        self.firebaseLostService = firebaseLostService
        self.firebaseFoundService = firebaseFoundService
        self.locationManager = locationManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Actions
    
    //MARK: - Helpers
    
    //MARK: - UI
    
    private func setPinUsingMKAnnotation(pinables: [Pinable]) {
        lostPins = pinables.map({ pinable in
            MapPin(pinable: pinable)
        })
        
        mainView.mapView.addAnnotations(lostPins)
       
    }
    
    private func centerViewOnUserLocation() {
        
        guard let location = locationManager.fetchLocation() else { return }
        
        let region = MKCoordinateRegion(center: location, latitudinalMeters: 2500, longitudinalMeters: 2500)
        
        mainView.mapView.setRegion(region, animated: true)
        
    }
    
    private func setNavigationTitle() {
        self.navigationItem.title = "거리 - 반경 5km 내 / 시간 - 3시간 이내"
    }
}

extension MapViewController: MapMainViewDelegate {
    func segmentTapped(onIndex: Int) {
        
        print("Working")
        
        Task {
            do {
                if onIndex == 0 {
                    
                    lostResponseDTOs = try await firebaseLostService.fetchLosts(filterModel: filterModel)
                    mainView.mapView.removeAnnotations(lostPins)
                    setPinUsingMKAnnotation(pinables: lostResponseDTOs)
                    
                } else {
                    
                    foundResponseDTOs = try await firebaseFoundService.fetchFounds(filterModel: filterModel)
                    mainView.mapView.removeAnnotations(lostPins)
                    setPinUsingMKAnnotation(pinables: foundResponseDTOs)
                }
                
            } catch {
                print(error)
            }
           
            
        }
    }
    
    func petImageTappedOnMap(annotation: MKAnnotation) {
        
        if let pinable = (annotation as? MapPin)?.pinable {
            print(pinable.imageURL, pinable.latitude, pinable.longitude)
            
        }
        
        print(annotation.coordinate.longitude)
    }
    
    func filterImageViewTapped() {
        filterTapped?(filterModel)
    }
    
    func locationImageViewTapped() {
        centerViewOnUserLocation()
    }
}

extension MapViewController: CustomFilterModalViewControllerDelegate {
    func applyTapped(filterModel: FilterModel) {
        
        self.filterModel = filterModel
        
        Task {
            let a = try await firebaseLostService.fetchLosts(filterModel: filterModel)
            mainView.mapView.removeAnnotations(lostPins)
            lostPins = a.map { MapPin(pinable: $0)}
            mainView.mapView.addAnnotations(lostPins)
        }
        
        
    }
}
