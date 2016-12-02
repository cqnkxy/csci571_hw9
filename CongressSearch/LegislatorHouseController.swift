//
//  LegislatorStateController.swift
//  SlideMenuControllerSwift
//
//  Created by YuanX on 11/22/16.
//  
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftSpinner


class LegislatorHouseController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!

    var searchController = UISearchController(searchResultsController: nil)
    var legislators = [JSON]()
    var pickedLegislators = [JSON]()
    var filteredLegislators = [JSON]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerCellNib(LegislatorTableViewCell.self)
        legislatorGet()
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.showsCancelButton = false
        definesPresentationContext = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        SwiftSpinner.show("Fetching data...")
        if legislators.count > 0 {
            SwiftSpinner.hide()
        }
    }
    
    func legislatorGet() {
        Alamofire.request(Host.getLegislatorUrl()).responseJSON { response in
            if let value = (response.result.value) {
                let ls = (SwiftyJSON.JSON(value)["results"]).arrayValue
                for l in ls {
                    if l["chamber"].stringValue == "house" {
                        self.legislators.append(l)
                    }
                }
                self.legislators.sort(by: { $0["last_name"] < $1["last_name"] })
                self.tableView.reloadData()
            }
            SwiftSpinner.hide()
        }
    }
    
    func filteredLegislatorsOnFirstName(searchText: String) {
        filteredLegislators = legislators.filter{legislator in
            return legislator["first_name"].stringValue.lowercased().contains(searchText.lowercased())
        }
        tableView.reloadData()
    }
    
    //MARK: Action
    @IBAction func showLeft(_ sender: UIBarButtonItem) {
        self.slideMenuController()?.openLeft()
    }
    
    @IBAction func filterFirstName(_ sender: UIBarButtonItem) {
        if navigationItem.titleView != nil {
            navigationItem.titleView = nil
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.search, target: self, action: #selector(filterFirstName(_:)))
        } else {
            navigationItem.titleView = searchController.searchBar
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.stop, target: self, action: #selector(filterFirstName(_:)))
        }
    }
}


/******************* search protocol ******************/

extension LegislatorHouseController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        searchController.searchBar.showsCancelButton = false
        filteredLegislatorsOnFirstName(searchText: searchController.searchBar.text!)
     }
}

/******************* #search protocol ******************/
/******************* table protocol ******************/

extension LegislatorHouseController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return LegislatorTableViewCell.height()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "SubContentsViewController", bundle: nil)
        let subContentsVC = storyboard.instantiateViewController(withIdentifier: "LegislatorDetailController") as! LegislatorDetailController
        if searchController.isActive && searchController.searchBar.text != "" {
                subContentsVC.legislator = filteredLegislators[indexPath.row]
        } else {
                subContentsVC.legislator = legislators[indexPath.row]
        }
        self.navigationController?.pushViewController(subContentsVC, animated: true)
    }
}

extension LegislatorHouseController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredLegislators.count
        } else {
            return legislators.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: LegislatorTableViewCell.identifier) as! LegislatorTableViewCell
        let legislator: JSON
        if searchController.isActive && searchController.searchBar.text != "" {
            legislator = filteredLegislators[indexPath.row]
        } else {
            legislator = legislators[indexPath.row]
        }
        let data = LegislatorTableViewCellData(
            imageUrl: "http://theunitedstates.io/images/congress/225x275/\(legislator["bioguide_id"]).jpg",
            name: "\(legislator["last_name"]) \(legislator["first_name"])",
            state: "\(legislator["state_name"])"
        )
        cell.setData(data)
        return cell
    }
    
}
/******************* #table protocol ******************/
