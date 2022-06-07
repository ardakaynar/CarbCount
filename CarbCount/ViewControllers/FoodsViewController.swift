//
//  FoodsViewController.swift
//  CarbCount
//
//  Created by SH Developer on 12.05.2022.
//

import UIKit
import RealmSwift

class FoodsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchResultsUpdating {
    
    class FoodItems: Object {
        @Persisted(primaryKey: true) var _id: ObjectId
        @Persisted var foodName = ""
        @Persisted var imageName = ""
        @Persisted var carbResult = ""
        convenience init(carbResult: String, imageName: String, foodName: String) {
            self.init()
            self.foodName = foodName
            self.carbResult = carbResult
            self.imageName = imageName
        }

    }

    
    struct CellItems {
        let foodName: String
        let imageName: String
        let carbResult: String
    }
    
    let foodData: [CellItems] = [
        CellItems(foodName: "Sütaş Yarım Yağlı Süt", imageName: "sample_product", carbResult: "100"),
        CellItems(foodName: "Makarna", imageName: "sample_product", carbResult: "200"),
        CellItems(foodName: "Ispanak", imageName: "sample_product", carbResult: "300"),
        CellItems(foodName: "Ayran", imageName: "sample_product", carbResult: "400"),
        CellItems(foodName: "Tavuk Dürüm", imageName: "sample_product", carbResult: "500"),
        CellItems(foodName: "Makarna", imageName: "sample_product", carbResult: "200"),
        CellItems(foodName: "Ispanak", imageName: "sample_product", carbResult: "300"),
        CellItems(foodName: "Ayran", imageName: "sample_product", carbResult: "400"),
        CellItems(foodName: "Tavuk Dürüm", imageName: "sample_product", carbResult: "500")
    ]
    
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
        searchController.searchBar.delegate = self
        searchController.searchBar.tintColor = .red
        searchController.searchBar.searchTextField.textColor = .white
        searchController.searchBar.searchTextField.placeholder = "Bugün ne yedin?"
        searchController.searchBar.value(forKey: "searchField")
        if let textfield = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            textfield.backgroundColor = UIColor.systemBlue
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
        table.dataSource = self
        table.delegate = self
        initSearchController()
        setupUI()
        
     
        app.login(credentials: Credentials.anonymous) { (result) in
            // Remember to dispatch back to the main thread in completion handlers
            // if you want to do anything on the UI.
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
                let collection = database.collection(withName: "userId")
                let test: Document = ["DeviceModel": "iPhone12,1"]
                let drink: Document = ["Username": "GOKAYS-PC#HBFGBR", "DeviceModel": "iPhone12,1", "_id": "898b1168124175aeb40d95e0e573e83e4d20c293"]
                let drink2: Document = ["Username": "GOKAYbbbbbbbS-PC#HBFGBR", "DeviceModel": "iPhone12,1", "_id": "32142512421412312"]
                let drink3: Document = ["Username": "GOKAYaaaaaaaS-PC#HBFGBR", "DeviceModel": "iPhone12,1", "_id": "tr12451241241231231252ue"]
                collection.find(filter: test) { result in
                    switch result {
                    case .failure(let error):
                        print("Did not find matching documents: \(error.localizedDescription)")
                        return
                    case .success(let documents):
                        print("Found a matching document: \(documents)")
                        for document in documents {
                            print("Coffee drink: \(document)")
                        }
                    }
                }
                collection.insertOne(drink2) { result in
                    switch result {
                    case .failure(let error):
                        print("Call to MongoDB failed: \(error.localizedDescription)")
                        return
                    case .success(let objectId):
                        // Success returns the objectId for the inserted document
                        print("Successfully inserted a document with id: \(objectId)")
                    }
                }
                // Insert the documents into the collection
                collection.insertMany([drink2, drink3]) { result in
                    switch result {
                    case .failure(let error):
                        print("Call to MongoDB failed: \(error.localizedDescription)")
                        return
                    case .success(let objectIds):
                        print("Successfully inserted \(objectIds.count) new documents.")
                    }
                }
            }
        }
        
    }
    
    func setupUI() {
        setupNavBar()
    }
    
    func setupNavBar() {
        let barAppearance = UINavigationBarAppearance()
        barAppearance.backgroundColor = .systemBlue
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
            return foodData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let foodItems: CellItems!
        if searchController.isActive {
            foodItems = filteredData[indexPath.row]
        } else {
            foodItems = foodData[indexPath.row]
        }
        
        let cell = table.dequeueReusableCell(withIdentifier: "cell",for: indexPath) as! FoodTableViewCell
        cell.carbResult.text = foodItems.carbResult
        cell.foodImageView.image = UIImage(named: foodItems.imageName)
        cell.foodName.text = foodItems.foodName
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
        filteredData = foodData.filter {
            temp in
            let searchTextMatch = temp.foodName.lowercased().contains(searchText.lowercased())
            
            return searchTextMatch

        }
        table.reloadData()
    }
}
