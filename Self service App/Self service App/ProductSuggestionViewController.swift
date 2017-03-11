//
//  ProductSuggestionViewController.swift
//  Self service App
//
//  Created by Kennan Lyle Seno on 10/03/2017.
//  Copyright © 2017 kennanseno. All rights reserved.
//

import UIKit
import Eureka
import Alamofire
import SwiftyJSON
import Whisper

class ProductSuggestionViewController: FormViewController {

    var username = ""
    var store = Store()
    var newProductSection = SelectableSection<ListCheckRow<String>>("New Products", selectionType: .multipleSelection)
    var relatedProductSection = SelectableSection<ListCheckRow<String>>("Related Products", selectionType: .multipleSelection)
    var newProducts = [Product]()
    var relatedProducts = [Product]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let params = [
            "username": self.username,
            "store_id": store.getId()
        ] as [String : Any]
        
        
        Alamofire.request("http://kennanseno.com:3000/fyp/productSuggestion", parameters: params).responseJSON { response in
            switch response.result {
            case .success(let value):
                let result = JSON(value)

                self.newProducts = result[0].arrayValue.map({
                    return Product(
                        productCode: $0["_id"].stringValue,
                        name: $0["name"].stringValue,
                        description: $0["description"].stringValue,
                        price: $0["price"].intValue,
                        quantity: $0["quantity"].intValue)
                    
                })
                
                self.form.append(self.newProductSection)
                self.form.append(self.relatedProductSection)
                
                self.relatedProducts = result[1].arrayValue.map({
                    return Product(
                        productCode: $0["_id"].stringValue,
                        name: $0["name"].stringValue,
                        description: $0["description"].stringValue,
                        price: $0["price"].intValue,
                        quantity: $0["quantity"].intValue)
                })
                
                for product in self.newProducts {
                    self.form.first! <<< ListCheckRow<String>(){ listRow in
                        listRow.title = "\(product.getName()) @ \(Double(product.getPrice()))"
                        listRow.selectableValue = product.getProductCode()
                        listRow.value = nil
                    }
                }
                for product in self.relatedProducts {
                    self.form.last! <<< ListCheckRow<String>(){ listRow in
                        listRow.title = "\(product.getName()) @ \(Double(product.getPrice()))"
                        listRow.selectableValue = product.getProductCode()
                        listRow.value = nil
                    }
                }
                
            case .failure( _):
                self.form +++ Section()
                    <<< LabelRow() { row in
                        row.cell.textLabel?.textAlignment = .center
                        row.title = "Product Suggestion not available"
                    }
            }
        }
    }

    @IBAction func addSuggestProducts(_ sender: Any) {
        
        var product = [String]()
        for section in [newProductSection, relatedProductSection] {
            for row in section.selectedRows() {
                product.append((row.selectableValue?.displayString)!)
            }
        }
        
        let params = [
            "username": self.username,
            "data": [
                "product_id": product,
                "store_id": self.store.getId(),
                "quantity": 1 //starting quantity always 1
            ]
        ] as [String : Any]
        
        Alamofire.request("http://kennanseno.com:3000/fyp/addToCart", method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { response in
            switch response.result {
            case .success( _):
                let successMessage = Message(title: "Products successfully to your cart!", textColor: .green, backgroundColor: UIColor(white: 1, alpha: 0), images: nil)
                Whisper.show(whisper: successMessage, to: self.navigationController!, action: .show)
                self.navigationController?.popViewController(animated: true)
                
            case .failure(let error):
                let errorMessage = Message(title: "Error! Products not added.", textColor: .red, backgroundColor: UIColor(white: 1, alpha: 0), images: nil)
                Whisper.show(whisper: errorMessage, to: self.navigationController!, action: .show)
                print(error)
            }
        }
    }

}
