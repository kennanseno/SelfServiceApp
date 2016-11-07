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

    
    @IBOutlet weak var textLabel: UILabel!
    let backgroundColour = UIColor(red: 180/255, green: 235/255, blue: 202/255, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = backgroundColour
        
        self.setViews()
        self.addConstraints()
    }
    
    private func setViews() {
        textLabel.textColor = UIColor.blue
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
