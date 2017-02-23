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
import CoreData

class CartViewController: FormViewController {
    
    var userName = ""
    var products = [Product]()
    var cart = Cart()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserEntity")
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try managedContext.fetch(request)
            
            if results.count > 0 {
                for result in results as! [NSManagedObject]{
                    if let username = result.value(forKey: "username") as? String {
                        self.cart.getCustomer().setUsername(username: username)
                    }
                    if let name = result.value(forKey: "name") as? String {
                        self.cart.getCustomer().setName(name: name)
                    }
                    if let email = result.value(forKey: "email") as? String {
                        self.cart.getCustomer().setEmail(email: email)
                    }
                    if let address = result.value(forKey: "address") as? String {
                        self.cart.getCustomer().setAddress(address: address)
                    }
                }
            }
        }
        catch {
            print("Error")
        }
        
        
        let params = [
            "username": self.cart.getCustomer().getUsername()
            ] as [String : Any]
        
        Alamofire.request("http://kennanseno.com:3000/fyp/getCartData", parameters: params).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value).arrayValue
                
                
                let productList = json.map({
                    Product(
                        productCode: $0["_id"].stringValue,
                        name: $0["name"].stringValue,
                        description: $0["description"].stringValue,
                        price: $0["price"].intValue,
                        quantity: $0["quantity"].intValue)
                })
                self.cart.setProducts(products: productList)
                
                let section = Section("Products")
                let totalRow = DecimalRow() { row in
                    row.title = "Total"
                    row.value = self.calculateTotalPrice(rowTag: "")
                }.onChange({ tRow in
                    tRow.reload()
                })
                for product in self.cart.getProducts() {
                    let row = StepperRow() { row in
                        row.tag = product.getProductCode()
                        row.title = "\(product.getName()) @ €\(Double(product.getPrice()))"
                        row.value = Double(product.getQuantity())
                    }.onChange({ stepperRow in
                        totalRow.value = self.calculateTotalPrice(rowTag: stepperRow.tag!)
                        self.cart.setTotalPrice(totalPrice: Int(totalRow.value!))
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
        
        for product in self.cart.getProducts() {
            if rowTag != "" && product.getProductCode() == rowTag {
                product.setQuantity(quantity: Int(currentRow.value!))
            }
            
            total += Double(product.getPrice() * product.getQuantity())
        }
        return total
    }
    
    @IBAction func toCheckout(_ sender: Any) {
        let checkoutVC = storyboard?.instantiateViewController(withIdentifier: "checkoutVC") as! CheckoutViewController
        checkoutVC.cart = self.cart
        self.navigationController?.pushViewController(checkoutVC, animated: true)
    }
    

}
