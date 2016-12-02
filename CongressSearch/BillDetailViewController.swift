//
//  BillDetailViewController.swift
//  SlideMenuControllerSwift
//
//  Created by YuanX on 11/23/16.
//  
//

import UIKit
import SwiftyJSON
import SwiftSpinner

class BillDetailViewController: UIViewController {
    
    @IBOutlet weak var officialTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var bill: JSON = ""
    var tableContent = [BillDetailCellData]()
    
    func initFavBtn() {
        let filledStar = UIBarButtonItem(image: UIImage(named: "ic_star_filled"), style: .plain, target: self, action: #selector(self.toggleFav))
        let emptyStar = UIBarButtonItem(image: UIImage(named: "ic_star_empty"), style: .plain, target: self, action: #selector(self.toggleFav))
        navigationItem.rightBarButtonItem = (Favorite.isFavBill(bill) ? filledStar : emptyStar)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initFavBtn()
        self.tableView.registerCellNib(BillDetailCell.self)
        officialTitle?.numberOfLines = 5
        officialTitle?.lineBreakMode = NSLineBreakMode.byWordWrapping
        officialTitle?.text = bill["official_title"].stringValue
        buildTableContent(tableContent: &tableContent, bill: bill)
        SwiftSpinner.hide()
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
        print("Clicked Favorite bill")
        if Favorite.isFavBill(bill) {
            Favorite.removeBill(bill)
            navigationItem.rightBarButtonItem = emptyStar
        } else {
            Favorite.addBill(bill)
            navigationItem.rightBarButtonItem = filledStar
        }
    }
    
    func emptyChecker(_ input: String) -> String {
        if input == "" {
            return "N.A"
        }
        return input
    }
    
    func buildTableContent(tableContent: inout [BillDetailCellData], bill: JSON) {
        let pdf = bill["last_version"]["urls"]["pdf"].stringValue
        let active = bill["history"]["active"].boolValue ? "Active" : "New"
        tableContent = [
            BillDetailCellData(title: "Bill ID", content: bill["bill_id"].stringValue, link: ""),
            BillDetailCellData(title: "Bill Type", content: bill["bill_type"].stringValue, link: ""),
            BillDetailCellData(
                title: "Sponsor",
                content: "\(bill["sponsor"]["title"]) \(bill["sponsor"]["last_name"]),\(bill["sponsor"]["first_name"])",
                link: ""
            ),
            BillDetailCellData(
                title: "Last Action",
                content: emptyChecker(bill["last_action_at"].stringValue),
                link: ""
            ),
            BillDetailCellData(
                title: "PDF",
                content: emptyChecker(pdf),
                link: pdf
            ),
            BillDetailCellData(title: "Chamber", content: bill["chamber"].stringValue, link: ""),
            BillDetailCellData(title: "Last Vote", content: emptyChecker(bill["last_vote_at"].stringValue), link: ""),
            BillDetailCellData(title: "Status", content: active, link: "")
        ]
    }
}

extension BillDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return BillDetailCell.height()
    }
}

extension BillDetailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableContent.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cur = tableContent[indexPath.row]
        let data = BillDetailCellData(title: cur.title, content: cur.content, link: cur.link)
        let cell = self.tableView.dequeueReusableCell(withIdentifier: BillDetailCell.identifier) as! BillDetailCell
        cell.setData(data)
        return cell
    }
}
