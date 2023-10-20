//
//  MapPin.swift
//  FenceApp
//
//  Created by Woojun Lee on 10/20/23.
//

import MapKit

class MapPin: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    let lostDTO: LostResponseDTO
    
    init(lostDTO: LostResponseDTO) {
        self.lostDTO = lostDTO
        self.coordinate = CLLocationCoordinate2D(latitude: lostDTO.latitude, longitude: lostDTO.longitude)
    }
}
