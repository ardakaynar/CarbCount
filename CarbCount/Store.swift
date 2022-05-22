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
    
    var height: String {
        get {
            return UserDefaults.standard.string(forKey: "boy") ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "boy")
        }
    }
    
    var weight: String {
        get {
            return UserDefaults.standard.string(forKey: "kilo") ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "kilo")
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
            return UserDefaults.standard.string(forKey: "soyisim") ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "soyisim")
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
    
    var consumedCarbCount: Double {
        get {
            return UserDefaults.standard.double(forKey: "tüketilen Karbonhidrat")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "tüketilen Karbonhidrat")
        }
    }
}
