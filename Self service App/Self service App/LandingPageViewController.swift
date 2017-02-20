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
    
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var searchField: SkyFloatingLabelTextField!
    @IBOutlet weak var searchButton: UIButton!
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
        self.view.addSubview(searchField)
        self.view.addSubview(searchButton)
    }
    
    
    private func addConstraints() {
        constrain(self.view, searchField, searchButton, profileButton) { superView, searchField, searchButton, profileButton  in
            
            profileButton.left == superView.left + 30
            profileButton.top == superView.top + 30
            
            searchField.width == 200
            searchField.height == 45
            searchField.centerX == superView.centerX - 30
            searchField.centerY == superView.centerY
            
            searchButton.width == 70
            searchButton.height == 50
            searchButton.leading == searchField.trailing + 20
            searchButton.centerY == superView.centerY + 10
            
        }
    }
    
    private func dismissKeyboard() {
        let tap = UITapGestureRecognizer(target: self.view, action: Selector("endEditing:"))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
}
