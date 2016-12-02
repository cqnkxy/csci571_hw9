//
//  CommitteeDetailViewController.swift
//  SlideMenuControllerSwift
//
//  Created by YuanX on 11/24/16.
//  
//

import UIKit
import SwiftyJSON
import SwiftSpinner

class CommitteeDetailViewController: UIViewController {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var committee: JSON = ""
    var tableContent = [CommitteeDetailCellData]()
    
    func initFavBtn() {
        let filledStar = UIBarButtonItem(image: UIImage(named: "ic_star_filled"), style: .plain, target: self, action: #selector(self.toggleFav))
        let emptyStar = UIBarButtonItem(image: UIImage(named: "ic_star_empty"), style: .plain, target: self, action: #selector(self.toggleFav))
        navigationItem.rightBarButtonItem = (Favorite.isFavCommittee(committee) ? filledStar : emptyStar)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerCellNib(CommitteeDetailCell.self)
        initFavBtn()
        name?.numberOfLines = 5
        name?.lineBreakMode = NSLineBreakMode.byWordWrapping
        name?.text = committee["name"].stringValue
        
        buildTableContent(tableContent: &tableContent, committee: committee)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        SwiftSpinner.show("Fetching data...")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        SwiftSpinner.hide()
    }
    
    func toggleFav() {
        let filledStar = UIBarButtonItem(image: UIImage(named: "ic_star_filled"), style: .plain, target: self, action: #selector(self.toggleFav))
        let emptyStar = UIBarButtonItem(image: UIImage(named: "ic_star_empty"), style: .plain, target: self, action: #selector(self.toggleFav))
        print("Clicked Favorite")
        if Favorite.isFavCommittee(committee) {
            Favorite.removeCommittee(committee)
            navigationItem.rightBarButtonItem = emptyStar
        } else {
            Favorite.addCommittee(committee)
            navigationItem.rightBarButtonItem = filledStar
        }
    }
    
    func emptyChecker(_ input: String) -> String {
        if input == "" {
            return "N.A"
        }
        return input
    }
    
    func buildTableContent(tableContent: inout [CommitteeDetailCellData], committee: JSON) {
        let parentId = committee["parent_committee_id"].stringValue
        let office = committee["office"].stringValue
        let contact = committee["phone"].stringValue
        tableContent = [
            CommitteeDetailCellData(title: "ID", content: committee["committee_id"].stringValue),
            CommitteeDetailCellData(title: "Parent ID", content: emptyChecker(parentId)),
            CommitteeDetailCellData(title: "Chamber", content: committee["chamber"].stringValue),
            CommitteeDetailCellData(title: "Office", content: emptyChecker(office)),
            CommitteeDetailCellData(title: "Contact", content: emptyChecker(contact))
        ]
    }
}

extension CommitteeDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CommitteeDetailCell.height()
    }
}

extension CommitteeDetailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableContent.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cur = tableContent[indexPath.row]
        let data = CommitteeDetailCellData(title: cur.title, content: cur.content)
        let cell = self.tableView.dequeueReusableCell(withIdentifier: CommitteeDetailCell.identifier) as! CommitteeDetailCell
        cell.setData(data)
        return cell
    }
}

