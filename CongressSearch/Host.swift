//
//  Host.swift
//  SlideMenuControllerSwift
//
//  Created by YuanX on 11/23/16.
//  
//

import Foundation

class Host {
    
    static let hostUrl = "http://awseb-e-b-awsebloa-1d89jtgy04u5-483814180.us-west-2.elb.amazonaws.com/"
    
    init() {}
    
    class func getHostUrl() -> String {
        return hostUrl
    }
    
    class func getLegislatorUrl() -> String {
        return hostUrl + "?legislators=true"
    }
    
    class func getBillUrl() -> String {
        return hostUrl + "?bills=true"
    }
    
    class func getCommitteeUrl() -> String {
        return hostUrl + "?committees=true"
    }
}
