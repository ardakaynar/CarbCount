//
//  FoodsViewModel.swift
//  CarbCount
//
//  Created by SH Developer on 31.05.2022.
//

import Foundation

class FoodsViewModel {
    
    let indexPath: Int?
    init(indexPath: Int) {
        self.indexPath = indexPath
    }
    
    var textFieldPlaceHolder: String {
        "Miktar"
    }
    
}
