//
//  LandingPageViewController.swift
//  Self service App
//
//  Created by Kennan Lyle Seno on 02/11/2016.
//  Copyright © 2016 kennanseno. All rights reserved.
//

import UIKit
import Cartography

class LandingPageViewController: UIViewController {

    let textLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textLabel.text = "LANDING PAGE"

        addConstraints()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func addConstraints() {
        constrain(textLabel) { textLabel in
            guard let superview = textLabel.superview else {
                return
            }
            
        textLabel.width == 150
        textLabel.height == 50
        textLabel.centerX == superview.centerX
        textLabel.centerY == superview.centerY
        }
    }
    
    
}
