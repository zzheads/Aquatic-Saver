//
//  MapViewController.swift
//  Aquatic Saver
//
//  Created by Алексей Папин on 04.09.2018.
//  Copyright © 2018 Алексей Папин. All rights reserved.
//

import UIKit
import GoogleMaps
import MapKit

class MapViewController: UIElements.ViewController {
    var device  : Device?
    var map     : GMSMapView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let longitude   : Double = -33.86
        let latitude    : Double = 151.20

        let camera = GMSCameraPosition.camera(withLatitude: longitude, longitude: latitude, zoom: 6.0)
        self.map = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        self.map?.animate(toZoom: 1.0)
        self.view = self.map
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: longitude, longitude: latitude)
        marker.map = self.map
        
        APIClient.default.lastPosition()
            .done { positions in
                if let position = positions.last, let lat = position.latitude, let lon = position.longitude {
                    marker.position = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                    marker.title = position.onMapDescription
                }
                
            }
            .catch { self.showAlert(title: "Getting position error", message: $0.localizedDescription, style: .alert) }
        
    }
}
