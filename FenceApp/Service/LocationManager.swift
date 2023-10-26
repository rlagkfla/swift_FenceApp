//
//  LocationManager.swift
//  FenceApp
//
//  Created by Woojun Lee on 10/24/23.
//

import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        return manager
    }()
    
    override init() {
        super.init()
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func fetchLocation() -> CLLocationCoordinate2D? {
        locationManager.location?.coordinate
    }
}
