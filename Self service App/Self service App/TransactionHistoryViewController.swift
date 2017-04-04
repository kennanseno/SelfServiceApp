//
//  TransactionHistoryViewController.swift
//  Self service App
//
//  Created by Kennan Lyle Seno on 03/04/2017.
//  Copyright © 2017 kennanseno. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Whisper
import SwiftMoment

class TransactionHistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var transactionTable: UITableView!
    var username = ""
    var transactions = [Transaction]()
    override func viewDidLoad() {
        super.viewDidLoad()

        transactionTable.delegate = self
        transactionTable.dataSource = self


    }
    
    override func viewWillAppear(_ animated: Bool) {
        let params = [
            "username": self.username
            ] as [String : Any]
        
        Alamofire.request("http://kennanseno.com:3000/fyp/getTransactionHistory", parameters: params).responseJSON { response in
            switch response.result {
            case .success(let value):
                let result = JSON(value)
                self.transactions = result.arrayValue.map({
                    print("result:\($0["amount"].stringValue)")
                    return Transaction(
                        transactionID: $0["_id"].stringValue,
                        storeID: $0["store_id"].stringValue,
                        transactionDate: $0["transaction_date"].stringValue,
                        amount: $0["amount"].intValue / 100,
                        currency: $0["currency"].stringValue)
                    
                })
            case .failure(let error):
                print(error)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        transactionTable.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let transactionCell = Bundle.main.loadNibNamed("TransactionTableViewCell", owner: self, options: nil)?.first as! TransactionTableViewCell

        transactionCell.amountLabel.text = "Amount: " + String(self.transactions[indexPath.row].getAmount())
        transactionCell.currencyLabel.text = "Currency: " + self.transactions[indexPath.row].getCurrency()
        transactionCell.storeLabel.text = "Store: " + self.transactions[indexPath.row].getStoreID()
        transactionCell.transactionIDLabel.text = "ID: " + self.transactions[indexPath.row].getTransactionID()
        transactionCell.transactionDateLabel.text = "Date: " + moment(Int(self.transactions[indexPath.row].getDate())!).format("MMMM dd YYYY")
     
        return transactionCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Transactions"
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(100)
    }
    
}



