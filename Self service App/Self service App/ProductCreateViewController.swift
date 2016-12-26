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

class ProductCreateViewController: UIViewController {

    let lightGreyColor = UIColor(red: 197/255, green: 205/255, blue: 205/255, alpha: 1.0)
    let darkGreyColor = UIColor(red: 52/255, green: 42/255, blue: 61/255, alpha: 1.0)
    let overcastBlueColor = UIColor(red: 0, green: 187/255, blue: 204/255, alpha: 1.0)
    
    @IBOutlet weak var addProductButton: UIBarButtonItem!
    @IBOutlet weak var productName: SkyFloatingLabelTextField!
    @IBOutlet weak var productDesc: SkyFloatingLabelTextField!
    @IBOutlet weak var productPrice: SkyFloatingLabelTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setViews()
        self.addConstraints()
        self.dismissKeyboard()

        // Do any additional setup after loading the view.
    }

    @IBAction func addProductButtonPressed(_ sender: Any) {
        //TODO: add product data to server
        
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
