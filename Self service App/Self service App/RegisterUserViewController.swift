//
//  RegisterUserViewController.swift
//  Self service App
//
//  Created by Kennan Lyle Seno on 04/11/2016.
//  Copyright © 2016 kennanseno. All rights reserved.
//

import UIKit
import Cartography
import SkyFloatingLabelTextField
import Alamofire
import SwiftyJSON


class RegisterUserViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var addressTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var emailTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var usernameTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var registeredButton: UIButton!
    @IBOutlet weak var cancelRegButton: UIButton!

    let lightGreyColor = UIColor(red: 197/255, green: 205/255, blue: 205/255, alpha: 1.0)
    let darkGreyColor = UIColor(red: 52/255, green: 42/255, blue: 61/255, alpha: 1.0)
    let overcastBlueColor = UIColor(red: 0, green: 187/255, blue: 204/255, alpha: 1.0)
    let backgroundColour = UIColor(red: 180/255, green: 235/255, blue: 202/255, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = backgroundColour

        self.setViews()
        self.addConstraints()
        self.dismissKeyboard()
    }

    @IBAction func registeredButtonPressed(_ sender: Any) {
        let params = [
            "username": usernameTextField.text!,
            "email": emailTextField.text!,
            "password": passwordTextField.text!,
            "name": nameTextField.text!,
            "address": addressTextField.text!
        ]
        
        Alamofire.request("http://kennanseno.com:3000/fyp/registerUser", parameters: params).responseJSON { response in
            switch response.result {
            case .success(let _):
                print("User registered!")
                self.dismiss(animated: true, completion: nil)
            case .failure(let error):
                print(error)
                //TODO: Error handler
            }
        }
    }
    
    @IBAction func cancelRegButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    private func dismissKeyboard() {
        let tap = UITapGestureRecognizer(target: self.view, action: Selector("endEditing:"))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }

    private func setViews() {
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
        
        emailTextField.title = "Email Address"
        emailTextField.placeholder = "Email Address"
        emailTextField.tintColor = overcastBlueColor // the color of the blinking cursor
        emailTextField.textColor = darkGreyColor
        emailTextField.lineColor = lightGreyColor
        emailTextField.selectedTitleColor = overcastBlueColor
        emailTextField.selectedLineColor = overcastBlueColor
        
        passwordTextField.lineHeight = 1.0 // bottom line height in points
        passwordTextField.selectedLineHeight = 2.0
        self.view.addSubview(passwordTextField)
        
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
        
        nameTextField.title = "Full Name"
        nameTextField.placeholder = "Full Name"
        nameTextField.tintColor = overcastBlueColor // the color of the blinking cursor
        nameTextField.textColor = darkGreyColor
        nameTextField.lineColor = lightGreyColor
        nameTextField.selectedTitleColor = overcastBlueColor
        nameTextField.selectedLineColor = overcastBlueColor
        
        nameTextField.lineHeight = 1.0 // bottom line height in points
        nameTextField.selectedLineHeight = 2.0
        self.view.addSubview(nameTextField)
        
        addressTextField.title = "Address"
        addressTextField.placeholder = "Address"
        addressTextField.tintColor = overcastBlueColor // the color of the blinking cursor
        addressTextField.textColor = darkGreyColor
        addressTextField.lineColor = lightGreyColor
        addressTextField.selectedTitleColor = overcastBlueColor
        addressTextField.selectedLineColor = overcastBlueColor
        
        addressTextField.lineHeight = 1.0 // bottom line height in points
        addressTextField.selectedLineHeight = 2.0
        self.view.addSubview(addressTextField)
        
        registeredButton.setTitle("Register", for: .normal)
        registeredButton.titleLabel?.textAlignment = NSTextAlignment.right
        registeredButton.setTitleColor(lightGreyColor, for: .normal)
        registeredButton.setTitleColor(overcastBlueColor, for: .highlighted)
        self.view.addSubview(registeredButton)
        
        cancelRegButton.setTitle("Cancel", for: .normal)
        cancelRegButton.titleLabel?.textAlignment = NSTextAlignment.right
        cancelRegButton.setTitleColor(lightGreyColor, for: .normal)
        cancelRegButton.setTitleColor(overcastBlueColor, for: .highlighted)
        self.view.addSubview(cancelRegButton)
    
    }
    
    private func addConstraints() {
        constrain(self.view, usernameTextField, passwordTextField, emailTextField, nameTextField) { superView, usernameTextField, passwordTextField, emailTextField, nameTextField in
            
            usernameTextField.width == 275
            usernameTextField.height == 45
            usernameTextField.centerX == superView.centerX
            usernameTextField.centerY == superView.centerY - 200
            
            emailTextField.width == 275
            emailTextField.height == 45
            emailTextField.centerX == superView.centerX
            emailTextField.top == usernameTextField.bottom + 25
            
            passwordTextField.width == 275
            passwordTextField.height == 45
            passwordTextField.centerX == superView.centerX
            passwordTextField.top == emailTextField.bottom + 25
            
            nameTextField.width == 275
            nameTextField.height == 45
            nameTextField.centerX == superView.centerX
            nameTextField.top == passwordTextField.bottom + 25
        }
        
        constrain(self.view, registeredButton, cancelRegButton, addressTextField, nameTextField) { superView, registeredButton, cancelRegButton, addressTextField, nameTextField in
            
            addressTextField.width == 275
            addressTextField.height == 45
            addressTextField.centerX == superView.centerX
            addressTextField.top == nameTextField.bottom + 25
            
            registeredButton.width == 70
            registeredButton.height == 50
            registeredButton.trailing == addressTextField.trailing
            registeredButton.top == addressTextField.bottom + 25
            
            
            cancelRegButton.width == 50
            cancelRegButton.height == 50
            cancelRegButton.leading == addressTextField.leading
            cancelRegButton.top == addressTextField.bottom + 25
        }
    }
}
