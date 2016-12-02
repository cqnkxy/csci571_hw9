//
//  BillNewViewController.swift
//  SlideMenuControllerSwift
//
//  Created by YuanX on 11/23/16.
//  
//

//
//  BillNewViewController.swift
//  SlideMenuControllerSwift
//
//  Created by YuanX on 11/23/16.
//  
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftSpinner


class BillNewViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var searchController = UISearchController(searchResultsController: nil)
    var bills = [JSON]()
    var filteredBills = [JSON]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerCellNib(BillTableViewCell.self)
        billsGet()
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.showsCancelButton = false
        definesPresentationContext = true
    }
    
    func billsGet() {
        Alamofire.request(Host.getBillUrl()).responseJSON { response in
            if let value = (response.result.value) {
                let bs = (SwiftyJSON.JSON(value)[1]["results"]).arrayValue
                self.bills = bs
                self.bills.sort(by: { $0["introduced_on"] > $1["introduced_on"] })
                self.tableView.reloadData()
                print(self.bills[0])
            }
            SwiftSpinner.hide()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        SwiftSpinner.show("Fetching data...")
        if bills.count > 0 {
            SwiftSpinner.hide()
        }
    }
    
    func filteredBillsOnOfficialTitle(searchText: String) {
        filteredBills = bills.filter{bill in
            return bill["official_title"].stringValue.lowercased().contains(searchText.lowercased())
        }
        tableView.reloadData()
    }
    
    //MARK: Action
    
    @IBAction func filterOfficialTitle(_ sender: UIBarButtonItem) {
        if navigationItem.titleView != nil {
            navigationItem.titleView = nil
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.search, target: self, action: #selector(filterOfficialTitle(_:)))
        } else {
            navigationItem.titleView = searchController.searchBar
            searchController.searchBar.showsCancelButton = false
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.stop, target: self, action: #selector(filterOfficialTitle(_:)))
        }
    }
    
    @IBAction func showLeft(_ sender: UIBarButtonItem) {
        self.slideMenuController()?.openLeft()
    }
}


/******************* search protocol ******************/

extension BillNewViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        searchController.searchBar.showsCancelButton = false
        filteredBillsOnOfficialTitle(searchText: searchController.searchBar.text!)
    }
}

/******************* #search protocol ******************/
/******************* table protocol ******************/

extension BillNewViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return BillTableViewCell.height()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "SubContentsViewController", bundle: nil)
        let subContentsVC = storyboard.instantiateViewController(withIdentifier: "BillDetailViewController") as! BillDetailViewController
        if searchController.isActive && searchController.searchBar.text != "" {
            subContentsVC.bill = filteredBills[indexPath.row]
        } else {
            subContentsVC.bill = bills[indexPath.row]
        }
        self.navigationController?.pushViewController(subContentsVC, animated: true)
    }
}

extension BillNewViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredBills.count
        } else {
            return bills.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: BillTableViewCell.identifier) as! BillTableViewCell
        let bill: JSON
        if searchController.isActive && searchController.searchBar.text != "" {
            bill = filteredBills[indexPath.row]
        } else {
            bill = bills[indexPath.row]
        }
        let data = BillTableViewCellData(
            billId: bill["bill_id"].stringValue,
            title: bill["official_title"].stringValue,
            date: bill["introduced_on"].stringValue
        )
        cell.setData(data)
        return cell
    }
    
}
/******************* #table protocol ******************/
