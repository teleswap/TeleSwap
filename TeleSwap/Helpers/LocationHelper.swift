//
//  LocationHelper.swift
//  TeleSwap
//
//  Created by Moin Uddin on 5/20/19.
//  Copyright © 2019 Cameron Dunn. All rights reserved.
//

import Foundation
import CoreLocation
class LocationHelper: NSObject, CLLocationManagerDelegate {
    
    
    let locationManager = CLLocationManager()
    
    func getCurrentLocation() -> CLLocation? {
        return locationManager.location
    }
    
    func setPlace(completion: @escaping (String?, String?, String?, Error?) -> Void) {
        let geoCoder = CLGeocoder()
        guard let long = locationManager.location?.coordinate.longitude,
            let lat = locationManager.location?.coordinate.latitude else {
                NSLog("Couldn't get current location longitude and latitude to set place")
                return
        }
        let location = CLLocation(latitude: lat, longitude: long)
        geoCoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                NSLog("Error retreiving place from reverse GeoCode: \(error)")
                completion(nil, nil, nil, error)
            }
            guard let placeMark = placemarks!.first else { return }
            let city = "\(ReversedGeoLocation(with: placeMark).city)"
            let state = "\(ReversedGeoLocation(with: placeMark).state)"
            let zipCode = "\(ReversedGeoLocation(with: placeMark).zipCode)"
            
            completion(city, state, zipCode, nil)
        }
    }
    
    
    func saveLocation() {
        let longitude = locationManager.location?.coordinate.longitude
        let latitude = locationManager.location?.coordinate.latitude
        
        setPlace { (city, state, zipCode, error) in
            UserDefaults.standard.set(longitude, forKey: UserDefaultsKeys.longitude.rawValue)
            UserDefaults.standard.set(latitude, forKey: UserDefaultsKeys.latitude.rawValue)
            UserDefaults.standard.set(city, forKey: UserDefaultsKeys.city.rawValue)
            UserDefaults.standard.set(state, forKey: UserDefaultsKeys.state.rawValue)
            UserDefaults.standard.set(zipCode, forKey: UserDefaultsKeys.zipCode.rawValue)
        }
        
    }
    
    
}
