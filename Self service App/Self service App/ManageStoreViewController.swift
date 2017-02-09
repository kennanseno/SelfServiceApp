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

class ManageStoreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var manageStoreTable: UITableView!
    
    //Hardcode data for now
    var store = Store()
    var sectionNames = ["Store", "Payment Method", "Products"]
    var storeFieldLabel = ["Name", "Description", "Address"] //TODO: Not use dict as it needs to be ordered
    var products = [Product]()
    
    override func viewWillAppear(_ animated: Bool) {
        let params = [
            "username" : store.getOwner(),
            "storename": store.getName()
            ] as [String : Any]
        
        Alamofire.request("http://kennanseno.com:3000/fyp/getStoreDetails", parameters: params).responseJSON { response in
            switch response.result {
            case .success(let value):
                let result = JSON(value)
                print(result)
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.manageStoreTable.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            //TODO: edit store details
        } else if indexPath.section == 1 {
            if store.getPaymentMethod() == "" {
                let paymentMethodCreateVC = storyboard?.instantiateViewController(withIdentifier: "paymentMethodCreateVC") as! PaymentMethodCreateViewController
                paymentMethodCreateVC.store = self.store
                self.navigationController?.pushViewController(paymentMethodCreateVC, animated: true)
            } else{
                //TODO: Edit payment method
            }
        } else {
            //TODO: Edit product details
        }
    }
    
    @IBAction func addProducts(_ sender: Any) {
        let productScannerVC = self.storyboard?.instantiateViewController(withIdentifier: "productScannerVC") as! ProductScannerViewController
        productScannerVC.storeName = store.getName()
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
