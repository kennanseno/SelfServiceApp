//
//  User.swift
//  Self service App
//
//  Created by Kennan Lyle Seno on 25/01/2017.
//  Copyright © 2017 kennanseno. All rights reserved.
//

class User {
    
    private var username: String
    private var name: String
    private var address: String
    private var email: String
    private var stores = [String]()
    
    init(username: String, name: String, email: String, address: String, stores: [String]) {
        self.username = username
        self.name = name
        self.email = email
        self.address = address
        self.stores = stores
    }
    
    init(username: String, name: String, email: String, address: String) {
        self.username = username
        self.name = name
        self.email = email
        self.address = address
    }
    
    init() {
        self.username = ""
        self.name = ""
        self.email = ""
        self.address = ""
    }
    
    public func setUsername(username: String) {
        self.username = username
    }
    public func setName(name: String) {
        self.name = name
    }
    public func setAddress(address: String) {
        self.address = address
    }
    public func setEmail(email: String) {
        self.email = email
    }
    
    public func getUsername() -> String {
        return self.username
    }
    public func getName() -> String {
        return self.name
    }
    public func getEmail() -> String {
        return self.email
    }
    public func getAddress() -> String {
        return self.address
    }
    public func getStores() -> [String] {
        return self.stores
    }
}
