//
//  File.swift
//  Self service App
//
//  Created by Kennan Lyle Seno on 29/01/2017.
//  Copyright © 2017 kennanseno. All rights reserved.
//

class Product {
    
    private var productCode: String
    private var name: String
    private var description: String
    private var address: String
    private var price: Int
    
    init() {
        self.productCode = ""
        self.name = ""
        self.description = ""
        self.address = ""
        self.price = 0
    }
    
    init(productCode: String, name: String, description: String, address: String, price: Int) {
        self.productCode = productCode
        self.name = name
        self.description = description
        self.address = address
        self.price = price
    }
    
    public func setProductCode(productCode: String) {
        self.productCode = productCode
    }
    public func setName(name: String) {
        self.name = name
    }
    public func setDescription(description: String) {
        self.description = description
    }
    public func setAddress(address: String) {
        self.address = address
    }
    public func setPrice(price: Int) {
        self.price = price
    }
    public func getProductCode() -> String {
        return self.productCode
    }
    public func getName() -> String {
        return self.name
    }
    public func getDescription() -> String {
        return self.description
    }
    public func getAddress() -> String {
        return self.address
    }
    public func getPrice() -> Int {
        return self.price
    }
}
