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
    
    var map     : GMSMapView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        self.map = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        self.map?.animate(toZoom: 1.0)
        self.view = self.map
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = self.map
    }
}
