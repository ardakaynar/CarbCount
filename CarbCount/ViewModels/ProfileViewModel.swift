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
        "Boy - (Cm)"
    }
    
    var weightPlaceholder: String {
        "Kilo - (Kg)"
    }
    
    var navigationTitle: String {
        "Profil"
    }
    
    var infoCarbLabel: String {
        "Karbonhidrat ve karbonhidratın önemi hakkında daha fazla bilgi almak için tıklayınız."
    }
    
    var infoCarbCalculateLabel: String {
        "Günlük tüketmen gereken karbonhidrat miktarının hesaplanması hakkında bilgi almak için tıklayınız."
    }
}
