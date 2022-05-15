//
//  ViewController.swift
//  CarbCount
//
//  Created by SH Developer on 12.05.2022.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureAccesibility()
        
    }
    
    func configureAccesibility() {
        tabBarController?.tabBar.backgroundColor = .white
        tabBarController?.tabBar.tintColor = .black
        
        
    }


}

