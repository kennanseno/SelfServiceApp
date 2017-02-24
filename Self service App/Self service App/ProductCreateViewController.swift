//
//  ProductCreateViewController.swift
//  Self service App
//
//  Created by Kennan Lyle Seno on 24/12/2016.
//  Copyright © 2016 kennanseno. All rights reserved.
//

import UIKit
import Cartography
import SkyFloatingLabelTextField
import CoreData
import Alamofire
import SwiftyJSON
import Whisper

class ProductCreateViewController: UIViewController {

    let lightGreyColor = UIColor(red: 197/255, green: 205/255, blue: 205/255, alpha: 1.0)
    let darkGreyColor = UIColor(red: 52/255, green: 42/255, blue: 61/255, alpha: 1.0)
    let overcastBlueColor = UIColor(red: 0, green: 187/255, blue: 204/255, alpha: 1.0)
    var store = Store()
    var productCode = ""
    
    
    @IBOutlet weak var addProductButton: UIBarButtonItem!
    @IBOutlet weak var productName: SkyFloatingLabelTextField!
    @IBOutlet weak var productDesc: SkyFloatingLabelTextField!
    @IBOutlet weak var productPrice: SkyFloatingLabelTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setViews()
        self.addConstraints()
        self.dismissKeyboard()
    }

    @IBAction func addProductButtonPressed(_ sender: Any) {
        //validation
        for textfield in [productName, productDesc, productPrice] {
            if((textfield?.text?.isEmpty)!) {
                let errorMessage = Message(title: "All fields must be filled!", textColor: .orange, backgroundColor: UIColor(white: 1, alpha: 1), images: nil)
                Whisper.show(whisper: errorMessage, to: self.navigationController!, action: .show)
                return
            }
        }
        var username = ""
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserEntity")
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try managedContext.fetch(request)
            
            if results.count > 0 {
                for result in results as! [NSManagedObject]{
                    if let userName = result.value(forKey: "username") as? String {
                        username = userName
                    }
                }
            }
        }
        catch {
            print("Error")
        }
        
        //send product data to server
        let product = Product(productCode: self.productCode, name: productName.text!, description: productDesc.text!, price: Int(productPrice.text!)!)
        let params = [
                "store_id": self.store.getId(),
                "data": [
                    "code": product.getProductCode(),
                    "name": product.getName(),
                    "description": product.getDescription(),
                    "price": product.getPrice()
                ]
            ] as [String : Any]
        
        Alamofire.request("http://kennanseno.com:3000/fyp/addProduct", method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { response in
            switch response.result {
            case .success(let value):
                let result = JSON(value)
                
            case .failure(let error):
                print(error)
            }
        }
        
        //get viewcontroller in the nav vc stack
        let manageStoreVC = self.navigationController?.viewControllers[1] as! ManageStoreViewController
        self.navigationController?.popToViewController(manageStoreVC, animated: true)
    }
    
    private func setViews() {
        productName.title = "Product Name"
        productName.placeholder = "Product Name"
        productName.tintColor = overcastBlueColor
        productName.textColor = darkGreyColor
        productName.lineColor = lightGreyColor
        productName.selectedTitleColor = overcastBlueColor
        productName.selectedLineColor = overcastBlueColor
        productName.lineHeight = 1.0
        productName.selectedLineHeight = 2.0
        self.view.addSubview(productName)
        
        productDesc.title = "Product Description"
        productDesc.placeholder = "Product Description"
        productDesc.tintColor = overcastBlueColor
        productDesc.textColor = darkGreyColor
        productDesc.lineColor = lightGreyColor
        productDesc.selectedTitleColor = overcastBlueColor
        productDesc.selectedLineColor = overcastBlueColor
        productDesc.lineHeight = 1.0
        productDesc.selectedLineHeight = 2.0
        self.view.addSubview(productDesc)
        
        productPrice.title = "Price"
        productPrice.placeholder = "Price"
        productPrice.tintColor = overcastBlueColor
        productPrice.textColor = darkGreyColor
        productPrice.lineColor = lightGreyColor
        productPrice.selectedTitleColor = overcastBlueColor
        productPrice.selectedLineColor = overcastBlueColor
        productPrice.lineHeight = 1.0
        productPrice.selectedLineHeight = 2.0
        self.view.addSubview(productPrice)
    }
    
    private func addConstraints() {
        constrain(self.view, productName, productDesc, productPrice) { superView, productName, productDesc, productPrice  in
            
            productName.width == 275
            productName.height == 45
            productName.centerX == superView.centerX
            productName.centerY == superView.centerY - 100
            
            productDesc.width == 275
            productDesc.height == 45
            productDesc.centerX == superView.centerX
            productDesc.top == productName.bottom + 25
            
            productPrice.width == 275
            productPrice.height == 45
            productPrice.centerX == superView.centerX
            productPrice.top == productDesc.bottom + 25
        }
    }
    
    private func dismissKeyboard() {
        let tap = UITapGestureRecognizer(target: self.view, action: Selector("endEditing:"))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
}
