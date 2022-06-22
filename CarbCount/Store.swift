//
//  Store.swift
//  CarbCount
//
//  Created by SH Developer on 21.05.2022.
//

import Foundation

class Store: NSObject {
    static let shared = Store()
    
    var foodCount: Int = 0
    
    struct MealItems {
        let foodName: String
        let carbCount: String
        let foodDateTime: String
        let foodCount: String
        let foodImage: String
    }
    
    var mealData: [MealItems] = []
    
    var isMale: Bool = true
    
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
    
    var birthDate: String {
        get {
            return UserDefaults.standard.string(forKey: "birthDate") ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "birthDate")
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
