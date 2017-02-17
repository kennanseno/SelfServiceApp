//
//  CartViewController.swift
//  Self service App
//
//  Created by Kennan Lyle Seno on 15/02/2017.
//  Copyright © 2017 kennanseno. All rights reserved.
//

import UIKit
import Eureka
import Alamofire
import SwiftyJSON
import Dollar

class CartViewController: FormViewController {
    
    var username = ""
    var store = Store()
    var products = [Product]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let params = [
            "username": self.username
            ] as [String : Any]
        
        Alamofire.request("http://kennanseno.com:3000/fyp/getCartData", parameters: params).responseJSON { response in
            switch response.result {
            case .success(let value):
                self.products = JSON(value).arrayValue.map({
                    Product(
                        productCode: $0["_id"].stringValue,
                        name: $0["name"].stringValue,
                        description: $0["description"].stringValue,
                        price: $0["price"].intValue,
                        quantity: $0["quantity"].intValue)
                })
                
                let section = Section("Products")
                let totalRow = DecimalRow() { row in
                    row.title = "Total"
                    row.value = self.calculateTotalPrice(rowTag: "")
                }.onChange({ tRow in
                    tRow.reload()
                })
                for product in self.products {
                    let row = StepperRow() { row in
                        row.tag = product.getProductCode()
                        row.title = "\(product.getName()) @ €\(Double(product.getPrice()))"
                        row.value = Double(product.getQuantity())
                    }.onChange({ stepperRow in
                        totalRow.value = self.calculateTotalPrice(rowTag: stepperRow.tag!)
                    })
                    
                    section.append(row)
                }
                
                let totalSection = Section("Total")
                totalSection.append(totalRow)
        
                self.form.append(section)
                self.form.append(totalSection)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func calculateTotalPrice(rowTag: String) -> Double {
        var currentRow = StepperRow()
        if rowTag != "" {
           currentRow = form.rowBy(tag: rowTag) as! StepperRow
        }

        var total: Double =  0.0
        
        for product in self.products {
            if rowTag != "" && product.getProductCode() == rowTag {
                product.setQuantity(quantity: Int(currentRow.value!))
            }
            
            total += Double(product.getPrice() * product.getQuantity())
        }
        return total
    }

}
