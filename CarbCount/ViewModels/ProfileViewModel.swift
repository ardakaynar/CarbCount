//
//  ProfileViewModel.swift
//  CarbCount
//
//  Created by SH Developer on 19.05.2022.
//

import Foundation

class ProfileViewModel {
    
    var maxDate: Date = Calendar.defaultLocalizedCalendar().date(byAdding: .year, value: -15, to: Date())!
    
    var birthdayPlaceholder: String {
        "Doğum Günü"
    }
    
    var namePlaceholder: String {
        "İsim"
    }
    
    var surnamePlaceholder: String {
        "Soyisim"
    }
    
    var agePlaceholder: String {
        "Yaş"
    }
    
    var heightPlaceholder: String {
        "Boy"
    }
    
    var weightPlaceholder: String {
        "Kilo"
    }
    
    var navigationTitle: String {
        "Profil"
    }
}
