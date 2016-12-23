//
//  ProfileViewController.swift
//  Self service App
//
//  Created by Kennan Lyle Seno on 23/12/2016.
//  Copyright © 2016 kennanseno. All rights reserved.
//

import UIKit
import Cartography

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var profileTable: UITableView!
    @IBOutlet weak var profileImage: UIImageView!
    
    // Hardcode data for now
    var sectionNames = ["Basic Information", "Store", " "]
    var user = ["Username": "kseno", "Name": "Kennan Seno", "Address": "25 Millstead, Blanchardstown"] //TODO: Not use dict as it needs to be ordered
    var stores = ["Penneys", "Create new store..."] // add store names here NOTE: change so that create new store is always at the end to create new stores
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setViews()
        self.addConstraints()
        self.dismissKeyboard()
        
        profileTable.delegate = self
        profileTable.dataSource = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sectionNames.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sectionNames[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        cell.textLabel?.textAlignment = .center

        if indexPath.section == 0 {
            let fieldName = [String](user.keys)
            let fieldValue = [String](user.values)
            
            if let userCell = profileTable.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as? UserCell{
                userCell.updateUI(_fieldName: fieldName[indexPath.row], _fieldValue: fieldValue[indexPath.row])
                
                cell = userCell
            }
        }else if indexPath.section == 1 {
            cell.textLabel?.text = stores[indexPath.row]
        } else {
            cell.textLabel?.text = "View Transaction History"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            //TODO: move to edit user details
        } else if indexPath.section == 1 {
            if stores[indexPath.row] != stores[stores.count - 1] {
                //TODO request store details of selected store on server
                print("manageSToreVC")
                self.performSegue(withIdentifier: "manageStoreVC", sender: nil)
            } else{
                print("createStoreVC")
                self.performSegue(withIdentifier: "createStoreVC", sender: nil)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return user.count
        } else if section == 1 {
            return stores.count
        } else {
            return 1
        }
    }
    
    @IBAction func toStorePressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func setViews() {
        self.view.addSubview(profileImage)
    }
    
    private func addConstraints() {
        constrain(self.view, profileImage) { superView, profileImage  in
            
            profileImage.width == 150
            profileImage.height == 150
            profileImage.top == superView.top + 70
            profileImage.centerX == superView.centerX
            
        }
    }
    
    private func dismissKeyboard() {
        let tap = UITapGestureRecognizer(target: self.view, action: Selector("endEditing:"))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
}
