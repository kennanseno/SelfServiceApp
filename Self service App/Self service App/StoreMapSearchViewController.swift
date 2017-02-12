//
//  StoreMapSearchViewController.swift
//  Self service App
//
//  Created by Kennan Lyle Seno on 11/02/2017.
//  Copyright © 2017 kennanseno. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MapKit

class StoreMapSearchViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    var storeList = [Store]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        mapView.showsUserLocation = false
        
        let params = [
            "latitude": locationManager.location?.coordinate.latitude as Any,
            "longitude": locationManager.location?.coordinate.longitude as Any,
            "radius": 10.0 //default to 10 km radius for now
            ] as [String : Any]
        
        Alamofire.request("http://kennanseno.com:3000/fyp/searchNearbyStores", parameters: params).responseJSON { response in
            switch response.result {
            case .success(let value):
                let result = JSON(value)
                self.storeList = result.arrayValue.map({
                    Store(name: $0["name"].stringValue, description: $0["description"].stringValue, location: CLLocationCoordinate2D(latitude: $0["location"]["latitude"].doubleValue, longitude: $0["location"]["longitude"].doubleValue))
                })
                
                //zoom to current user location
                if let location = self.locationManager.location {
                    let span = MKCoordinateSpanMake(0.02, 0.02)
                    let region = MKCoordinateRegion(center: location.coordinate, span: span)
                    self.mapView.setRegion(region, animated: true)
                }
                for store in self.storeList {
                    let annotation = MKPointAnnotation()
                    annotation.title = store.getName()
                    annotation.subtitle = store.getDescription()
                    annotation.coordinate = store.getLocation()
                    self.mapView.addAnnotation(annotation)
                }
                
            case .failure(let error):
                print(error)
            }
        }
        

    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation {
            print("title:\(annotation.title) subtitle:\(annotation.subtitle) lat:\(annotation.coordinate.latitude) long:\(annotation.coordinate.longitude)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    
    }

    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}
