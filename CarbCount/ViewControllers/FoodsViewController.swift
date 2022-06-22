//
//  FoodsViewController.swift
//  CarbCount
//
//  Created by SH Developer on 12.05.2022.
//

import UIKit
import RealmSwift

class FoodsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchResultsUpdating {
    
    var tempData = [Any]()
    var testData: [Int] = []
    struct CellItems {
        let foodName: String
        let foodImage: String
        let carbPerSession: Int
        let carbPerGram: Double
        let enabledAmountTypes: [Int]
    }
//
//    struct MealItems {
//        let foodName: String
//        let carbCount: String
//        let foodDateTime: String
//        let foodCount: String
//    }
    
    static var foodData: [CellItems] = [
        CellItems(foodName: "Yoğurt", foodImage: "food-yogurt", carbPerSession: 100, carbPerGram: 0.05, enabledAmountTypes: [0,1,3]),
        CellItems(foodName: "Makarna", foodImage: "food-makarna", carbPerSession: 100, carbPerGram: 0.3, enabledAmountTypes: [1]),
        CellItems(foodName: "Ispanak", foodImage: "food-ispanak", carbPerSession: 100, carbPerGram: 0.6, enabledAmountTypes: [2]),
        CellItems(foodName: "Ayran", foodImage: "food-ayran",carbPerSession: 100, carbPerGram: 0.05, enabledAmountTypes: [3])
    ]
    
//    static var mealData: [MealItems] = []
    
    var filteredData = [CellItems]()
    
    @IBOutlet weak var table: UITableView!
    
    let searchController = UISearchController()
    
