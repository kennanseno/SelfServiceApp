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

    let privateKeyRow = TextRow() {
        $0.title = "Private Key"
        $0.placeholder = "Add Private Key"
    }
    var publicKeyRow = TextRow()

    override func viewDidLoad() {
        super.viewDidLoad()

        
        publicKeyRow = TextRow(){
            $0.title = "Public Key"
            $0.placeholder = "Add Public Key"
            $0.hidden = Condition.function(["paymentProviderRow"], { form in
                let row = form.rowBy(tag: "paymentProviderRow") as? SegmentedRow<String>
                
                return row?.value != "Simplify" ? true : false
            })
        }

        form +++ Section(header: "New Payment Method", footer: "Please enter the correct API key provided otherwise all payments will be rejected.")
            <<< paymentProviderRow
            <<< privateKeyRow
            <<< publicKeyRow

    }

    @IBAction func addPaymentMethod(_ sender: Any) {
        if (paymentProviderRow.value == nil) {
            return
        } else if (privateKeyRow.value == nil) {
            return
        } else {
            //send paymentMethod data to server
            
            var paymentData = [
                "id": paymentProviderRow.value?.uppercased(),
                "privateKey": privateKeyRow.value
            ]
            //add if Simplify
            if paymentProviderRow.value == "Simplify" {
                paymentData.updateValue(publicKeyRow.value, forKey: "publicKey")
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
