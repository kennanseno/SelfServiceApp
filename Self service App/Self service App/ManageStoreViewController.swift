//
//  ManageStoreViewController.swift
//  Self service App
//
//  Created by Kennan Lyle Seno on 23/12/2016.
//  Copyright © 2016 kennanseno. All rights reserved.
//

import UIKit
import Cartography

class ManageStoreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var manageStoreTable: UITableView!
    
    //Hardcode data for now
    var sectionNames = ["Store", "Products"]
    var store = ["Name": "Penneys", "Description": "Awesome Clothing Store!!", "Address": "25 Millstead, Blanchardstown"] //TODO: Not use dict as it needs to be ordered
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
            let fieldName = [String](store.keys)
            let fieldValue = [String](store.values)
            let simpleCell = Bundle.main.loadNibNamed("simpleCellTableViewCell", owner: self, options: nil)?.first as! simpleCellTableViewCell
            simpleCell.fieldName.text = fieldName[indexPath.row]
            simpleCell.fieldValue.text = fieldValue[indexPath.row]
            
            cell = simpleCell
            
        }else if indexPath.section == 1 {
            cell.textLabel?.text = products[indexPath.row]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return store.count
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
