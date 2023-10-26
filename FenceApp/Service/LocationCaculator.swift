//
//  LocationCaculator.swift
//  FenceApp
//
//  Created by Woojun Lee on 10/26/23.
//

import Foundation

func getLocationsOfSqaure(lat: Double, lon: Double, distance: Double) -> (minLat: Double, maxLat: Double, minLon: Double, maxLon: Double) {
    let R = 6371.0  // Radius of the Earth in kilometers

    // Convert latitude and longitude from degrees to radians
    let latRad = lat * .pi / 180.0
    let lonRad = lon * .pi / 180.0

    let angularDistance = distance / R

    // Calculate minimum and maximum latitude
    let minLatRad = latRad - angularDistance
    let maxLatRad = latRad + angularDistance

    // Calculate differences in longitude
    let deltaLon = asin(sin(angularDistance) / cos(latRad))

    // Calculate minimum and maximum longitude
    let minLonRad = lonRad - deltaLon
    let maxLonRad = lonRad + deltaLon

    // Convert radians back to degrees
    let minLat = minLatRad * 180.0 / .pi
    let maxLat = maxLatRad * 180.0 / .pi
    let minLon = minLonRad * 180.0 / .pi
    let maxLon = maxLonRad * 180.0 / .pi

    return (minLat, maxLat, minLon, maxLon)
}

func coordinatesWithinDistance(lat: Double, lon: Double, distance: Double) -> [(Double, Double)] {
    let R = 6371.0  // Radius of the Earth in kilometers

    // Convert latitude and longitude from degrees to radians
    let latRad = lat * .pi / 180.0
    let lonRad = lon * .pi / 180.0

    var coordinates: [(Double, Double)] = []

    for theta in stride(from: 0, through: 360, by: 1) {
        let thetaRad = Double(theta) * .pi / 180.0
        let newLat = asin(sin(latRad) * cos(distance / R) + cos(latRad) * sin(distance / R) * cos(thetaRad))
        let newLon = lonRad + atan2(sin(thetaRad) * sin(distance / R) * cos(latRad), cos(distance / R) - sin(latRad) * sin(newLat))
        
        let newLatDeg = newLat * 180.0 / .pi
        let newLonDeg = newLon * 180.0 / .pi

        coordinates.append((newLatDeg, newLonDeg))
    }

    return coordinates
}

// Example usage




