//
//  Transaction.swift
//  Self service App
//
//  Created by Kennan Lyle Seno on 03/04/2017.
//  Copyright © 2017 kennanseno. All rights reserved.
//

class Transaction {
    
    private var transactionID: String
    private var storeID: String
    private var transactionDate: String
    private var amount: Int
    private var currency: String
    private var productID = [String]()
    
    init(transactionID: String, storeID: String, transactionDate: String, amount: Int, currency: String, productID: [String]) {
        self.transactionID = transactionID
        self.storeID = storeID
        self.transactionDate = transactionDate
        self.amount = amount
        self.currency = currency
        self.productID = productID
    }
 
    init(transactionID: String, storeID: String, transactionDate: String, amount: Int, currency: String) {
        self.transactionID = transactionID
        self.storeID = storeID
        self.transactionDate = transactionDate
        self.amount = amount
        self.currency = currency
    }
    
    public func setID(transactionID: String) {
        self.transactionID = transactionID
    }
    public func setStoreID(storeID: String) {
        self.storeID = storeID
    }
    public func setDate(transactionDate: String) {
        self.transactionDate = transactionDate
    }
    public func setAmount(amount: Int) {
        self.amount = amount
    }
    public func setCurrency(currency: String) {
        self.currency = currency
    }
    public func setProductID(productID: [String]) {
        self.productID = productID
    }
    public func getTransactionID() -> String {
        return self.transactionID
    }
    public func getStoreID() -> String {
        return self.storeID
    }
    public func getDate() -> String {
        return self.transactionDate
    }
    public func getAmount() -> Int {
        return self.amount
    }
    public func getCurrency() -> String {
        return self.currency
    }
    public func getProductID() -> [String] {
        return self.productID
    }
}
