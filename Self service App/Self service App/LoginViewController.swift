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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Alamofire.request("http://kennanseno.com:3000/test/").responseJSON { response in
            print(response.request)  // original URL request
            print(response.response) // HTTP URL response
            print(response.data)     // server data
            print(response.result)   // result of response serialization
            
            if let JSON = response.result.value {
                print("JSON: \(JSON)")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

