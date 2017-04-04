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
import Whisper

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {

    @IBOutlet weak var profileTable: UITableView!
    @IBOutlet weak var profileImage: UIImageView!
    
    // Hardcode data for now
    var sectionNames = ["Basic Information", "Store", " "]
    var user = User()
   // var storeName = [String]() // add store names here NOTE: change so that create new store is always at the end to create new stores
    var stores = [Store]()
    var userName = "" // initialise here to it will be used to query store names
    
    var fieldName = ["Username", "Name", "Email", "Address"]
    var fieldValue = ""
    
    func longPress(_ longPressGestureRecognizer: UILongPressGestureRecognizer) {
        
        if longPressGestureRecognizer.state == UIGestureRecognizerState.began {
            
            let touchPoint = longPressGestureRecognizer.location(in: self.profileTable)
            if let indexPath = profileTable.indexPathForRow(at: touchPoint)  {
                guard indexPath.section == 0 || indexPath.section == 1 else {
                    return
                }
                
                if indexPath.section == 0 {
                    switch indexPath.row {
                    case 0:
                        fieldValue = self.user.getUsername()
                    case 1:
                        fieldValue = self.user.getName()
                    case 2:
                        fieldValue = self.user.getEmail()
                    case 3:
                        fieldValue = self.user.getAddress()
                    default:
                        ""
                    }
                    
                    let editUserProfile = PMAlertController(title: "Edit \(fieldName[indexPath.row].lowercased())", description: "", image: nil, style: .alert)
                    
                    editUserProfile.addTextField { (textField) in
                        textField?.placeholder = "New \(fieldName[indexPath.row].lowercased())..."
                        textField?.text = fieldValue
                    }
                    editUserProfile.addAction(PMAlertAction(title: "OK", style: .default, action: { () in
                        let params = [
                            "username": self.user.getUsername(),
                            "fieldName": self.fieldName[indexPath.row].lowercased(),
                            "fieldValue": editUserProfile.textFields.first?.text ?? ""
                            ] as [String : Any]
                        
                        Alamofire.request("http://kennanseno.com:3000/fyp/updateUserInfo", method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { response in
                            switch response.result {
                            case .success( _):
                                
                                
                                if let cell = self.profileTable.cellForRow(at: indexPath) {
                                    cell.textLabel?.text = editUserProfile.textFields.first?.text
                                    self.profileTable.reloadData()
                                }
                                
                                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                let managedContext = appDelegate.persistentContainer.viewContext
                                
                                let entity = NSEntityDescription.entity(forEntityName: "UserEntity", in: managedContext)
                                let item = NSManagedObject(entity: entity!, insertInto: managedContext)
                                item.setValue(editUserProfile.textFields.first?.text, forKey: self.fieldName[indexPath.row].lowercased())
                                
                                do {
                                    try managedContext.save()
                                }
                                catch {
                                    print("Error saving user details into core data!")
                                }
                                
                                let successMessage = Message(title: "\(self.fieldName[indexPath.row]) successfully updated!", textColor: .green, backgroundColor: UIColor(white: 1, alpha: 0), images: nil)
                                Whisper.show(whisper: successMessage, to: self.navigationController!, action: .show)
                                
                            case .failure(let error):
                                let successMessage = Message(title: "Error updating \(self.fieldName[indexPath.row]). Try again!", textColor: .orange, backgroundColor: UIColor(white: 1, alpha: 0), images: nil)
                                Whisper.show(whisper: successMessage, to: self.navigationController!, action: .show)
                                print(error)
                            }
                        }
                    }))
                    editUserProfile.addAction(PMAlertAction(title: "Cancel", style: .cancel, action: { () -> Void in
                        print("Capture action Cancel")
                    }))
                    
                    self.present(editUserProfile, animated: true, completion: nil)
                } else if indexPath.section == 1 { //TODO: fix so actionsheet not shown on create store
                    print("row: \(indexPath.row) count:\(indexPath.count)")
                    let actionSheet = UIAlertController(title: "Choose Option", message: "", preferredStyle: .actionSheet)
                    actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { Void in
                        print("Cancel button tapped")
                    }))
                    
                    actionSheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { Void in
                        
                        let confirmStoreDelete = PMAlertController(title: "Delete store?", description: "", image: nil, style: .alert)
                        confirmStoreDelete.addAction(PMAlertAction(title: "OK", style: .default, action: { () in
                            //Delete store
                            print("confirm store delete")
                            let params = [
                                "store_id": self.stores[indexPath.row].getId(),
                                "username": self.user.getUsername()
                            ] as [String : Any]
                            
                            Alamofire.request("http://kennanseno.com:3000/fyp/deleteStore", method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { response in
                                switch response.result {
                                case .success(_):
                                    self.profileTable.reloadData()
                                    let successMessage = Message(title: "Store successfully deleted!", textColor: .green, backgroundColor: UIColor(white: 1, alpha: 0), images: nil)
                                    Whisper.show(whisper: successMessage, to: self.navigationController!, action: .show)
                                    
                                case .failure(let error):
                                    print(error)
                                }
                            }
                        }))
                        confirmStoreDelete.addAction(PMAlertAction(title: "Cancel", style: .cancel, action: { () -> Void in
                            print("Capture action Cancel")
                        }))
                        self.present(confirmStoreDelete, animated: true, completion: nil)
                    }))
                    self.present(actionSheet, animated: true, completion: nil)

                }
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
        
        let longPressGesture:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.longPress(_:)))
        longPressGesture.minimumPressDuration = 1.0 // 1 second press
        longPressGesture.delegate = self
        self.profileTable.addGestureRecognizer(longPressGesture)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.profileTable.reloadData()
    }
    
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
                        userName = username
                    }
                }
            }
        }
        catch {
            print("Error")
        }
        
        self.stores.removeAll()
        // get store objects
        let params = [
            "username" : userName
            ] as [String : Any]
        
        Alamofire.request("http://kennanseno.com:3000/fyp/getUser", parameters: params).responseJSON { response in
            switch response.result {
            case .success(let value):
                let result = JSON(value)
                
                self.user = User(username: result[0]["username"].stringValue,
                                 name: result[0]["name"].stringValue,
                                 email: result[0]["email"].stringValue,
                                 address: result[0]["address"].stringValue
                )
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
                self.stores.append(Store(name: "Create new store...")) // append for creating new store
                
            case .failure(let error):
                print(error)
            }
        }
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
            
            switch indexPath.row {
            case 0:
                simpleCell.fieldValue.text = self.user.getUsername()
            case 1:
                simpleCell.fieldValue.text = self.user.getName()
            case 2:
                simpleCell.fieldValue.text = self.user.getEmail()
            case 3:
                simpleCell.fieldValue.text = self.user.getAddress()
            default:
                ""
            }
            
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
        } else {
            let transactionHistoryVC = storyboard?.instantiateViewController(withIdentifier: "transactionHistoryVC") as! TransactionHistoryViewController
            transactionHistoryVC.username = self.userName
            self.navigationController?.pushViewController(transactionHistoryVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 4
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
        } else if segue.identifier == "transactionHistoryVC" {
            if let destination = segue.destination as? TransactionHistoryViewController {
               
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
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
}
