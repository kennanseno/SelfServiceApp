//
//  CheckoutViewController.swift
//  Self service App
//
//  Created by Kennan Lyle Seno on 20/02/2017.
//  Copyright © 2017 kennanseno. All rights reserved.
//

import Eureka
import CreditCardRow
import PostalAddressRow
import Alamofire
import SwiftyJSON
import Whisper

class CheckoutViewController: FormViewController {
    
    var cart = Cart()

    override func viewDidLoad() {
        super.viewDidLoad()
        print("store:\(self.cart.getStoreID())")
        
        let creditCardRow = CreditCardRow() {
            $0.maxCVVLength = 3
            $0.add(rule: RuleRequired())
            $0.cell.cvvField?.placeholder = "CVC"
            $0.maxCreditCardNumberLength = 16
        }
        
        form +++ Section("Card Information")
            <<< creditCardRow
        form +++ Section()
            <<< ButtonRow() {
                $0.title = "Pay Now"
                }.onCellSelection({ cell, row in
                    if(creditCardRow.cell.numberField.text == "" || creditCardRow.cell.expirationField?.text == "" || creditCardRow.cell.cvvField?.text == "") {
                        let errorMessage = Message(title: "All fields must be filled!", textColor: .orange, backgroundColor: UIColor(white: 1, alpha: 1), images: nil)
                        Whisper.show(whisper: errorMessage, to: self.navigationController!, action: .show)
                        return
                    }
                    
                    let card = CreditCard(number: creditCardRow.cell.numberField.text!, expiration: (creditCardRow.cell.expirationField?.text)!, cvc: Int((creditCardRow.cell.cvvField?.text)!)!)
                    
                    //TODO: send customer data
                    let params = [
                            "store_id": self.cart.getStoreID(),
                            "username": self.cart.getCustomer().getUsername(),
                            "amount": self.cart.getTotalPrice(),
                            "currency": "EUR", // single currency support for now
                            "card": [
                                "number": card.getNumber(),
                                "expiration": card.getExpiration(),
                                "cvc": card.getCvc()
                            ]

                        ] as [String : Any]
                    
                    Alamofire.request("http://kennanseno.com:3000/fyp/pay", method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { response in
                        switch response.result {
                        case .success(let value):
                            let result = JSON(value)
                            print(result)
                            
                            self.navigationController?.popToRootViewController(animated: true)
                        case .failure(let error):
                            print(error)
                        }
                    }

                })
//        form +++ Section("Shipping address")
//            <<< shippingRow
//        form +++ Section()
//            <<< switchRow
//        form +++ billingSection
        
    }
    
    //        let switchRow = SwitchRow() {
    //            $0.tag = "switchRow"
    //            $0.title = "Billing address same as shipping"
    //        }
    //
    //        let billingRow = PostalAddressRow() {
    //            $0.streetPlaceholder = "Street"
    //            $0.statePlaceholder = "County"
    //            $0.cityPlaceholder = "City"
    //            $0.countryPlaceholder = "Country"
    //            $0.postalCodePlaceholder = "Zip code"
    //        }
    //
    //        let shippingRow = PostalAddressRow() {
    //            $0.streetPlaceholder = "Street"
    //            $0.statePlaceholder = "County"
    //            $0.cityPlaceholder = "City"
    //            $0.countryPlaceholder = "Country"
    //            $0.postalCodePlaceholder = "Zip code"
    //        }
    //
    //        let billingSection = Section("Billing Address") {
    //            $0.hidden = Condition.function(["switchRow"], { form in
    //                let row = form.rowBy(tag: "switchRow") as? SwitchRow
    //
    //                if row!.value == true {
    //                    billingRow.value = shippingRow.value
    //                } else {
    //                    billingRow.value?.street = nil
    //                    billingRow.value?.city = nil
    //                    billingRow.value?.state = nil
    //                    billingRow.value?.postalCode = nil
    //                    billingRow.value?.country = nil
    //                }
    //
    //                return row!.value ?? false
    //            })
    //        }
    //        billingSection.append(billingRow)
    //        

}
