//
//  Store.swift
//  CarbCount
//
//  Created by SH Developer on 21.05.2022.
//

import Foundation

class Store: NSObject {
    static let shared = Store()
    
    var age: Int {
        get {
            return UserDefaults.standard.integer(forKey: "Yaş")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "Yaş")
        }
    }
    
    var name: String {
        get {
            return UserDefaults.standard.string(forKey: "isim") ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "isim")
        }
    }
    
    var surname: String {
        get {
            return UserDefaults.standard.string(forKey: "isim") ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "isim")
        }
    }
    
    
    var dailyCarbCount: Double {
        get {
            return UserDefaults.standard.double(forKey: "Karbonhidrat")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "Karbonhidrat")
        }
    }
}
