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
    var sectionNames = ["Store", "Products"]
    var storeFieldLabel = ["Name", "Description", "Address"] //TODO: Not use dict as it needs to be ordered
    var products = ["Product 1"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViews()
        addConstraints()
        dismissKeyboard()
        
        manageStoreTable.delegate = self
        manageStoreTable.dataSource = self
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sectionNames.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sectionNames[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
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
            
        }else if indexPath.section == 1 {
            cell.textLabel?.text = products[indexPath.row]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return storeFieldLabel.count
        } else {
            return products.count
        }
    }
    
    @IBAction func addProducts(_ sender: Any) {
        //TODO: move to qr scanner page to scan products
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
