//
//  ProfileViewController.swift
//  Self service App
//
//  Created by Kennan Lyle Seno on 23/12/2016.
//  Copyright © 2016 kennanseno. All rights reserved.
//

import UIKit
import Cartography
import CoreData
import Alamofire
import SwiftyJSON

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var profileTable: UITableView!
    @IBOutlet weak var profileImage: UIImageView!
    
    // Hardcode data for now
    var sectionNames = ["Basic Information", "Store", " "]
    var user = [String: String]() //TODO: Not use dict as it needs to be ordered
    var storeName = [String]() // add store names here NOTE: change so that create new store is always at the end to create new stores
    var stores = [Store]()
    var userName = "" // initialise here to it will be used to query store names
    
    override func viewWillAppear(_ animated: Bool) {

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserEntity")
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try managedContext.fetch(request)
            
            if results.count > 0 {
                for result in results as! [NSManagedObject]{
                    if let username = result.value(forKey: "username") as? String {
                        user["Username"] = username
                        userName = username
                    }
                    if let name = result.value(forKey: "name") as? String {
                        user["Name"] = name
                    }
                    if let address = result.value(forKey: "address") as? String {
                        user["Address"] = address
                    }
                    if let email = result.value(forKey: "email") as? String {
                        user["Email"] = email
                    }
                }
            }
        }
        catch {
            print("Error")
        }
        
        self.storeName = [String]() //refresh values
        // get store nname
        let params = [
            "username" : userName
            ] as [String : Any]
        
        Alamofire.request("http://kennanseno.com:3000/fyp/getStore", parameters: params).responseJSON { response in
            switch response.result {
            case .success(let value):
                let result = JSON(value)
                self.stores = result[0]["stores"]
                    .arrayValue
                    .map({
                        Store(name: $0["name"].stringValue, description: $0["description"].stringValue, address: $0["address"].stringValue, owner: self.userName)
                    })

                self.storeName += self.stores.map({$0.getName()})
            case .failure(let error):
                print(error)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setViews()
        self.addConstraints()
        self.dismissKeyboard()
        
        profileTable.delegate = self
        profileTable.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.storeName.append("Create new store...")
        self.profileTable.reloadData()
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
            
            let simpleCell = Bundle.main.loadNibNamed("simpleCellTableViewCell", owner: self, options: nil)?.first as! simpleCellTableViewCell
            simpleCell.fieldName.text = fieldName[indexPath.row]
            simpleCell.fieldValue.text = fieldValue[indexPath.row]
            
            cell = simpleCell
        }else if indexPath.section == 1 {
            cell.textLabel?.text = storeName[indexPath.row]
        } else {
            cell.textLabel?.text = "View Transaction History"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            //TODO: move to edit user details
        } else if indexPath.section == 1 {
            if storeName[indexPath.row] != storeName[storeName.count - 1] {
                let manageStoreVC = storyboard?.instantiateViewController(withIdentifier: "manageStoreVC") as! ManageStoreViewController
                manageStoreVC.store = stores[indexPath.row]
                self.navigationController?.pushViewController(manageStoreVC, animated: true)
            } else{
                
                let createStoreVC = storyboard?.instantiateViewController(withIdentifier: "createStoreVC") as! CreateStoreViewController
                createStoreVC.username = self.userName
                self.navigationController?.pushViewController(createStoreVC, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return user.count
        } else if section == 1 {
            return storeName.count
        } else {
            return 1
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "manageStoreVC" {
            if let destination = segue.destination as? ManageStoreViewController {
                destination.store = sender as! Store
                print("sender value: \(sender)")
            }
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
