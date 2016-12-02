//
//  BillViewCell.swift
//  SlideMenuControllerSwift
//
//  Created by YuanX on 11/23/16.
//  
//

import UIKit

struct BillTableViewCellData {
    init(billId: String, title: String, date: String) {
        self.id = billId
        self.title = title
        self.date = date
    }
    var id: String
    var title: String
    var date: String
}

class BillTableViewCell: BaseTableViewCell {
    
    @IBOutlet weak var id: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var date: UILabel!
    let dateFormatter = DateFormatter()

    override func awakeFromNib() {
        self.id?.font = UIFont.boldSystemFont(ofSize: 13)
        self.title?.font = UIFont.systemFont(ofSize: 13)
        self.date?.font = UIFont.systemFont(ofSize: 13)
        self.title?.numberOfLines = 3
        self.title?.lineBreakMode = NSLineBreakMode.byCharWrapping
    }
    
    override class func height() -> CGFloat {
        return 80
    }
    
    override func setData(_ data: Any?) {
        if let data = data as? BillTableViewCellData {
            self.id.text = data.id
            self.title.text = data.title
            self.date.text = data.date
        }
    }
}
