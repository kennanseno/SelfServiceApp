//
//  Store.swift
//  Self service App
//
//  Created by Kennan Lyle Seno on 28/01/2017.
//  Copyright © 2017 kennanseno. All rights reserved.
//

class Store {
    
    private var name: String
    private var description: String
    private var address: String
    
    init() {
        self.name = ""
        self.description = ""
        self.address = ""
    }
    
    init(name: String, description: String, address: String) {
        self.name = name
        self.description = description
        self.address = address
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
    public func getName() -> String {
        return self.name
    }
    public func getDescription() -> String {
        return self.description
    }
    public func getAddress() -> String {
        return self.address
    }
}
