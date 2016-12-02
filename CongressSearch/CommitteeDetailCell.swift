//
//  CommitteeDetailCell.swift
//  SlideMenuControllerSwift
//
//  Created by YuanX on 11/24/16.
//  
//


import UIKit
import SwiftyJSON

struct CommitteeDetailCellData {
    
    init(title: String, content: String) {
        self.title = title
        self.content = content
    }
    var title: String
    var content: String
}

class CommitteeDetailCell: BaseTableViewCell {
    
    @IBOutlet weak var dataTitle: UILabel!
    @IBOutlet weak var dataContent: UITextView!

    override func awakeFromNib() {
    }
    
    override class func height() -> CGFloat {
        return 40
    }
    
    override func setData(_ data: Any?) {
        if let data = data as? CommitteeDetailCellData {
            self.dataTitle.text = data.title
            self.dataContent.text = data.content
        }
    }
}
