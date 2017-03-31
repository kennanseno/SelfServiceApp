//
//  ManageStoreViewController.swift
//  Self service App
//
//  Created by Kennan Lyle Seno on 23/12/2016.
//  Copyright © 2016 kennanseno. All rights reserved.
//

import UIKit
import Cartography
import Alamofire
import SwiftyJSON
import PMAlertController
import Whisper

class ManageStoreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, UIActionSheetDelegate {
    
    @IBOutlet weak var manageStoreTable: UITableView!
    
    //Hardcode data for now
    var store = Store()
    var sectionNames = ["Store", "Payment Method", "Products"]
    var storeFieldLabel = ["Name", "Description", "Address"] //TODO: Not use dict as it needs to be ordered
    var products = [Product]()
    
    override func viewWillAppear(_ animated: Bool) {
        let params = [ "store_id": store.getId() ] as [String : Any]
        
        Alamofire.request("http://kennanseno.com:3000/fyp/getStoreDetails", parameters: params).responseJSON { response in
            switch response.result {
            case .success(let value):
                let result = JSON(value)
                self.products = result[0]["products"]
                    .arrayValue
                    .map({
                        Product(productCode: $0["_id"].stringValue,name: $0["name"].stringValue, description: $0["description"].stringValue, price: $0["price"].intValue)
                    })
                self.store.setPaymentMethod(paymentMethod: result[0]["paymentMethod"].stringValue.capitalized)
                
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setViews()
        addConstraints()
        dismissKeyboard()
        
        manageStoreTable.delegate = self
        manageStoreTable.dataSource = self
        
        let longPressGesture:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.longPress(_:)))
        longPressGesture.minimumPressDuration = 1.0 // 1 second press
        longPressGesture.delegate = self
        self.manageStoreTable.addGestureRecognizer(longPressGesture)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.manageStoreTable.reloadData()
    }
    
