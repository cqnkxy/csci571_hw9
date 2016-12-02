//
//  CommitteeSenateViewController.swift
//  SlideMenuControllerSwift
//
//  Created by YuanX on 11/24/16.
//  
//


import UIKit
import SwiftyJSON
import Alamofire
import SwiftSpinner

class CommitteeSenateViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var searchController = UISearchController(searchResultsController: nil)
    var committees = [JSON]()
    var filteredCommittees = [JSON]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerCellNib(CommitteeTableViewCell.self)
        committeesGet()
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.showsCancelButton = false
        definesPresentationContext = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        SwiftSpinner.show("Fetching data...")
        if committees.count > 0 {
            SwiftSpinner.hide()
        }
    }
    
    func committeesGet() {
        Alamofire.request(Host.getCommitteeUrl()).responseJSON { response in
            if let value = (response.result.value) {
                let cs = (SwiftyJSON.JSON(value)[1]["results"]).arrayValue
                self.committees = cs
                self.committees.sort(by: { $0["name"] < $1["name"] })
                self.tableView.reloadData()
                print(self.committees[0])
            }
            SwiftSpinner.hide()
        }
    }
    
    func filteredCommitteesOnName(searchText: String) {
        filteredCommittees = committees.filter{committee in
            return committee["name"].stringValue.lowercased().contains(searchText.lowercased())
        }
        tableView.reloadData()
    }
    
    @IBAction func filterName(_ sender: UIBarButtonItem) {
        if navigationItem.titleView != nil {
            navigationItem.titleView = nil
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.search, target: self, action: #selector(filterName(_:)))
        } else {
            navigationItem.titleView = searchController.searchBar
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.stop, target: self, action: #selector(filterName(_:)))
        }
    }
    
    @IBAction func showLeft(_ sender: UIBarButtonItem) {
        self.slideMenuController()?.openLeft()
    }
    
}

/******************* search protocol ******************/

extension CommitteeSenateViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        searchController.searchBar.showsCancelButton = false
        filteredCommitteesOnName(searchText: searchController.searchBar.text!)
    }
}

/******************* #search protocol ******************/
/******************* table protocol ******************/

extension CommitteeSenateViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CommitteeTableViewCell.height()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "SubContentsViewController", bundle: nil)
        let subContentsVC = storyboard.instantiateViewController(withIdentifier: "CommitteeDetailViewController") as! CommitteeDetailViewController
        if searchController.isActive && searchController.searchBar.text != "" {
            subContentsVC.committee = filteredCommittees[indexPath.row]
        } else {
            subContentsVC.committee = committees[indexPath.row]
        }
        //        subContentsVC.title = "Committee Details"
        self.navigationController?.pushViewController(subContentsVC, animated: true)
    }
}

extension CommitteeSenateViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredCommittees.count
        } else {
            return committees.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: CommitteeTableViewCell.identifier) as! CommitteeTableViewCell
        let committee: JSON
        if searchController.isActive && searchController.searchBar.text != "" {
            committee = filteredCommittees[indexPath.row]
        } else {
            committee = committees[indexPath.row]
        }
        let data = CommitteeTableViewCellData(
            name: committee["name"].stringValue,
            id: committee["committee_id"].stringValue
        )
        cell.setData(data)
        return cell
    }
    
}
/******************* #table protocol ******************/
