//
//  ProductScannerViewController.swift
//  Self service App
//
//  Created by Kennan Lyle Seno on 24/12/2016.
//  Copyright © 2016 kennanseno. All rights reserved.
//

import UIKit
import Cartography
import RSBarcodes_Swift
import Alamofire
import SwiftyJSON
import CoreData
import Whisper


class StoreProductScannerViewController: RSCodeReaderViewController {
    
    @IBOutlet weak var scanInstruction: UILabel!
    var dispatched: Bool = false
    var store = Store()
    var userName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title  = store.getName()
        self.setViews()
        self.addConstraints()
        
        self.focusMarkLayer.strokeColor = UIColor.red.cgColor
        self.cornersLayer.strokeColor = UIColor.yellow.cgColor
        self.tapHandler = { point in
            print(point)
        }
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserEntity")
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try managedContext.fetch(request)
            
            if results.count > 0 {
                for result in results as! [NSManagedObject]{
                    if let username = result.value(forKey: "username") as? String {
                        userName = username
                    }
                }
            }
        }
        catch {
            print("Error")
        }
        
        self.barcodesHandler = { barcodes in
            if !self.dispatched { // triggers for only once
                self.dispatched = true
                for barcode in barcodes {
                    
                    let alertController = UIAlertController(title: "Add to cart?", message: nil, preferredStyle: UIAlertControllerStyle.alert)
                    let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.destructive) { (result : UIAlertAction) -> Void in
                        print("Cancel")
                        self.dispatched = false
                    }
                    let okAction = UIAlertAction(title: "Add", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                        self.dispatched = false
                        
                        var params = [
                                "product_id": barcode.stringValue,
                                "store_name": self.store.getName(),
                                "store_owner": self.store.getOwner()
                            ] as [String : Any]
                        
                        Alamofire.request("http://kennanseno.com:3000/fyp/productExists", parameters: params).responseJSON { response in
                            switch response.result {
                            case .success(let value):
                                if value as! Bool {
                                    params = [
                                        "params": [ "username": self.userName],
                                        "data": [
                                            "product_id": barcode.stringValue,
                                            "store_name": self.store.getName(),
                                            "store_owner": self.store.getOwner()
                                        ]
                                        ] as [String : Any]
                                    
                                    Alamofire.request("http://kennanseno.com:3000/fyp/addToCart", method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { response in
                                        switch response.result {
                                        case .success( _):
                                            let successMessage = Message(title: "Product successfully added!", textColor: .green, backgroundColor: UIColor(white: 1, alpha: 0), images: nil)
                                            Whisper.show(whisper: successMessage, to: self.navigationController!, action: .show)
                                            
                                        case .failure(let error):
                                            let errorMessage = Message(title: "Error! Product not added.", textColor: .red, backgroundColor: UIColor(white: 1, alpha: 0), images: nil)
                                            Whisper.show(whisper: errorMessage, to: self.navigationController!, action: .show)
                                            print(error)
                                        }
                                    }

                                } else {
                                    let successMessage = Message(title: "Product does not exist!", textColor: .red, backgroundColor: UIColor(white: 1, alpha: 0), images: nil)
                                    Whisper.show(whisper: successMessage, to: self.navigationController!, action: .show)
                                }
   
                            case .failure(let error):
                                let errorMessage = Message(title: "Error! Product not added.", textColor: .red, backgroundColor: UIColor(white: 1, alpha: 0), images: nil)
                                Whisper.show(whisper: errorMessage, to: self.navigationController!, action: .show)
                                print(error)
                            }
                        }
                        
                    }
                    alertController.addAction(cancelAction)
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                    
                    break
                }
            }
        }
        
        
    }
    
    private func productExists(barcode: String, store: Store) -> Bool {
        //TODO: Check if product exists in
        return true
    }
    
    @IBAction func toCart(_ sender: Any) {
        let cartVC = storyboard?.instantiateViewController(withIdentifier: "cartVC") as! CartViewController
        cartVC.username = self.userName
        self.navigationController?.pushViewController(cartVC, animated: true)
    }
    
    private func setViews() {
        scanInstruction.textColor = UIColor.yellow
        self.view.addSubview(scanInstruction)
    }
    
    private func addConstraints() {
        constrain(self.view, scanInstruction) { superView, scanInstruction in
            
            scanInstruction.centerX == superView.centerX
            scanInstruction.centerY == superView.centerY - 175
        }
    }
    
    
}
