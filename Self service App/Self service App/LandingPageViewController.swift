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
        self.view.backgroundColor = UIColor.white
        
        setViews()
        addConstraints()
    }
    
    private func setViews() {
        textLabel.text = "LANDING PAGE"
        textLabel.textColor = UIColor.black
        self.view.addSubview(textLabel)
    }
    
    private func addConstraints() {
        constrain(self.view, textLabel) { superView, textLabel in
            textLabel.width == 150
            textLabel.height == 50
            textLabel.centerX == superView.centerX
            textLabel.centerY == superView.centerY
        }
    }
}
