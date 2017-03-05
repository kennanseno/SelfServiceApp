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
import Whisper

class ProductScannerViewController: RSCodeReaderViewController {

    @IBOutlet weak var scanInstruction: UILabel!
    var dispatched: Bool = false
    var store = Store()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setViews()
        self.addConstraints()
        
        self.focusMarkLayer.strokeColor = UIColor.red.cgColor
        
        self.cornersLayer.strokeColor = UIColor.yellow.cgColor
        
        self.tapHandler = { point in
            print(point)
        }
        
        self.barcodesHandler = { barcodes in
            if !self.dispatched { // triggers for only once
                self.dispatched = true
                for barcode in barcodes {
                    
                    let alertController = UIAlertController(title: "Add Product?", message: nil, preferredStyle: UIAlertControllerStyle.alert)
                    let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.destructive) { (result : UIAlertAction) -> Void in
                        print("Cancel")
                        self.dispatched = false
                    }
                    let okAction = UIAlertAction(title: "Add", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                        
                        let params = [
                                "store_id" : self.store.getId(),
                                "product_id": barcode.stringValue
                            ] as [String : Any]
                        
                        Alamofire.request("http://kennanseno.com:3000/fyp/productExists", parameters: params).responseJSON { response in
                            switch response.result {
                            case .success(let value):
                                if value as! Bool {
                                    let errorMessage = Message(title: "Product already in list!", textColor: .red, backgroundColor: UIColor(white: 1, alpha: 0), images: nil)
                                    Whisper.show(whisper: errorMessage, to: self.navigationController!, action: .show)
                                } else {
                                    let productCreateVC = self.storyboard?.instantiateViewController(withIdentifier: "productCreateVC") as! ProductCreateViewController
                                    productCreateVC.store = self.store
                                    productCreateVC.productCode = barcode.stringValue
                                    self.navigationController?.pushViewController(productCreateVC, animated: true)
                                }

                            case .failure(let error):
                                print(error)
                            }
                        }
                        

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