    func initSearchController() {
        searchController.loadViewIfNeeded()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.enablesReturnKeyAutomatically = false
        searchController.searchBar.returnKeyType = UIReturnKeyType.done
        definesPresentationContext = true
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(foodAppendButtonTapped))
        searchController.searchBar.delegate = self
        searchController.searchBar.tintColor = .red
        searchController.searchBar.searchTextField.textColor = .white
        searchController.searchBar.searchTextField.placeholder = "Bugün ne yedin?"
        searchController.searchBar.value(forKey: "searchField")
        if let textfield = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            textfield.backgroundColor = UIColor(red: 198/255.0, green: 80/255.0, blue: 90/255.0, alpha: 1.00)
            textfield.attributedPlaceholder = NSAttributedString(string: textfield.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black])
            textfield.textColor = UIColor.black
            if let leftView = textfield.leftView as? UIImageView {
                leftView.image = leftView.image?.withRenderingMode(.alwaysTemplate)
                leftView.tintColor = UIColor.black
            }
        }
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = "Vazgeç"
        UIBarButtonItem.appearance().tintColor = .black
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getFoodData()
        table.dataSource = self
        table.delegate = self
        initSearchController()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        table.reloadData()
    }
    
    func getFoodData() {
        app.login(credentials: Credentials.anonymous) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    print("Login failed: \(error)")
                case .success(let user):
                    print("Login as \(user) succeeded!")
                    // Continue below
                }
            
                // mongodb-atlas is the cluster service name
                let client = app.currentUser!.mongoClient("mongodb-atlas")
                // Select the database
                let database = client.database(named: "userTest")
                // Select the collection
                let collection = database.collection(withName: "foodTable")
            
                collection.find(filter: Document()) { result in
                    switch result {
                    case .failure(let error):
                        print("Did not find matching documents: \(error.localizedDescription)")
                        return
                    case .success(let documents):
                        var temp = 0
                        for document in documents {
                            if let arrayTest = document["enabledAmountTypes"]! {
                                for i in 0...Int(arrayTest.arrayValue!.count - 1) {
                                    self.testData.append(Int(arrayTest.arrayValue![i]!.int32Value ?? 0))
                                }
                            }
                            if let foodName = document["FoodName"]! {
                                self.tempData.append((String(describing: foodName.stringValue!)))
                            }
                            if let carbPerSession = document["CarbPerSession"]! {
                                self.tempData.append(carbPerSession.doubleValue ?? 0)
                            }
                            if let carbPerGram = document["CarbPerGram"]! {
                                self.tempData.append(carbPerGram.doubleValue ?? 0)
                            }

                            FoodsViewController.foodData.append(CellItems(foodName: self.tempData[temp] as! String, foodImage: self.tempData[temp] as! String, carbPerSession: Int(self.tempData[temp + 1] as! Double), carbPerGram: Double(self.tempData[temp + 2] as! Double), enabledAmountTypes: self.testData))
                            self.testData = []
                            temp += 3
                        }
                    }
                }
            }
        }
    }
    
    @objc func foodAppendButtonTapped() {
        let viewController = FoodAppendViewController()
        present(viewController, animated: true, completion: nil)
    }
    
    func currentTime() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "HH:mm"
        let currentTime = dateFormatter.string(from: date)

        return currentTime
    }
    
    func setupUI() {
        setupNavBar()
    }
    
    func setupNavBar() {
        let barAppearance = UINavigationBarAppearance()
        barAppearance.backgroundColor = UIColor(red: 198/255.0, green: 80/255.0, blue: 90/255.0, alpha: 1.00)
        barAppearance.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.black]
        
        navigationItem.standardAppearance = barAppearance
        navigationItem.scrollEdgeAppearance = barAppearance
     
        self.navigationItem.title = "Besinler"
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive {
            return filteredData.count
        } else {
            return FoodsViewController.foodData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let foodItems: CellItems!
        if searchController.isActive {
            foodItems = filteredData[indexPath.row]
        } else {
            foodItems = FoodsViewController.foodData[indexPath.row]
        }
        
        let cell = table.dequeueReusableCell(withIdentifier: "cell",for: indexPath) as! FoodTableViewCell
        cell.selectionStyle = .none
        cell.carbResult.text = String(describing: foodItems.carbPerGram)
        cell.foodImageView.image = UIImage(named: foodItems.foodImage)
        cell.foodName.text = foodItems.foodName
        cell.tapHandler = { [weak self] in
            
            Store.shared.mealData.append(Store.MealItems(foodName: FoodsViewController.foodData[indexPath.row].foodName, carbCount: cell.carbResult.text ?? "", foodDateTime: self!.currentTime(), foodCount: "\(cell.foodCountTextField.text ?? "") \(cell.titleLabel.text!.lowercased())", foodImage: FoodsViewController.foodData[indexPath.row].foodImage))
        }
        cell.addHandler = { [weak self] in
            if Store.shared.consumedCarbCount > Store.shared.dailyCarbCount {
                let dialogMessage = UIAlertController(title: "Yemek Başarıyla Eklendi", message: "Günlük karbonhidrat miktarınızı aştınız. Lütfen dikkat ediniz.", preferredStyle: .alert)
                let ok = UIAlertAction(title: "Tamam", style: .default, handler: { (action) -> Void in
                    print("Count button tapped")
                 })
                dialogMessage.addAction(ok)
                self!.present(dialogMessage, animated: true, completion: nil)
            } else {
                let dialogMessage = UIAlertController(title: "Yemek Başarıyla Eklendi", message: "", preferredStyle: .alert)
                let ok = UIAlertAction(title: "Tamam", style: .default, handler: { (action) -> Void in
                    print("Count button tapped")
                 })
                dialogMessage.addAction(ok)
                
                self!.present(dialogMessage, animated: true, completion: nil)
            }
            
            cell.calculateCarb.backgroundColor = UIColor(red: 42/255.0, green: 88/255.0, blue: 80/255.0, alpha: 1.00)
            cell.calculateCarb.isUserInteractionEnabled = false
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let searchText = searchBar.text!
        
        filterForSearchTextAndScopeButton(searchText: searchText)
    }
    
    func filterForSearchTextAndScopeButton(searchText: String) {
        filteredData = FoodsViewController.foodData.filter {
            temp in
            let searchTextMatch = temp.foodName.lowercased().contains(searchText.lowercased())
            
            return searchTextMatch

        }
        table.reloadData()
    }
}
