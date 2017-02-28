//
//  Store.swift
//  Self service App
//
//  Created by Kennan Lyle Seno on 28/01/2017.
//  Copyright © 2017 kennanseno. All rights reserved.
//

import MapKit

class Store {
    
    private var id: String
    private var name: String
    private var description: String
    private var address: String
    private var owner: String
    private var paymentMethod: String
    private var location = CLLocationCoordinate2D()
    private var products = [Product]()
    
    init() {
        self.id = ""
        self.name = ""
        self.description = ""
        self.address = ""
        self.owner = ""
        self.paymentMethod = ""
    }
    
    init(name: String) {
        self.id = ""
        self.name = name
        self.description = ""
        self.address = ""
        self.owner = ""
        self.paymentMethod = ""
    }
    
    init(id: String) {
        self.id = id
        self.name = ""
        self.description = ""
        self.address = ""
        self.owner = ""
        self.paymentMethod = ""
    }
    
    
    init(name: String, description: String, address: String) {
        self.name = name
        self.description = description
        self.address = address
        self.owner = ""
        self.paymentMethod = ""
        self.id = ""
    }
    
    init(name: String, description: String, location: CLLocationCoordinate2D, owner: String) {
        self.name = name
        self.description = description
        self.address = ""
        self.location = location
        self.owner = owner
        self.paymentMethod = ""
        self.id = ""
    }
    
    init(id: String, name: String, description: String, location: CLLocationCoordinate2D, owner: String) {
        self.name = name
        self.description = description
        self.address = ""
        self.location = location
        self.owner = owner
        self.paymentMethod = ""
        self.id = id
    }
    
    init(name: String, description: String, address: String, owner: String) {
        self.name = name
        self.description = description
        self.address = address
        self.owner = owner
        self.paymentMethod = ""
        self.id = ""
    }
    
    init(name: String, description: String, address: String, owner: String, paymentMethod: String) {
        self.name = name
        self.description = description
        self.address = address
        self.owner = owner
        self.paymentMethod = paymentMethod
        self.id = ""
    }
    
    init(id: String, name: String, description: String, address: String, owner: String, paymentMethod: String) {
        self.id = id
        self.name = name
        self.description = description
        self.address = address
        self.owner = owner
        self.paymentMethod = paymentMethod
    }
    
    public func setId(id: String) {
        self.id = id
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
    public func setOwner(owner: String) {
        self.owner = owner
    }
    public func setPaymentMethod(paymentMethod: String) {
        self.paymentMethod = paymentMethod
    }
    public func setLocation(location: CLLocationCoordinate2D) {
        self.location = location
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
    public func getOwner() -> String {
        return self.owner
    }
    public func getPaymentMethod() -> String {
        return self.paymentMethod
    }
    public func getLocation() -> CLLocationCoordinate2D {
        return self.location
    }
    public func getId() -> String {
        return self.id
    }
}
