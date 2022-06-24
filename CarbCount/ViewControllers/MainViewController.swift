//
//  MainViewController.swift
//  CarbCount
//
//  Created by SH Developer on 12.05.2022.
//

import UIKit
import RealmSwift

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lastFeedItemLabel: UILabel!
    @IBOutlet weak var greetingLabel: UILabel!
    @IBOutlet weak var circularView: UIView!
    @IBOutlet weak var remainingCarbLabel: UILabel!
    @IBOutlet weak var carbDescriptionLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    let viewModel = MainViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        setupUI()
        let cp = CircularProgressView(frame: CGRect(x: 10.0, y: 10.0, width: 350.0, height: 350.0))
        cp.trackColor = UIColor(red: 116/255.0, green: 200/255.0, blue: 63/255.0, alpha: 1.00)
        cp.progressColor = UIColor(red: 238/255.0, green: 156/255.0, blue: 94/255.0, alpha: 1.00)
        cp.tag = 101
        self.circularView.addSubview(cp)
        //cp.progressLayer.strokeEnd = 0.8
        Store.shared.consumedCarbCount = 0.0
        remainingCarbLabel.text = "\(Int(Store.shared.consumedCarbCount)) gr / \(Int(Store.shared.dailyCarbCount)) gr"
        
    }
    
    @objc func animateProgress() {
        let cP = self.view.viewWithTag(101) as! CircularProgressView
        cP.setProgressWithAnimation(duration: 1.0, value: 1 / Float((Store.shared.dailyCarbCount / Store.shared.consumedCarbCount)))
    }
    override func viewWillAppear(_ animated: Bool) {
        self.view.layoutIfNeeded()
        self.tableView.reloadData()
        DispatchQueue.main.async(execute: {
            self.greetingLabel.text = "Hoşgeldin \(Store.shared.name) !"
            self.perform(#selector(self.animateProgress), with: nil, afterDelay: 0.2)
            self.remainingCarbLabel.text = "\(Int(Store.shared.consumedCarbCount)) gr / \(Int(Store.shared.dailyCarbCount)) gr"
            self.resetConsumedCarb()
            if Store.shared.consumedCarbCount > Store.shared.dailyCarbCount {
                self.remainingCarbLabel.textColor = .red
                self.carbDescriptionLabel.textColor = .red
            }
        })
    }
    
    func setupUI() {
        configureAccesibility()
        setupNavBar()
        setupDateLabel()
    }
    
    func configureAccesibility() {
        lastFeedItemLabel.text = viewModel.lastFeedLabel
        carbDescriptionLabel.text = "Tüketilen Karbonhidrat Miktarı"
       
    }
    
    func setupDateLabel() {
        let date = Date()
        let dateFormatter = DateFormatter()
         
        dateFormatter.dateFormat = "dd.MM.yyyy"
         
        let result = dateFormatter.string(from: date)
        dateLabel.text = result
    }
    
    func setupNavBar() {
        let barAppearance = UINavigationBarAppearance()
        barAppearance.backgroundColor = UIColor(red: 198/255.0, green: 80/255.0, blue: 90/255.0, alpha: 1.00)

        barAppearance.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.black]
        
        navigationItem.standardAppearance = barAppearance
        navigationItem.scrollEdgeAppearance = barAppearance
     
        self.navigationItem.title = "Anasayfa"
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    func convertBase64StringToImage (imageBase64String:String) -> UIImage {
        let imageData = Data(base64Encoded: imageBase64String)
        let image = UIImage(data: imageData!)
        return image!
    }
    
    func resetConsumedCarb() {
        let resetTime = "235959"
        let date = Date()
        let calendar = Calendar.current

        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
    
        let currentTime = "\(hour)\(minutes)\(seconds)"
        if currentTime == resetTime {
            Store.shared.consumedCarbCount = 0.0
            remainingCarbLabel.text = "\(Int(Store.shared.consumedCarbCount)) gr / \(Int(Store.shared.dailyCarbCount)) gr"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  Store.shared.mealData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mealCell",for: indexPath) as! MealTableViewCell
        cell.selectionStyle = .none
        var index = Store.shared.mealData.count - indexPath.row - 1
        cell.foodNameLabel.text = Store.shared.mealData[index].foodName
        cell.carbResultLabel.text =  Store.shared.mealData[index].carbCount
        cell.foodDateLabel.text =  Store.shared.mealData[index].foodDateTime
        cell.foodCountLabel.text =  Store.shared.mealData[index].foodCount
        cell.foodImageView.image = convertBase64StringToImage(imageBase64String: Store.shared.mealData[index].foodImage)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }


}

