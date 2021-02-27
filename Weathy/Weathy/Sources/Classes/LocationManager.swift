//
//  LocationManager.swift
//  Weathy
//
//  Created by inae Lee on 2021/02/17.
//

import CoreLocation
import Foundation

class LocationManager: NSObject {
    static let shared = LocationManager()

    private let locationManager: CLLocationManager
    private let opertationQueue = OperationQueue()

    override init() {
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 3000 // 해당 거리 이상 위치 변화가 생겼을 때 알림을 받음
        super.init()
        locationManager.delegate = self

        opertationQueue.isSuspended = true
    }

    func startUpdateLocation() {
        locationManager.startUpdatingLocation()
    }

    func requestLocationAuth(completion: @escaping () -> Void) {
        let auth = CLLocationManager.authorizationStatus()

        if auth == .authorizedAlways || auth == .authorizedWhenInUse {
            opertationQueue.isSuspended = false
        } else {
            locationManager.requestWhenInUseAuthorization()
        }

        opertationQueue.addOperation {
            OperationQueue.main.addOperation {
                completion()
            }
        }
    }

    func stopUpdateLocation() {
        locationManager.stopUpdatingLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("did change auth")

        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            opertationQueue.isSuspended = false
            UserDefaults.standard.set(true, forKey: "locationAuth")

            locationManager.startUpdatingLocation()
            locationManager.requestLocation()
        case .restricted, .denied:
            opertationQueue.isSuspended = false
            UserDefaults.standard.set(false, forKey: "locationAuth")
        case .notDetermined: break
        default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("did update location")

        let location: CLLocation = locations[locations.count - 1]
        let longitude: CLLocationDegrees = location.coordinate.longitude
        let latitude: CLLocationDegrees = location.coordinate.latitude

        print(longitude)
        print(latitude)

        UserDefaults.standard.set(longitude, forKey: "locationLon")
        UserDefaults.standard.set(latitude, forKey: "locationLat")
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error", error)
        locationManager.stopUpdatingLocation()
    }
}
