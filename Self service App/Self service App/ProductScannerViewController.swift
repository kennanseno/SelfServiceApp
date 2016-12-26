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

class ProductScannerViewController: RSCodeReaderViewController {

    
    var dispatched: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.focusMarkLayer.strokeColor = UIColor.red.cgColor
        
        self.cornersLayer.strokeColor = UIColor.yellow.cgColor
        
        self.tapHandler = { point in
            print(point)
        }
        
        self.barcodesHandler = { barcodes in
            if !self.dispatched { // triggers for only once
                self.dispatched = true
                for barcode in barcodes {
                    print("Barcode found: type=" + barcode.type + " value=" + barcode.stringValue)
                    
                    let alertController = UIAlertController(title: "Add Product?", message: nil, preferredStyle: UIAlertControllerStyle.alert)
                    let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.destructive) { (result : UIAlertAction) -> Void in
                        print("Cancel")
                        self.dispatched = false
                    }
                    let okAction = UIAlertAction(title: "Add", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                        print("Add")
                         self.performSegue(withIdentifier: "productCreateVC", sender: nil)
                        self.dispatched = false
                    }
                    alertController.addAction(cancelAction)
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                    
                    
                    break
                }
            }
        }
        
        
    }
    

}
