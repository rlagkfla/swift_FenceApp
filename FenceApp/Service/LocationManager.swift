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
    // sceneDelegate user가 로그인 되어있으면서 위치 공유도 되어있으면 탭바, 아니면 로그인뷰,
    // loginView 들어오면(location manager)   -> location 셋팅 되있나 확인하고 -> 안되있으면 alert창 "무조건 승인해야함" 설정으로 보내? -> 로그인뷰컨트롤러 상태 -> 로그인-> location 세팅되있나 확인하 안되면 alert창 뛰우고 설정으로 보냄 ->
    // location.status == false alert하나 띄어서 너이것안하면 못쓴다 확인누르면 설정으로 보내고,
    
    
    // 저장 누르는 순간 -> 파이어베이스다가 값을 저장해요 -> 데이터베이스에 저장이 된건 확실해요 -> 우리가 임의로 테이블뷰 제일위칸에다가 방금 만든그 고양이 객체를 넣어버리는거지
    
    //  ㅣostResposnedDTo 만들어저장
    // mapper.makelost(lostREsponseDto) ->  Lost
    // save button Tapped(lost)
    // delegate.saveButtonTapped(lost)
    // lostViewController  lostList = lost + lostList
    // tableView upload
    
    
    // lostWithDocument: LostWithDocument?
    /// viewdidload -> lostwith Document 얘가 nil이냐 아니냐?
    ///  nil 일경우 pagination없이 그냥 int 10
    ///
    ///   nil이 아닐경우 lostWithDocument를 체크하거든요
    ///   (pagination: Int, lastDocument)
    ///
    ///delegate = lostWithDocument = nil
    /// get()
    
}
