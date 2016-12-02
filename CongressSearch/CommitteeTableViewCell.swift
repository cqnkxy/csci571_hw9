//
//  CommitteeTableViewCell.swift
//  SlideMenuControllerSwift
//
//  Created by YuanX on 11/24/16.
//  
//

//
//  BaseTableViewCell.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 1/22/15.
//  Copyright (c) 2015 Yuji Hato. All rights reserved.
//
import UIKit


struct CommitteeTableViewCellData {
    init(name: String, id: String) {
        self.id = id
        self.name = name
    }
    var name: String
    var id: String
}

class CommitteeTableViewCell: BaseTableViewCell {
    
    @IBOutlet weak var id: UILabel!
    @IBOutlet weak var name: UILabel!
    
    override func awakeFromNib() {
        self.id?.font = UIFont.systemFont(ofSize: 13)
        self.name?.font = UIFont.systemFont(ofSize: 13)
    }
    
    override class func height() -> CGFloat {
        return 40
    }
    
    override func setData(_ data: Any?) {
        if let data = data as? CommitteeTableViewCellData {
            self.id.text = data.id
            self.name.text = data.name
        }
    }
}
