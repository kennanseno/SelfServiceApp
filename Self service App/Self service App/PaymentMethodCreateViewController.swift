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
        $0.title = "Payment Provider"
        $0.options = ["Stripe","Simplify"]
    }
    let publicKeyRow = TextRow(){
        $0.title = "Public Key"
        $0.placeholder = "Add Public Key"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        form +++ Section(header: "New Payment Method", footer: "Please enter the correct API key provided otherwise all payments will be rejected.")
            <<< paymentProviderRow
            <<< publicKeyRow
    }
    
    
    

    @IBAction func addPaymentMethod(_ sender: Any) {
        if (paymentProviderRow.value == nil) {
            return
        } else if (publicKeyRow.value == nil) {
            return
        } else {
            //send paymentMethod data to server
            let params = [
                "params": [
                    "username": self.store.getOwner(),
                    "store_id": self.store.getId()
                ],
                "key": [
                    "_id": paymentProviderRow.value?.uppercased(),
                    "publicKey": publicKeyRow.value
                ]
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
