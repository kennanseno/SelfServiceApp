//
//  ProductCreateViewController.swift
//  Self service App
//
//  Created by Kennan Lyle Seno on 24/12/2016.
//  Copyright © 2016 kennanseno. All rights reserved.
//

import UIKit

class ProductCreateViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setViews()
        self.addConstraints()
        self.dismissKeyboard()

        // Do any additional setup after loading the view.
    }

    private func setViews() {
    
    }
    
    private func addConstraints() {
//        constrain(self.view, profileImage) { superView, profileImage  in
//
//            
//        }
    }
    
    private func dismissKeyboard() {
        let tap = UITapGestureRecognizer(target: self.view, action: Selector("endEditing:"))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
}
