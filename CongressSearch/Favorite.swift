//
//  Favorite.swift
//  SlideMenuControllerSwift
//
//  Created by YuanX on 11/24/16.
//  
//

import Foundation
import SwiftyJSON

class Favorite {
    static var legislators = [JSON]()
    static var committees = [JSON]()
    static var bills = [JSON]()
    
    class func isFavLegislator(_ legislator: JSON) -> Bool {
        return legislators.contains(legislator)
    }
    
    class func isFavBill(_ bill: JSON) -> Bool {
        return bills.contains(bill)
    }
    
    class func isFavCommittee(_ committee: JSON) -> Bool {
        return committees.contains(committee)
    }
    
    class func getFavLegislators() -> [JSON] {
        legislators.sort(by: { $0["last_name"] < $1["last_name"] })
        return legislators
    }
    
    class func getFavCommittees() -> [JSON] {
        committees.sort(by: { $0["name"] < $1["name"] })
        return committees
    }
    
    class func getFavBills() -> [JSON] {
        bills.sort(by: { $0["introduced_on"] > $1["introduced_on"] })
        return bills
    }
    
    class func addLegilator(_ legislator: JSON) {
        legislators.append(legislator)
    }
    
    class func addCommittee(_ committee: JSON) {
        committees.append(committee)
    }
    
    class func addBill(_ bill: JSON) {
        bills.append(bill)
    }
    
    class func removeLegislator(_ legislator: JSON) {
        if let idx = legislators.index(of: legislator) {
            legislators.remove(at: idx)
        }
    }
    
    class func removeCommittee(_ committee: JSON) {
        if let idx = committees.index(of: committee) {
            committees.remove(at: idx)
        }
    }
    
    class func removeBill(_ bill: JSON) {
        if let idx = bills.index(of: bill) {
            bills.remove(at: idx)
        }
    }
}