    func longPress(_ longPressGestureRecognizer: UILongPressGestureRecognizer) {
        
        if longPressGestureRecognizer.state == UIGestureRecognizerState.began {
            
            let touchPoint = longPressGestureRecognizer.location(in: self.manageStoreTable)
            if let indexPath = manageStoreTable.indexPathForRow(at: touchPoint)  {
                guard indexPath.section == 0 || indexPath.section == 2 else {
                    return
                }
                
                if indexPath.section == 0 {
                    var fieldValue = ""
                    switch indexPath.row {
                    case 0:
                        fieldValue = store.getName()
                    case 1:
                        fieldValue = store.getDescription()
                    case 2:
                        fieldValue = store.getAddress()
                    default:
                        break;
                    }
                    
                    let editStoreDetails = PMAlertController(title: "Edit \(storeFieldLabel[indexPath.row].lowercased())", description: "", image: nil, style: .alert)
                    
                    editStoreDetails.addTextField { (textField) in
                        textField?.placeholder = "New \(storeFieldLabel[indexPath.row].lowercased())..."
                        textField?.text = fieldValue
                    }
                    editStoreDetails.addAction(PMAlertAction(title: "OK", style: .default, action: { () in
                        
                        let params = [
                            "store_id": self.store.getId(),
                            "field_name": self.storeFieldLabel[indexPath.row].lowercased(),
                            "field_value": editStoreDetails.textFields.first?.text ?? ""
                            ] as [String : Any]
                        
                        
                        Alamofire.request("http://kennanseno.com:3000/fyp/updateStoreDetails", method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { response in
                            switch response.result {
                            case .success(_):
                                
                                if let cell = self.manageStoreTable.cellForRow(at: indexPath) {
                                    cell.textLabel?.text = editStoreDetails.textFields.first?.text
                                    self.manageStoreTable.reloadData()
                                }
                                
                                let successMessage = Message(title: "\(self.storeFieldLabel[indexPath.row]) successfully updated!", textColor: .green, backgroundColor: UIColor(white: 1, alpha: 0), images: nil)
                                Whisper.show(whisper: successMessage, to: self.navigationController!, action: .show)
                                
                            case .failure(let error):
                                print(error)
                            }
                        }
                    }))
                    editStoreDetails.addAction(PMAlertAction(title: "Cancel", style: .cancel, action: { () -> Void in
                        print("Capture action Cancel")
                    }))
                    
                    self.present(editStoreDetails, animated: true, completion: nil)
                } else if indexPath.section == 2 {
                    let actionSheet = UIAlertController(title: "Choose Option", message: "", preferredStyle: .actionSheet)
                    actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { Void in
                        print("Cancel button tapped")
                    }))
                    
                    actionSheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { Void in
                        
                        let confirmProductDelete = PMAlertController(title: "Delete this product?", description: "", image: nil, style: .alert)
                        confirmProductDelete.addAction(PMAlertAction(title: "OK", style: .default, action: { () in
                            //Delete product
                            print("confirm product delete")
                            let params = [
                                "store_id": self.store.getId(),
                                "product_id": self.products[indexPath.row].getProductCode()
                            ] as [String : Any]
                            
                            Alamofire.request("http://kennanseno.com:3000/fyp/removeProduct", method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { response in
                                switch response.result {
                                case .success(_):
                                    self.manageStoreTable.reloadData()
                                    let successMessage = Message(title: "Product successfully deleted!", textColor: .green, backgroundColor: UIColor(white: 1, alpha: 0), images: nil)
                                    Whisper.show(whisper: successMessage, to: self.navigationController!, action: .show)
                                    
                                case .failure(let error):
                                    print(error)
                                }
                            }
                        }))
                        confirmProductDelete.addAction(PMAlertAction(title: "Cancel", style: .cancel, action: { () -> Void in
                            print("Capture action Cancel")
                        }))
                         self.present(confirmProductDelete, animated: true, completion: nil)
                    }))
                     self.present(actionSheet, animated: true, completion: nil)
                }
            }
        }
    }
    

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       if indexPath.section == 1 {
            if store.getPaymentMethod() == "" {
                let paymentMethodCreateVC = storyboard?.instantiateViewController(withIdentifier: "paymentMethodCreateVC") as! PaymentMethodCreateViewController
                paymentMethodCreateVC.store = self.store
                self.navigationController?.pushViewController(paymentMethodCreateVC, animated: true)
            }
        }
    }
    
    @IBAction func addProducts(_ sender: Any) {
        let productScannerVC = self.storyboard?.instantiateViewController(withIdentifier: "productScannerVC") as! ProductScannerViewController
        productScannerVC.store = self.store
        self.navigationController?.pushViewController(productScannerVC, animated: true)
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
            simpleCell.fieldName.text = storeFieldLabel[indexPath.row]
            switch indexPath.row {
            case 0:
                simpleCell.fieldValue.text = store.getName()
            case 1:
                simpleCell.fieldValue.text = store.getDescription()
            case 2:
                simpleCell.fieldValue.text = store.getAddress()
            default:
                break;
            }
            
            cell = simpleCell
            
        } else if indexPath.section == 1 {
            cell.textLabel?.text = store.getPaymentMethod() != "" ? store.getPaymentMethod() : "Add new Payment method..."
        } else if indexPath.section == 2 {
            cell.textLabel?.text = products[indexPath.row].getName()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return storeFieldLabel.count
        } else if section == 1{
            return 1
        } else {
            return products.count
        }
    }
    
    private func setViews() {
        self.view.addSubview(manageStoreTable)
    }
    
    private func addConstraints() {
        constrain(self.view, manageStoreTable) { superView, manageStoreTable  in
            
            manageStoreTable.left == superView.left
            manageStoreTable.right == superView.right
            manageStoreTable.top == superView.top
            manageStoreTable.bottom == superView.bottom
            
        }
    }
    
    private func dismissKeyboard() {
        let tap = UITapGestureRecognizer(target: self.view, action: Selector("endEditing:"))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
}
