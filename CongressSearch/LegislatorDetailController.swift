//
//  LegislatorDetailsController.swift
//  SlideMenuControllerSwift
//
//  Created by YuanX on 11/22/16.
//  
//

import UIKit
import SwiftyJSON
import SwiftSpinner

class LegislatorDetailController: UIViewController {
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var legislator: JSON = ""
    var tableContent = [LegislatorDetailCellData]()
    
    func initFavBtn() {
        let filledStar = UIBarButtonItem(image: UIImage(named: "ic_star_filled"), style: .plain, target: self, action: #selector(self.toggleFav))
        let emptyStar = UIBarButtonItem(image: UIImage(named: "ic_star_empty"), style: .plain, target: self, action: #selector(self.toggleFav))
        navigationItem.rightBarButtonItem = (Favorite.isFavLegislator(legislator) ? filledStar : emptyStar)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initFavBtn()
        self.tableView.registerCellNib(LegislatorDetailCell.self)
        img.downloadImage("https://theunitedstates.io/images/congress/225x275/\(legislator["bioguide_id"]).jpg")
        // Do any additional setup after loading the view.
        buildTableContent(tableContent: &tableContent, legislator: legislator)
        self.tableView.reloadData()
    }
    
    func toggleFav() {
        let filledStar = UIBarButtonItem(image: UIImage(named: "ic_star_filled"), style: .plain, target: self, action: #selector(self.toggleFav))
        let emptyStar = UIBarButtonItem(image: UIImage(named: "ic_star_empty"), style: .plain, target: self, action: #selector(self.toggleFav))
        print("Clicked Favorite")
        if Favorite.isFavLegislator(legislator) {
            Favorite.removeLegislator(legislator)
            navigationItem.rightBarButtonItem = emptyStar
        } else {
            Favorite.addLegilator(legislator)
            navigationItem.rightBarButtonItem = filledStar
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        SwiftSpinner.show("Fetching data...")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        SwiftSpinner.hide()
    }
    
    func emptyChecker(_ input: String) -> String {
        if input == "" {
            return "N.A"
        }
        return input
    }
    
    func buildTableContent(tableContent: inout [LegislatorDetailCellData], legislator: JSON){
        let twitter = legislator["twitter_id"].stringValue
        let facebook = legislator["facebook_id"].stringValue
        let fax = legislator["fax"].stringValue
        let website = legislator["website"].stringValue
        tableContent = [
            LegislatorDetailCellData(title: "First Name", content: legislator["first_name"].stringValue, link: ""),
            LegislatorDetailCellData(title: "Last Name", content: legislator["last_name"].stringValue, link: ""),
            LegislatorDetailCellData(title: "State", content: legislator["state_name"].stringValue, link: ""),
            LegislatorDetailCellData(title: "Birth date", content: legislator["birthday"].stringValue, link: ""),
            LegislatorDetailCellData(title: "Gender", content: legislator["gender"].stringValue == "M" ? "Male" : "Female", link: ""),
            LegislatorDetailCellData(title: "Chamber", content: legislator["chamber"].stringValue, link: ""),
            LegislatorDetailCellData(title: "Fax No.", content: emptyChecker(fax), link: ""),
            LegislatorDetailCellData(
                title: "Twitter",
                content: twitter != "" ? "Twitter Link" : "N.A.",
                link: twitter != "" ? "http://twitter.com/\(twitter)" : ""
            ),
            LegislatorDetailCellData(
                title: "Facebook",
                content: facebook != "" ? "Facebook Link" : "N.A.",
                link: facebook != "" ? "http://facebook.com/\(facebook)" : ""
            ),
            LegislatorDetailCellData(
                title: "Website",
                content: website != "" ? "Website Link" : "N.A.",
                link: website
            ),
            LegislatorDetailCellData(title: "Office No.", content: legislator["office"].stringValue, link: ""),
            LegislatorDetailCellData(title: "Term ends on", content: legislator["term_end"].stringValue, link: "")
        ]
    }
}

extension LegislatorDetailController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return LegislatorDetailCell.height()
    }
}

extension LegislatorDetailController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableContent.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cur = tableContent[indexPath.row]
        let data = LegislatorDetailCellData(title: cur.title, content: cur.content, link: cur.link)
        let cell = self.tableView.dequeueReusableCell(withIdentifier: LegislatorDetailCell.identifier) as! LegislatorDetailCell
        cell.setData(data)
        return cell
    }
}
