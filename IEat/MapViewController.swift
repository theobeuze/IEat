//
//  MapViewController.swift
//  IEat
//
//  Created by Poseidon on 30/01/2018.
//  Copyright © 2018 Theo Beuze. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MapDelegate, CLLocationManagerDelegate {
    
    @IBOutlet var map: MKMapView?
    
    let locationManager = CLLocationManager()
    
    let source = MapRetriever()
    var flagRegion = Int(0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        source.delegate = self
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        //self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func didFetch(shops: [Shop]) {
        map?.addAnnotations(shops as [MKAnnotation])
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let point = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "mapPoint")
        point.canShowCallout = true
        return point
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let locValue:CLLocationCoordinate2D = manager.location?.coordinate {
            print("locations = \(locValue.latitude) \(locValue.longitude)")
            let region = MKCoordinateRegion(center: locValue, span: MKCoordinateSpan(latitudeDelta: 0.04, longitudeDelta: 0.04))
            if flagRegion == 0 {
                map?.setRegion(region, animated: true)
                source.getShop(latitude: locValue.latitude, longitude: locValue.longitude)
            }
            flagRegion = flagRegion + 1;
            self.map?.showsUserLocation = true;
        }
    }
}
