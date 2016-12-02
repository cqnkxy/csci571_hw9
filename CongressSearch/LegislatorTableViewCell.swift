//
//  LegislatorViewCell.swift
//  SlideMenuControllerSwift
//
//  Created by YuanX on 11/22/16.
//  
//

import Foundation

//
//  DataTableViewCell.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 11/8/15.
//  Copyright © 2015 Yuji Hato. All rights reserved.
//

import UIKit

struct LegislatorTableViewCellData {
    
    init(imageUrl: String, name: String, state: String) {
        self.imageUrl = imageUrl
        self.name = name
        self.state = state
    }
    var imageUrl: String
    var name: String
    var state: String
}

class LegislatorTableViewCell : BaseTableViewCell {
    
    @IBOutlet weak var dataImage: UIImageView!
    @IBOutlet weak var dataName: UILabel!
    @IBOutlet weak var dataState: UILabel!

    
    override func awakeFromNib() {
        self.dataName?.font = UIFont.boldSystemFont(ofSize: 12)
        self.dataState?.font = UIFont.italicSystemFont(ofSize: 10)
    }
    
    override class func height() -> CGFloat {
        return 40
    }
    
    override func setData(_ data: Any?) {
        if let data = data as? LegislatorTableViewCellData {
            self.dataImage.downloadImage(data.imageUrl)
            self.dataName.text = data.name
            self.dataState.text = data.state
        }
    }
}
