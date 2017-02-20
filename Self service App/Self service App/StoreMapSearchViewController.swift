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
import Dollar
import RSBarcodes_Swift

class StoreMapSearchViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    var storeList = [Store]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
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
                    Store(name: $0["name"].stringValue, description: $0["description"].stringValue, location: CLLocationCoordinate2D(latitude: $0["location"]["latitude"].doubleValue, longitude: $0["location"]["longitude"].doubleValue), owner: $0["owner"].stringValue)
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
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true
            
            let infoButton: AnyObject! = UIButton.init(type: UIButtonType.contactAdd)
            pinView!.rightCalloutAccessoryView = infoButton as! UIView
        } else {
            pinView?.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let storeProductScannerVC = storyboard?.instantiateViewController(withIdentifier: "storeProductScannerVC") as! StoreProductScannerViewController
            let annotation = view.annotation
            //Find a better way to search for store chosen
            self.storeList.forEach({ (Store) in
                if(Store.getName() == (annotation?.title)! && Store.getDescription() == (annotation?.subtitle)!) {
                    storeProductScannerVC.store = Store
                }
            })
            self.navigationController?.pushViewController(storeProductScannerVC, animated: true)
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
