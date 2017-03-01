//
//  CreditCard.swift
//  Self service App
//
//  Created by Kennan Lyle Seno on 23/02/2017.
//  Copyright © 2017 kennanseno. All rights reserved.
//

class CreditCard {
    private var number: String
    private var name: String
    private var cvc: Int
    private var expiration: String
    
    init(number: String, expiration: String, cvc: Int) {
        self.number = number
        self.expiration = expiration
        self.cvc = cvc
        self.name = ""
    }
    
    public func setNumber(number: String) {
        self.number = number
    }
    public func setCvc(cvc: Int) {
        self.cvc = cvc
    }
    public func setExpiration(expiration: String) { // FORMAT: MM/YY
        self.expiration = expiration
    }
    public func setName(name: String) {
        self.name = name
    }
    public func getName() -> String {
        return self.name
    }
    public func getNumber() -> String {
        return self.number
    }
    public func getExpiration() -> String {
        return self.expiration
    }
    public func getCvc() -> Int {
        return self.cvc
    }
}
