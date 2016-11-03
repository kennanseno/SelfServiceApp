//
//  LandingPageViewController.swift
//  Self service App
//
//  Created by Kennan Lyle Seno on 02/11/2016.
//  Copyright © 2016 kennanseno. All rights reserved.
//

import UIKit
import Cartography


protocol LandingPageViewControllerDelegate: NSObjectProtocol {
    func weGotToTheLandingPage(text: String)
}

class LandingPageViewController: UIViewController {
    let textLabel = UILabel()
    var textToSet: String?
    var closure: ((String) -> ())?
    
    weak var delegate: LandingPageViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews()
    }

    private func setupViews() {
        self.view.backgroundColor = UIColor.white
        if let text = textToSet {
            textLabel.text = text
        }
        textLabel.textColor = UIColor.black
        self.view.addSubview(textLabel)
        addConstraints()
        messageDelegate()
        
        if let c = closure {
            c("Hello from the closure");
        }
        
    }
    
    private func addConstraints() {
        constrain(self.view, textLabel) {
            superView, textLabel in
            textLabel.width == 150
            textLabel.height == 50
            textLabel.centerX == superView.centerX
            textLabel.centerY == superView.centerY
        }
    }
    
    private func messageDelegate() {
        if let d = self.delegate {
            d.weGotToTheLandingPage(text: "Hello there!")
        }
    }
}
