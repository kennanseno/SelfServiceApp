//
//  LandingPageViewController.swift
//  Self service App
//
//  Created by Kennan Lyle Seno on 02/11/2016.
//  Copyright © 2016 kennanseno. All rights reserved.
//

import UIKit
import Cartography
import SkyFloatingLabelTextField

class LandingPageViewController: UIViewController {
    
    @IBOutlet weak var checkMap: UIButton!
    @IBOutlet weak var profileButton: UIButton!
    let backgroundColour = UIColor(red: 180/255, green: 235/255, blue: 202/255, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = backgroundColour
        self.setViews()
        self.addConstraints()
        dismissKeyboard()
    }
    
    private func setViews() {
        self.view.addSubview(profileButton)
        self.view.addSubview(checkMap)
    }
    
    
    private func addConstraints() {
        constrain(self.view, profileButton, checkMap) { superView, profileButton, checkMap  in
            
            profileButton.left == superView.left + 30
            profileButton.top == superView.top + 30
            checkMap.centerX == superView.centerX
            checkMap.centerY == superView.centerY
        }
    }
    
    private func dismissKeyboard() {
        let tap = UITapGestureRecognizer(target: self.view, action: Selector("endEditing:"))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
}
