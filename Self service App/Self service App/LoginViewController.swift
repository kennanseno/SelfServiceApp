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
import SwiftyJSON
import BubbleTransition
import CoreData

class LoginViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    let url = "http://kennanseno.com:3000/fyp/test/find"
    let transition = BubbleTransition()
    let lightGreyColor = UIColor(red: 197/255, green: 205/255, blue: 205/255, alpha: 1.0)
    let darkGreyColor = UIColor(red: 52/255, green: 42/255, blue: 61/255, alpha: 1.0)
    let overcastBlueColor = UIColor(red: 0, green: 187/255, blue: 204/255, alpha: 1.0)
    
    let colour1 = UIColor(red: 188/255, green: 244/255, blue: 245/255, alpha: 1.0)
    let colour2 = UIColor(red: 180/255, green: 235/255, blue: 202/255, alpha: 1.0)
    
    @IBOutlet weak var loginNoticeLabel: UILabel!
    @IBOutlet weak var usernameTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white

        self.setViews()
        self.addConstraints()
        dismissKeyboard()
    }
    
    /**
        Function to add username to Core Data when logged in successfully
     */
    private func saveUserDetails(user: User) {

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "UserEntity", in: managedContext)
        let item = NSManagedObject(entity: entity!, insertInto: managedContext)
        item.setValue(user.getUsername(), forKey: "username")
        item.setValue(user.getName(), forKey: "name")
        item.setValue(user.getAddress(), forKey: "address")
        item.setValue(user.getEmail(), forKey: "email")
        
        do {
            try managedContext.save()
        }
        catch {
            print("Error saving user details into core data!")
        }
        
    }
    
    @IBAction func registerButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "registerUserVC", sender: nil)
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        let params = [
            "username" : usernameTextField.text!,
            "password" : passwordTextField.text!
        ] as [String : String]
        
        Alamofire.request("http://kennanseno.com:3000/fyp/findUser", parameters: params).responseJSON { response in
            switch response.result {
            case .success(let value):
                let result = JSON(value)
                if(result.count == 1) {
                    let user = User(
                        username: result[0]["username"].string!,
                        name: result[0]["name"].string!,
                        email: result[0]["email"].string!,
                        address: result[0]["address"].string!
                    )

                    self.saveUserDetails(user: user)
                    self.performSegue(withIdentifier: "landingPageVC", sender: nil)
                    
                } else if(result.count == 0) {
                    UIView.animate(withDuration: 3.0, animations: {
                        self.loginNoticeLabel.text = "No user found!"
                        self.loginNoticeLabel.isHidden = false
                    })
                }
            case .failure(let error):
                print(error)
                UIView.animate(withDuration: 3.0, animations: {
                    self.loginNoticeLabel.isHidden = false
                }, completion:{ finished in
                    if (finished) {
                        self.loginNoticeLabel.isHidden = true
                    }
                })
                
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination
        controller.transitioningDelegate = self
        controller.modalPresentationStyle = .custom
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present
        transition.startingPoint = self.view.center
        transition.bubbleColor = colour2
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        transition.startingPoint = self.view.center
        transition.bubbleColor = colour2
        return transition
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
        self.view.addSubview(loginButton)
        
        registerButton.setTitle("Register", for: .normal)
        registerButton.titleLabel?.textAlignment = NSTextAlignment.left
        registerButton.setTitleColor(lightGreyColor, for: .normal)
        registerButton.setTitleColor(overcastBlueColor, for: .highlighted)
        self.view.addSubview(registerButton)
        
        loginNoticeLabel.text = "Wrong username/password. Try again!"
        loginNoticeLabel.textColor = UIColor.red
        loginNoticeLabel.isHidden = true
        loginNoticeLabel.textAlignment = .center
        
        self.view.addSubview(loginNoticeLabel)
    }
    
    private func addConstraints() {
        constrain(self.view, usernameTextField, passwordTextField, loginButton, registerButton) { superView, usernameTextField, passwordTextField, loginButton, registerButton in

            usernameTextField.width == 275
            usernameTextField.height == 45
            usernameTextField.centerX == superView.centerX
            usernameTextField.centerY == superView.centerY - 100
            passwordTextField.width == 275
            passwordTextField.height == 45
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
        
        constrain(self.view, registerButton, loginNoticeLabel) { superView, registerButton, loginNoticeLabel in
            loginNoticeLabel.leading == superView.leading
            loginNoticeLabel.trailing == superView.trailing
            loginNoticeLabel.height == 50
            loginNoticeLabel.centerX == superView.centerX
            loginNoticeLabel.top == registerButton.bottom + 100
        }
    }
    
    private func dismissKeyboard() {
        let tap = UITapGestureRecognizer(target: self.view, action: Selector("endEditing:"))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
}

