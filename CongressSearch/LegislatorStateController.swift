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


let usStates = [
    "ALL STATES",
    "ALABAMA",
    "ALASKA",
    "ARIZONA",
    "ARKANSAS",
    "CALIFORNIA",
    "COLORADO",
    "CONNECTICUT",
    "DELAWARE",
    "FLORIDA",
    "GEORGIA",
    "HAWAII",
    "IDAHO",
    "ILLINOIS",
    "INDIANA",
    "IOWA",
    "KANSAS",
    "KENTUCKY",
    "LOUISIANA",
    "MAINE",
    "MARYLAND",
    "MASSACHUSETTS",
    "MICHIGAN",
    "MINNESOTA",
    "MISSISSIPPI",
    "MISSOURI",
    "MONTANA",
    "NEBRASKA",
    "NEVADA",
    "NEW HAMPSHIRE",
    "NEW JERSEY",
    "NEW MEXICO",
    "NEW YORK",
    "NORTH CAROLINA",
    "NORTH DAKOTA",
    "OHIO",
    "OKLAHOMA",
    "OREGON",
    "PENNSYLVANIA",
    "RHODE ISLAND",
    "SOUTH CAROLINA",
    "SOUTH DAKOTA",
    "TENNESSEE",
    "TEXAS",
    "UTAH",
    "VERMONT",
    "VIRGINIA",
    "WASHINGTON",
    "WEST VIRGINIA",
    "WISCONSIN",
    "WYOMING"
]


func buildIndex(legislators: [JSON]) -> ([String: [JSON]], [String]) {
    var results = [String: [JSON]]()
    var indices = [String]()
    for l in legislators {
        let state = l["state_name"].stringValue
        let initial = state[state.startIndex...state.startIndex]
        if results[initial] == nil {
            results[initial] = [JSON]()
        }
        if !indices.contains(initial) {
            indices.append(initial)
        }
        results[initial]?.append(l)
    }
    indices.sort(by: {$0 < $1} )
    return (results, indices)
}


class LegislatorStateController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var picker: UIPickerView!

    var legislators = [JSON]()
    var selectedState = "ALL STATES"
    var pickedLegislators = [String: [JSON]]()
    var indices = [String]()
    var subView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerCellNib(LegislatorTableViewCell.self)
        legislatorGet()
        picker.isHidden = true
        picker.isUserInteractionEnabled = true
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
                var ls = (SwiftyJSON.JSON(value)["results"]).arrayValue
                ls.sort(by: { $0["last_name"] < $1["last_name"] })
                self.legislators = ls
                (self.pickedLegislators, self.indices) = buildIndex(legislators: ls)
                self.tableView.reloadData()
                print("\(ls[0])")
            }
            SwiftSpinner.hide()
        }
    }
    
    //MARK: Action
    @IBAction func showPicker(_ sender: UIBarButtonItem) {
        picker.isHidden = !picker.isHidden
    }
    
    @IBAction func showLeft(_ sender: UIBarButtonItem) {
        self.slideMenuController()?.openLeft()
    }
}


/******************* picker protocol ******************/
extension LegislatorStateController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return usStates.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return usStates[row]
    }
}

extension LegislatorStateController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedState = usStates[row]
        var pls = [JSON]()
        // filter by state_name
        for l in legislators {
            if self.selectedState.uppercased() == "ALL STATES" {
                pls.append(l)
            }else if l["state_name"].stringValue.uppercased() == self.selectedState.uppercased() {
                pls.append(l)
            }
        }
        (pickedLegislators, indices) = buildIndex(legislators: pls)
        pickerView.isHidden = true
        self.tableView.reloadData()
    }
}

/******************* #picker protocol ******************/
/******************* table protocol ******************/

extension LegislatorStateController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return LegislatorTableViewCell.height()
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return indices
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "SubContentsViewController", bundle: nil)
        let subContentsVC = storyboard.instantiateViewController(withIdentifier: "LegislatorDetailController") as! LegislatorDetailController
        subContentsVC.legislator = pickedLegislators[indices[indexPath.section]]![indexPath.row]
        self.navigationController?.pushViewController(subContentsVC, animated: true)
    }
}

extension LegislatorStateController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return pickedLegislators.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return indices[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pickedLegislators[indices[section]]!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: LegislatorTableViewCell.identifier) as! LegislatorTableViewCell
        let legislator = pickedLegislators[indices[indexPath.section]]?[indexPath.row]
        let data = LegislatorTableViewCellData(
            imageUrl: "http://theunitedstates.io/images/congress/225x275/\(legislator!["bioguide_id"]).jpg",
            name: "\(legislator!["last_name"]) \(legislator!["first_name"])",
            state: "\(legislator!["state_name"])"
        )
        cell.setData(data)
        return cell
    }
    
}
/******************* #table protocol ******************/
