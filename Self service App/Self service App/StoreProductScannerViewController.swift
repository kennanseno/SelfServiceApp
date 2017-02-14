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
                    print("Barcode found: type=" + barcode.type + " value=" + barcode.stringValue)
                    
                    let alertController = UIAlertController(title: "Add to cart?", message: nil, preferredStyle: UIAlertControllerStyle.alert)
                    let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.destructive) { (result : UIAlertAction) -> Void in
                        print("Cancel")
                        self.dispatched = false
                    }
                    let okAction = UIAlertAction(title: "Add", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                        self.dispatched = false
                        
                        let params = [
                            "params": [ "username": self.userName],
                            "data": [
                                "product_id": barcode.stringValue,
                                "store_name": self.store.getName(),
                                "store_owner": self.store.getOwner()
                            ]
                            ] as [String : Any]
                        
                        Alamofire.request("http://kennanseno.com:3000/fyp/addToCart", method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { response in
                            switch response.result {
                            case .success(let value):
                                let result = JSON(value)
                                let successMessage = Message(title: "Product successfully added!", textColor: .black, backgroundColor: UIColor(white: 1, alpha: 0.5), images: nil)
                                Whisper.show(whisper: successMessage, to: self.navigationController!, action: .show)
                                
                            case .failure(let error):
                                let errorMessage = Message(title: "Error! Product not added.", textColor: .red, backgroundColor: UIColor(white: 1, alpha: 0.5), images: nil)
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
