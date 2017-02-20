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


class CheckoutViewController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let switchRow = SwitchRow() {
            $0.tag = "switchRow"
            $0.title = "Billing address same as shipping"
        }
        
        let billingRow = PostalAddressRow() {
            $0.streetPlaceholder = "Street"
            $0.statePlaceholder = "County"
            $0.cityPlaceholder = "City"
            $0.countryPlaceholder = "Country"
            $0.postalCodePlaceholder = "Zip code"
        }
        
        let shippingRow = PostalAddressRow() {
            $0.streetPlaceholder = "Street"
            $0.statePlaceholder = "County"
            $0.cityPlaceholder = "City"
            $0.countryPlaceholder = "Country"
            $0.postalCodePlaceholder = "Zip code"
        }
        
        let billingSection = Section("Billing Address") {
            $0.hidden = Condition.function(["switchRow"], { form in
                let row = form.rowBy(tag: "switchRow") as? SwitchRow
                
                if row!.value == true {
                    billingRow.value = shippingRow.value
                } else {
                    billingRow.value?.street = nil
                    billingRow.value?.city = nil
                    billingRow.value?.state = nil
                    billingRow.value?.postalCode = nil
                    billingRow.value?.country = nil
                }
                
                return row!.value ?? false
            })
        }
        billingSection.append(billingRow)
        
        form +++ Section("Card Information")
            <<< CreditCardRow() {
                $0.maxCVVLength = 3
                $0.cell.cvvField?.placeholder = "CVC"
                $0.maxCreditCardNumberLength = 16
        }
        form +++ Section("Shipping address")
            <<< shippingRow
        form +++ Section()
            <<< switchRow
        form +++ billingSection
        
    }
}
