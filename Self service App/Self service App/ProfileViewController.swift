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
import PMAlertController

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {

    @IBOutlet weak var profileTable: UITableView!
    @IBOutlet weak var profileImage: UIImageView!
    
    // Hardcode data for now
    var sectionNames = ["Basic Information", "Store", " "]
    var user = [String: String]() //TODO: Not use dict as it needs to be ordered
   // var storeName = [String]() // add store names here NOTE: change so that create new store is always at the end to create new stores
    var stores = [Store]()
    var userName = "" // initialise here to it will be used to query store names
    
    var fieldName = [String]()
    var fieldValue = [String]()
    
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
        
        fieldName = [String](user.keys)
        fieldValue = [String](user.values)
        
        let longPressGesture:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.longPress(_:)))
        longPressGesture.minimumPressDuration = 1.0 // 1 second press
        longPressGesture.delegate = self
        self.profileTable.addGestureRecognizer(longPressGesture)
        
        self.stores.removeAll()
        // get store objects
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
                        Store(
                            id: $0["id"].stringValue,
                            name: $0["name"].stringValue,
                            description: $0["description"].stringValue,
                            address: $0["address"].stringValue,
                            owner: self.userName,
                            paymentMethod: $0["paymentMethod"]["_id"].stringValue.capitalized
                        )
                    })
            case .failure(let error):
                print(error)
            }
        }

    }
    
    func longPress(_ longPressGestureRecognizer: UILongPressGestureRecognizer) {
        
        if longPressGestureRecognizer.state == UIGestureRecognizerState.began {
            
            let touchPoint = longPressGestureRecognizer.location(in: self.profileTable)
            if let indexPath = profileTable.indexPathForRow(at: touchPoint)  {
                guard indexPath.section == 0 else {
                    return
                }
                
                let editUserProfile = PMAlertController(title: "Edit \(fieldName[indexPath.row].lowercased())", description: "", image: nil, style: .alert)
                
                editUserProfile.addTextField { (textField) in
                    textField?.placeholder = "New \(fieldName[indexPath.row].lowercased())..."
                    textField?.text = fieldValue[indexPath.row]
                }
                editUserProfile.addAction(PMAlertAction(title: "OK", style: .default, action: { () in
                    print("Capture action OK")
                }))
                editUserProfile.addAction(PMAlertAction(title: "Cancel", style: .cancel, action: { () -> Void in
                    print("Capture action Cancel")
                }))
                
                self.present(editUserProfile, animated: true, completion: nil)
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
        self.stores.append(Store(name: "Create new store..."))
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
            
            let simpleCell = Bundle.main.loadNibNamed("simpleCellTableViewCell", owner: self, options: nil)?.first as! simpleCellTableViewCell
            simpleCell.fieldName.text = self.fieldName[indexPath.row]
            simpleCell.fieldValue.text = self.fieldValue[indexPath.row]
            
            cell = simpleCell
        }else if indexPath.section == 1 {
            cell.textLabel?.text = self.stores[indexPath.row].getName()
        } else {
            cell.textLabel?.text = "View Transaction History"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            //TODO: move to edit user details
        } else if indexPath.section == 1 {
            if indexPath.row < self.stores.count - 1 {
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
            return self.stores.count
        } else {
            return 1
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "manageStoreVC" {
            if let destination = segue.destination as? ManageStoreViewController {
                destination.store = sender as! Store
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
