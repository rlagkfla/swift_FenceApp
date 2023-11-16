//
//  LocationManager.swift
//  FenceApp
//
//  Created by Woojun Lee on 10/24/23.
//

import CoreLocation
import UIKit

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
    }
    
    func fetchLocation() -> CLLocationCoordinate2D? {
        locationManager.requestLocation()
        
        return locationManager.location?.coordinate
        
    }
    
    func fetchStatus() -> Bool {
        let authorization = locationManager.authorizationStatus
        switch authorization {
            
        case .authorizedAlways, .authorizedWhenInUse:
            return true
        default:
            return false
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            //location5
            switch status {
            case .authorizedAlways, .authorizedWhenInUse:
                locationManager.requestLocation()
                
            case .restricted, .notDetermined:
                print("GPS 권한 설정되지 않음")
                
            case .denied:
                AlertHandler.shared.presentErrorAlertWithAction(for: .permissionError("위치 서비스 권한이 필요합니다. 설정으로 이동하여 권한을 허용해 주세요.")) { _ in
                    SettingHandler.moveToSetting()
                    return
                }

            default:
                print("GPS: Default")
            }
        }
}
