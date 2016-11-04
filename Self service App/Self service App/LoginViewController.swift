//
//  LoginViewController.swift
//  Self service App
//
//  Created by Kennan Lyle Seno on 02/11/2016.
//  Copyright © 2016 kennanseno. All rights reserved.
//  penis

import UIKit
import Alamofire
import Cartography
import SkyFloatingLabelTextField

class LoginViewController: UIViewController {
    
    let url = "http://Kennans-MacBook-Pro.local:3000/fyp/test/find";
    let usernameTextField = SkyFloatingLabelTextField(frame: CGRect(x: 150, y: 10, width: 275, height: 45))
    let passwordTextField = SkyFloatingLabelTextField(frame: CGRect(x: 150, y: 10, width: 275, height: 45))
    let loginButton = UIButton()
    let registerButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white

        self.setViews()
        self.addConstraints()
    }

    private func setViews() {
        let lightGreyColor = UIColor(red: 197/255, green: 205/255, blue: 205/255, alpha: 1.0)
        let darkGreyColor = UIColor(red: 52/255, green: 42/255, blue: 61/255, alpha: 1.0)
        let overcastBlueColor = UIColor(red: 0, green: 187/255, blue: 204/255, alpha: 1.0)

        usernameTextField.title = "Username"
        usernameTextField.placeholder = "Username"
        usernameTextField.tintColor = overcastBlueColor // the color of the blinking cursor
        usernameTextField.textColor = darkGreyColor
        usernameTextField.lineColor = lightGreyColor
        usernameTextField.selectedTitleColor = overcastBlueColor
        usernameTextField.selectedLineColor = overcastBlueColor
        
        usernameTextField.lineHeight = 1.0 // bottom line height in points
        usernameTextField.selectedLineHeight = 2.0
        self.view.addSubview(usernameTextField)
        
        passwordTextField.title = "Password"
        passwordTextField.placeholder = "Password"
        passwordTextField.tintColor = overcastBlueColor // the color of the blinking cursor
        passwordTextField.textColor = darkGreyColor
        passwordTextField.lineColor = lightGreyColor
        passwordTextField.selectedTitleColor = overcastBlueColor
        passwordTextField.selectedLineColor = overcastBlueColor
        
        passwordTextField.lineHeight = 1.0 // bottom line height in points
        passwordTextField.selectedLineHeight = 2.0
        self.view.addSubview(passwordTextField)
        
        loginButton.setTitle("Login", for: .normal)
        loginButton.titleLabel?.textAlignment = NSTextAlignment.right
        loginButton.setTitleColor(lightGreyColor, for: .normal)
        loginButton.setTitleColor(overcastBlueColor, for: .highlighted)
        loginButton.addTarget(self, action: "loginButtonPressed:", for: .touchUpInside)
        self.view.addSubview(loginButton)
        
        registerButton.setTitle("Register", for: .normal)
        registerButton.titleLabel?.textAlignment = NSTextAlignment.left
        registerButton.setTitleColor(lightGreyColor, for: .normal)
        registerButton.setTitleColor(overcastBlueColor, for: .highlighted)
        registerButton.addTarget(self, action: "registerButtonPressed:", for: .touchUpInside)
        self.view.addSubview(registerButton)
    }
    
    private func addConstraints() {
        constrain(self.view, usernameTextField, passwordTextField, loginButton, registerButton) { superView, usernameTextField, passwordTextField, loginButton, registerButton in

            usernameTextField.centerX == superView.centerX
            usernameTextField.centerY == superView.centerY - 100
            passwordTextField.centerX == superView.centerX
            passwordTextField.top == usernameTextField.bottom + 25
        
            loginButton.width == 50
            loginButton.height == 50
            loginButton.trailing == passwordTextField.trailing
            loginButton.top == passwordTextField.bottom + 25
            
            registerButton.width == 70
            registerButton.height == 50
            registerButton.leading == passwordTextField.leading
            registerButton.top == passwordTextField.bottom + 25
        }
    }
    
    
    func loginButtonPressed(_ sender: AnyObject?) {
        var params = [
            "username" : usernameTextField.text!,
            "password" : passwordTextField.text!
        ]
        
//        Alamofire.request(url, parameters: params).responseJSON { response in
//            print(response.request)  // original URL request
//            print(response.response) // HTTP URL response
//            print(response.data)     // server data
//            print(response.result)   // result of response serialization
//            
//            if let JSON = response.result.value {
//                print("JSON: \(JSON)")
//            }
//        }
    
        let landingPageViewController = LandingPageViewController();
        self.present(landingPageViewController, animated: true, completion: nil)
    }
    
    func registerButtonPressed(_ sender: AnyObject?) {
        let registerUserViewController = RegisterUserViewController();
        self.present(registerUserViewController, animated: true, completion: nil)
    }
}

