//
//  FoodsViewController.swift
//  CarbCount
//
//  Created by SH Developer on 12.05.2022.
//

import UIKit

class FoodsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchResultsUpdating {


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
