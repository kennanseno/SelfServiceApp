//
//  CreateStoreViewController.swift
//  Self service App
//
//  Created by Kennan Lyle Seno on 23/12/2016.
//  Copyright © 2016 kennanseno. All rights reserved.
//

import UIKit
import Cartography
import SkyFloatingLabelTextField
import Alamofire
import SwiftyJSON

class CreateStoreViewController: UIViewController {
    
    let lightGreyColor = UIColor(red: 197/255, green: 205/255, blue: 205/255, alpha: 1.0)
    let darkGreyColor = UIColor(red: 52/255, green: 42/255, blue: 61/255, alpha: 1.0)
    let overcastBlueColor = UIColor(red: 0, green: 187/255, blue: 204/255, alpha: 1.0)
    
    @IBOutlet weak var createStoreButton: UIBarButtonItem!
    @IBOutlet weak var storeName: SkyFloatingLabelTextField!
    @IBOutlet weak var storeDesc: SkyFloatingLabelTextField!
    @IBOutlet weak var storeAddr: SkyFloatingLabelTextField!
    var username = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setViews()
        self.addConstraints()
        self.dismissKeyboard()
    }
    
    @IBAction func createStore(_ sender: Any) {
        for textfield in [storeName, storeDesc, storeAddr] {
            if(!(textfield?.text?.isEmpty)!) {
                self.navigationController?.popViewController(animated: true)
            } else {
                return
            }
        }
        
        let params = [
                "params": [ "username": username ],
                "data": [
                    "name" : storeName.text!,
                    "description": storeDesc.text!,
                    "address": storeAddr.text!
                ]
        ] as [String : Any]
        
        Alamofire.request("http://kennanseno.com:3000/fyp/createStore", method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { response in
            switch response.result {
                case .success(let value):
                    let result = JSON(value)
                    print(result)
        
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    private func setViews() {
        storeName.title = "Store Name"
        storeName.placeholder = "Store Name"
        storeName.tintColor = overcastBlueColor
        storeName.textColor = darkGreyColor
        storeName.lineColor = lightGreyColor
        storeName.selectedTitleColor = overcastBlueColor
        storeName.selectedLineColor = overcastBlueColor
        storeName.lineHeight = 1.0
        storeName.selectedLineHeight = 2.0
        self.view.addSubview(storeName)
        
        storeDesc.title = "Store Description"
        storeDesc.placeholder = "Store Description"
        storeDesc.tintColor = overcastBlueColor
        storeDesc.textColor = darkGreyColor
        storeDesc.lineColor = lightGreyColor
        storeDesc.selectedTitleColor = overcastBlueColor
        storeDesc.selectedLineColor = overcastBlueColor
        storeDesc.lineHeight = 1.0
        storeDesc.selectedLineHeight = 2.0
        self.view.addSubview(storeDesc)
        
        storeAddr.title = "Address"
        storeAddr.placeholder = "Address"
        storeAddr.tintColor = overcastBlueColor
        storeAddr.textColor = darkGreyColor
        storeAddr.lineColor = lightGreyColor
        storeAddr.selectedTitleColor = overcastBlueColor
        storeAddr.selectedLineColor = overcastBlueColor
        storeAddr.lineHeight = 1.0
        storeAddr.selectedLineHeight = 2.0
        self.view.addSubview(storeAddr)
    }
    
    private func addConstraints() {
        constrain(self.view, storeName, storeDesc, storeAddr) { superView, storeName, storeDesc, storeAddr  in

            storeName.width == 275
            storeName.height == 45
            storeName.centerX == superView.centerX
            storeName.centerY == superView.centerY - 100
            
            storeDesc.width == 275
            storeDesc.height == 45
            storeDesc.centerX == superView.centerX
            storeDesc.top == storeName.bottom + 25
            
            storeAddr.width == 275
            storeAddr.height == 45
            storeAddr.centerX == superView.centerX
            storeAddr.top == storeDesc.bottom + 25
        }
    }
    
    private func dismissKeyboard() {
        let tap = UITapGestureRecognizer(target: self.view, action: Selector("endEditing:"))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }

}
