//
//  PaymentMethodCreateViewController.swift
//  Self service App
//
//  Created by Kennan Lyle Seno on 06/02/2017.
//  Copyright © 2017 kennanseno. All rights reserved.
//

import Alamofire
import SwiftyJSON
import Eureka

class PaymentMethodCreateViewController: FormViewController {

    var store = Store()
    let paymentProviderRow = SegmentedRow<String>() {
        $0.tag = "paymentProviderRow"
        $0.title = "Payment Provider"
        $0.options = ["Simplify","Stripe"]
        $0.value = "Simplify"
    }
    let publicKeyRow = TextRow(){
        $0.title = "Public Key"
        $0.placeholder = "Add Public Key"
    }
    var privateKeyRow = TextRow()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        privateKeyRow = TextRow() {
            $0.title = "Private Key"
            $0.placeholder = "Add Private Key"
            $0.hidden = Condition.function(["paymentProviderRow"], { form in
                let row = form.rowBy(tag: "paymentProviderRow") as? SegmentedRow<String>
                
                return row?.value != "Simplify" ? true : false
            })
        }

        form +++ Section(header: "New Payment Method", footer: "Please enter the correct API key provided otherwise all payments will be rejected.")
            <<< paymentProviderRow
            <<< publicKeyRow
            <<< privateKeyRow

    }

    @IBAction func addPaymentMethod(_ sender: Any) {
        if (paymentProviderRow.value == nil) {
            return
        } else if (publicKeyRow.value == nil) {
            return
        } else {
            //send paymentMethod data to server
            
            var paymentData = [
                "_id": paymentProviderRow.value?.uppercased(),
                "publicKey": publicKeyRow.value
            ]
            //add if Simplify
            if paymentProviderRow.value == "Simplify" {
                paymentData.updateValue(privateKeyRow.value, forKey: "privateKey")
            }
            
            let params = [
                "params": [
                    "username": self.store.getOwner(),
                    "store_id": self.store.getId()
                ],
                "key": paymentData
            ] as [String : Any]
            

            Alamofire.request("http://kennanseno.com:3000/fyp/addPaymentMethod", method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { response in
                switch response.result {
                case .success(_): break
                
                case .failure(let error):
                    print(error)
                }
            }
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
}
