//
//  Cart.swift
//  Self service App
//
//  Created by Kennan Lyle Seno on 23/02/2017.
//  Copyright © 2017 kennanseno. All rights reserved.
//

class Cart {
    
    private var customer: User
    private var products = [Product]()
    private var totalPrice: Int
    private var storeOwner: String
    private var storeName: String
    
    init() {
        self.customer = User()
        self.totalPrice = 0
        self.storeName = ""
        self.storeOwner = ""
    }
    
    public func setStoreName(storeName: String) {
        self.storeName = storeName
    }
    public func setStoreOwner(storeOwner: String) {
        self.storeOwner = storeOwner
    }
    public func setCustomer(customer: User) {
        self.customer = customer
    }
    public func setProducts(products: [Product]) {
        self.products = products
    }
    public func setTotalPrice(totalPrice: Int) {
        self.totalPrice = totalPrice
    }
    public func getCustomer() -> User {
        return self.customer
    }
    public func getProducts() -> [Product] {
        return self.products
    }
    public func getTotalPrice() -> Int {
        return self.totalPrice
    }
    public func getStoreName() -> String {
        return self.storeName
    }
    public func getStoreOwner() -> String {
        return self.storeOwner
    }
}
