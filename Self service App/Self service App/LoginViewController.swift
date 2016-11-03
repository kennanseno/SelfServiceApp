//
//  ViewController.swift
//  Self service App
//
//  Created by Kennan Lyle Seno on 02/11/2016.
//  Copyright © 2016 kennanseno. All rights reserved.
//

import UIKit
import Alamofire
import Cartography

class LoginViewController: UIViewController {
    
    let usernameTextField = UITextView()
    let passwordTextField = UITextView()
    let loginButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(usernameTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        
        view.backgroundColor = UIColor.blue
        loginButton.setTitle("Login", for: .normal)
        loginButton.addTarget(self, action: "loginButtonPressed:", for: .touchUpInside)
        
        addConstraints()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func addConstraints() {
        constrain(usernameTextField, passwordTextField, loginButton) { usernameTextField, passwordTextField, loginButton in
            guard let superview = usernameTextField.superview else {
                return
            }
            
            usernameTextField.width == 240
            usernameTextField.height == 50
            usernameTextField.centerX == superview.centerX
            usernameTextField.top == superview.top + 50
            
            passwordTextField.width == 240
            passwordTextField.height == 50
            passwordTextField.centerX == superview.centerX
            passwordTextField.top == usernameTextField.bottom + 50
        
            loginButton.width == 100
            loginButton.height == 50
            loginButton.trailing == passwordTextField.trailing
            loginButton.top == passwordTextField.bottom + 20
        }
    }
    
    func loginButtonPressed(_ sender: AnyObject?) {
//        guard let vc = UIStoryboard(name:"LandingPageStoryboard", bundle:nil).instantiateInitialViewController() as? LandingPageViewController else {
//            return
//        }
//        
//        self.navigationController?.pushViewController(vc, animated: true)
        print("login button pressed!")
    }
}

