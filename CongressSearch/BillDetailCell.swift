//
//  BillDetailCell.swift
//  SlideMenuControllerSwift
//
//  Created by YuanX on 11/23/16.
//  
//

import UIKit

struct BillDetailCellData {
    
    init(title: String, content: String, link: String) {
        self.title = title
        self.content = content
        self.link = link
    }
    var title: String
    var content: String
    var link: String
}

class BillDetailCell: BaseTableViewCell {
    
    @IBOutlet weak var dataTitle: UILabel!
    @IBOutlet weak var dataContent: UITextView!
    
    var clickable = false
    
    override func awakeFromNib() {
    }
    
    override class func height() -> CGFloat {
        return 40
    }
    
    override func setData(_ data: Any?) {
        if let data = data as? BillDetailCellData {
            self.dataTitle.text = data.title
            if data.link != "" {
                let attributedString = NSMutableAttributedString(string: data.content)
                attributedString.addAttribute(NSLinkAttributeName, value: data.link, range: NSRange(location: 0, length: data.content.length))
                self.dataContent.attributedText = attributedString
                self.dataContent.isSelectable = true
                self.dataContent.isUserInteractionEnabled = true
                clickable = true
            } else {
                self.dataContent.text = data.content
            }
        }
    }
}

extension BillDetailCell: UITextViewDelegate{
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        print("link: \(URL)")
        if clickable {
            UIApplication.shared.open(URL, options: [:])
        }
        return true
    }
}
