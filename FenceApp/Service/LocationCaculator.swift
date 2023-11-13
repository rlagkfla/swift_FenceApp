//
//  LocationCaculator.swift
//  FenceApp
//
//  Created by Woojun Lee on 10/26/23.
//

import Foundation

struct LocationCalculator {
    
    
    static func filterLocations(originLat: Double, originLon: Double, distance: Double, lostResponseDTOs: [LostResponseDTO]) -> [LostResponseDTO] {
        
        let filteredLocations = lostResponseDTOs.filter { lostResponseDTO in
            let distanceFromOrigin = getDistanceFromOrigin(lat1: originLat, lon1: originLon, lat2: lostResponseDTO.latitude, lon2: lostResponseDTO.longitude)
            return distanceFromOrigin <= distance
        }
        return filteredLocations
    }
    

    static func getDistanceFromOrigin(lat1: Double, lon1: Double, lat2: Double, lon2: Double) -> Double {
        let R = 6371.0  // Radius of the Earth in kilometers

        let lat1Rad = lat1 * .pi / 180.0
        let lon1Rad = lon1 * .pi / 180.0
        let lat2Rad = lat2 * .pi / 180.0
        let lon2Rad = lon2 * .pi / 180.0

        let dLat = lat2Rad - lat1Rad
        let dLon = lon2Rad - lon1Rad

        let a = sin(dLat / 2) * sin(dLat / 2) + sin(dLon / 2) * sin(dLon / 2) * cos(lat1Rad) * cos(lat2Rad)
        let c = 2 * atan2(sqrt(a), sqrt(1 - a))

        let distance = R * c
        return distance
    }
    

//    static func getLocationsOfSqaure(lat: Double, lon: Double, distance: Double) -> (minLat: Double, maxLat: Double, minLon: Double, maxLon: Double) {
  //        let R = 6371.0  // Radius of the Earth in kilometers
  //
  //        // Convert latitude and longitude from degrees to radians
  //        let latRad = lat * .pi / 180.0
  //        let lonRad = lon * .pi / 180.0
  //
  //        let angularDistance = distance / R
  //
  //        // Calculate minimum and maximum latitude
  //        let minLatRad = latRad - angularDistance
  //        let maxLatRad = latRad + angularDistance
  //
  //        // Calculate differences in longitude
  //        let deltaLon = asin(sin(angularDistance) / cos(latRad))
  //
  //        // Calculate minimum and maximum longitude
  //        let minLonRad = lonRad - deltaLon
  //        let maxLonRad = lonRad + deltaLon
  //
  //        // Convert radians back to degrees
  //        let minLat = minLatRad * 180.0 / .pi
  //        let maxLat = maxLatRad * 180.0 / .pi
  //        let minLon = minLonRad * 180.0 / .pi
  //        let maxLon = maxLonRad * 180.0 / .pi
  //
  //        return (minLat, maxLat, minLon, maxLon)
  //    }

    
    //    func calculateMaxMinLatitude(lat: Double, lon: Double, distance: Double) -> (minLat: Double, maxLat: Double) {
    //        let R = 6371.0  // Radius of the Earth in kilometers
    //
    //        // Convert latitude and longitude from degrees to radians
    //        let latRad = lat * .pi / 180.0
    //
    //        // Calculate the angular distance in radians
    //        let angularDistance = distance / R
    //
    //        // Calculate the minimum and maximum latitude
    //        let minLatRad = latRad - angularDistance
    //        let maxLatRad = latRad + angularDistance
    //
    //        // Convert radians back to degrees
    //        let minLat = minLatRad * 180.0 / .pi
    //        let maxLat = maxLatRad * 180.0 / .pi
    //
    //        return (minLat, maxLat)
    //    }
    
//    static func coordinatesWithinDistance(lat: Double, lon: Double, distance: Double) -> [(Double, Double)] {
 //
 //        let R = 6371.0  // Radius of the Earth in kilometers
 //
 //        // Convert latitude and longitude from degrees to radians
 //        let latRad = lat * .pi / 180.0
 //        let lonRad = lon * .pi / 180.0
 //
 //        var coordinates: [(Double, Double)] = []
 //
 //        for theta in stride(from: 0, through: 360, by: 1) {
 //            let thetaRad = Double(theta) * .pi / 180.0
 //            let newLat = asin(sin(latRad) * cos(distance / R) + cos(latRad) * sin(distance / R) * cos(thetaRad))
 //            let newLon = lonRad + atan2(sin(thetaRad) * sin(distance / R) * cos(latRad), cos(distance / R) - sin(latRad) * sin(newLat))
 //
 //            let newLatDeg = newLat * 180.0 / .pi
 //            let newLonDeg = newLon * 180.0 / .pi
 //
 //            coordinates.append((newLatDeg, newLonDeg))
 //        }
 //
 //        return coordinates
 //    }
}









