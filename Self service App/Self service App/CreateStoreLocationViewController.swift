//
//  CreateStoreLocationViewController.swift
//  Self service App
//
//  Created by Kennan Lyle Seno on 09/02/2017.
//  Copyright © 2017 kennanseno. All rights reserved.
//

import UIKit
import MapKit
import Alamofire
import SwiftyJSON

class CreateStoreLocationViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UIGestureRecognizerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    var store = Store()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        mapView.showsUserLocation = false
        //zoom to current user location
        if let location = locationManager.location {
            let span = MKCoordinateSpanMake(0.005, 0.005)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            mapView.setRegion(region, animated: true)
        }

        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action:#selector(handleTap(gestureReconizer:)))
        gestureRecognizer.delegate = self
        mapView.addGestureRecognizer(gestureRecognizer)
    }
    
    func handleTap(gestureReconizer: UILongPressGestureRecognizer) {
        let alertController = UIAlertController(title: "Create Store?", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        
        let location = gestureReconizer.location(in: mapView)
        let coordinate = mapView.convert(location,toCoordinateFrom: mapView)
        
        //remove existing annotations
        let visibleAnnotations = mapView.annotations
        mapView.removeAnnotations(visibleAnnotations)
        
        // Add annotation
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.destructive) { (result : UIAlertAction) -> Void in
            print("Cancel")
        }
        let okAction = UIAlertAction(title: "Create", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            
            let params = [
                "params": [
                    "username": self.store.getOwner() ],
                    "data": [
                    "name" : self.store.getName(),
                    "description": self.store.getDescription(),
                    "address": self.store.getAddress(),
                    "location": [
                        "latitude": annotation.coordinate.latitude,
                        "longitude": annotation.coordinate.longitude
                        ]
                    ]
                ] as [String : Any]
            
            Alamofire.request("http://kennanseno.com:3000/fyp/createStore", method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { response in
                    switch response.result {
                        case .success(let _):
                            //Return to profileVC
                            let profileVC = self.navigationController?.viewControllers[0] as! ProfileViewController
                            self.navigationController?.popToViewController(profileVC, animated: true)
                        case .failure(let error):
                            print(error)
                    }
                }
            

        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print("location:: \(location)")
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error)")
    }
    
}
