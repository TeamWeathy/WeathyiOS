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

    override init() {
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 1500.0 // 해당 거리 이상 위치 변화가 생겼을 때 알림을 받음
        super.init()
        locationManager.delegate = self
    }

    // FIXME: - info.plist에 Desc 문구 변경
    func startUpdateLocation() {
        locationManager.requestLocation()

        let authorization = CLLocationManager.authorizationStatus()
        if authorization != .authorizedAlways || authorization != .authorizedWhenInUse {
//            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        }

        locationManager.startUpdatingLocation()
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
            break
        case .restricted, .notDetermined:
            print(CLLocationManager.authorizationStatus())
            locationManager.requestWhenInUseAuthorization()
        case .denied: break
//            UIApplication.shared.open(NSURL(string: UIApplication.openSettingsURLString)! as URL, completionHandler: nil)
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
