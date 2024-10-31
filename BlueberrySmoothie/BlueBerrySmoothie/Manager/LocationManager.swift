//
//  LocationManager.swift
//  MapkitTest
//
//  Created by 문호 on 10/24/24.
//

import SwiftUI
import CoreLocation
import MapKit

class LocationManager: NSObject, ObservableObject {
    let manager = CLLocationManager()
    private var timer: Timer?
    
    @Published var location: CLLocation?
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.9780),
        span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)  // 배율 확대
    )
    @Published var locationStatus: CLAuthorizationStatus?
    @Published var address: String = "위치 찾는 중..."
    @Published var detailedAddress: AddressDetail = AddressDetail()
    @Published var errorMessage: String?
    @Published var lastRefreshTime: Date = Date()
    
    private let targetRegion = CLCircularRegion(
        center: CLLocationCoordinate2D(latitude: 36.013972, longitude: 129.325996),
        radius: 5.0,
        identifier: "POIRegion")
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.allowsBackgroundLocationUpdates = true
        checkIfLocationServicesIsEnabled()
        startAutoRefresh()
    }
    
    deinit {
        stopAutoRefresh()
    }
    
    func startAutoRefresh() {
        timer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { [weak self] _ in
            self?.refreshLocation()
        }
    }
    
    func stopAutoRefresh() {
        timer?.invalidate()
        timer = nil
    }
    
    func refreshLocation() {
        address = "위치 찾는 중…"
        lastRefreshTime = Date()
        manager.startUpdatingLocation()
        print(manager.location ?? "실시간 location")
        
        // 위치가 region 안에 있는지 확인
        if let currentLocation = manager.location {
            if targetRegion.contains(currentLocation.coordinate) {
                print("현재 위치가 지정된 지역 안에 있습니다.")
            } else {
                print("현재 위치가 지정된 지역 밖에 있습니다.")
            }
        }
    }
    
    func checkIfLocationServicesIsEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            manager.delegate = self
            checkLocationAuthorization()
        } else {
            errorMessage = "위치 서비스가 비활성화되어 있습니다. 설정에서 위치 서비스를 켜주세요."
        }
    }
    
    private func checkLocationAuthorization() {
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .restricted:
            errorMessage = "위치 서비스 접근이 제한되어 있습니다."
        case .denied:
            errorMessage = "위치 서비스 권한이 거부되었습니다. 설정에서 권한을 허용해주세요."
        case .authorizedAlways, .authorizedWhenInUse:
            //            manager.startUpdatingLocation()
            manager.requestAlwaysAuthorization()
        @unknown default:
            break
        }
    }
}

// 주소 세부 정보를 저장하는 구조체
struct AddressDetail {
    var country: String = ""
    var administrativeArea: String = ""  // 시/도
    var locality: String = ""            // 시/군/구
    var subLocality: String = ""         // 동/읍/면
    var thoroughfare: String = ""        // 도로명
    var subThoroughfare: String = ""     // 건물번호
    
    var fullAddress: String {
        [country, administrativeArea, locality, subLocality, thoroughfare, subThoroughfare]
            .filter { !$0.isEmpty }
            .joined(separator: " ")
    }
    
    var shortAddress: String {
        [locality, subLocality, thoroughfare, subThoroughfare]
            .filter { !$0.isEmpty }
            .joined(separator: " ")
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        if location.horizontalAccuracy > 0 {
            self.location = location
            self.region = MKCoordinateRegion(
                center: location.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)  // 배율 확대
            )
            self.manager.stopUpdatingLocation()
            
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
                if let error = error {
                    print("Geocoding error: \(error.localizedDescription)")
                    self?.address = "주소를 찾을 수 없습니다."
                    return
                }
                
                if let placemark = placemarks?.first {
                    DispatchQueue.main.async {
                        var newAddress = AddressDetail()
                        newAddress.country = placemark.country ?? ""
                        newAddress.administrativeArea = placemark.administrativeArea ?? ""
                        newAddress.locality = placemark.locality ?? ""
                        newAddress.subLocality = placemark.subLocality ?? ""
                        newAddress.thoroughfare = placemark.thoroughfare ?? ""
                        newAddress.subThoroughfare = placemark.subThoroughfare ?? ""
                        
                        self?.detailedAddress = newAddress
                        self?.address = newAddress.fullAddress
                    }
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error.localizedDescription)")
        errorMessage = "위치를 찾을 수 없습니다: \(error.localizedDescription)"
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        locationStatus = status
        checkLocationAuthorization()
    }
}

