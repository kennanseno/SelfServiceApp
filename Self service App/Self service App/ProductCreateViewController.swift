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
import Eureka
import TokenRow
import CLTokenInputView

class ProductCreateViewController: FormViewController {

    var store = Store()
    var productCode = ""
    
    let productNameRow = TextRow(){
        $0.title = "Product Name"
        $0.placeholder = "Product name"
        $0.add(rule: RuleRequired())
        $0.validationOptions = .validatesOnChange
    }
    let productDescRow = TextRow() {
        $0.title = "Product Description"
        $0.placeholder = "Product description"
        $0.add(rule: RuleRequired())
        $0.validationOptions = .validatesOnChange
    }
    let productPriceRow = IntRow() {
        $0.placeholder = "Product price"
        $0.title = "Price"
        $0.add(rule: RuleRequired())
        $0.validationOptions = .validatesOnChange
    }
    let productTagRow = TokenTableRow<String>() {
        $0.placeholder = "Choose tags for your product"
        $0.options = ["water", "electronics", "biscuit", "energy drinks", "fruit", "pants", "vegetables", "crisps", "drinks"]
    }
    
    @IBOutlet weak var addProductButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        form +++ Section()
                <<< productNameRow
                <<< productDescRow
                <<< productPriceRow
             +++ Section(header: "Product Tags", footer: "Add as many tags to the product that relates to it to help on product recommendations")
                <<< productTagRow
    }

    @IBAction func addProductButtonPressed(_ sender: Any) {
        //validation
        guard let productName = productNameRow.value, !productName.isEmpty else {
            let errorMessage = Message(title: "Product name must be filled!", textColor: .orange, backgroundColor: UIColor(white: 1, alpha: 0), images: nil)
            Whisper.show(whisper: errorMessage, to: self.navigationController!, action: .show)
            return
        }
        guard let productDesc = productDescRow.value, !productDesc.isEmpty else {
            let errorMessage = Message(title: "Product description must be filled!", textColor: .orange, backgroundColor: UIColor(white: 1, alpha: 0), images: nil)
            Whisper.show(whisper: errorMessage, to: self.navigationController!, action: .show)
            return
        }
        guard let productPrice = productPriceRow.value, productPrice > 0 else {
            let errorMessage = Message(title: "Invalid price!", textColor: .orange, backgroundColor: UIColor(white: 1, alpha: 0), images: nil)
            Whisper.show(whisper: errorMessage, to: self.navigationController!, action: .show)
            return
        }
        
        //send product data to server
        let product = Product(productCode: self.productCode, name: productName, description: productDesc, price: productPrice)
        let productTags = Array(productTagRow.value!);
        let params = [
                "store_id": self.store.getId(),
                "data": [
                    "code": product.getProductCode(),
                    "name": product.getName(),
                    "description": product.getDescription(),
                    "price": product.getPrice(),
                    "tags": productTags
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
    
}
