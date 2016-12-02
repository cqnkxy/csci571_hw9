//
//  LeftViewController.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 12/3/14.
//  Modified by Yuan Xue

import UIKit

enum LeftMenu: Int {
    case legislator = 0
    case bill
    case committee
    case favorite
    case about
}

protocol LeftMenuProtocol : class {
    func changeViewController(_ menu: LeftMenu)
}

class LeftViewController : UIViewController, LeftMenuProtocol {
    
    @IBOutlet weak var tableView: UITableView!
    var menus = ["Legislator", "Bill", "Committee", "Favorite", "About"]
    var mainViewController: UIViewController!
    var imageHeaderView: ImageHeaderView!
    var legislatorViewController: UITabBarController!
    var billViewController: UITabBarController!
    var committeeViewController: UITabBarController!
    var favoriteViewController: UITabBarController!
    var aboutViewController: UIViewController!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.separatorColor = UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1.0)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        let legislatorViewController = storyboard.instantiateViewController(withIdentifier: "LegislatorViewController") as! UITabBarController
        self.legislatorViewController = legislatorViewController
        
        let BillViewController = storyboard.instantiateViewController(withIdentifier: "BillViewController") as! UITabBarController
        self.billViewController = BillViewController
        
        let CommitteeController = storyboard.instantiateViewController(withIdentifier: "CommitteeViewController") as! UITabBarController
        self.committeeViewController = CommitteeController
        
        let FavoriteViewController = storyboard.instantiateViewController(withIdentifier: "FavoriteViewController") as! UITabBarController
        self.favoriteViewController = FavoriteViewController
        
        let AboutViewController = storyboard.instantiateViewController(withIdentifier: "AboutViewController")
        self.aboutViewController = AboutViewController
        
        self.tableView.registerCellClass(BaseTableViewCell.self)
        
        self.imageHeaderView = ImageHeaderView.loadNib()
        self.view.addSubview(self.imageHeaderView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.imageHeaderView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 100)
        self.view.layoutIfNeeded()
    }
    
    func changeViewController(_ menu: LeftMenu) {
        switch menu {
        case .legislator:
            self.slideMenuController()?.changeMainViewController(self.legislatorViewController, close: true)
        case .bill:
            self.slideMenuController()?.changeMainViewController(self.billViewController, close: true)
        case .committee:
            self.slideMenuController()?.changeMainViewController(self.committeeViewController, close: true)
        case .favorite:
            self.slideMenuController()?.changeMainViewController(self.favoriteViewController, close: true)
        case .about:
            self.slideMenuController()?.changeMainViewController(self.aboutViewController, close: true)
        }
    }
}

extension LeftViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let menu = LeftMenu(rawValue: indexPath.row) {
            switch menu {
            case .legislator, .bill, .committee, .favorite, .about:
                return BaseTableViewCell.height()
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let menu = LeftMenu(rawValue: indexPath.row) {
            self.changeViewController(menu)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.tableView == scrollView {
            
        }
    }
}

extension LeftViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menus.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let menu = LeftMenu(rawValue: indexPath.row) {
            switch menu {
            case .legislator, .bill, .committee, .favorite, .about:
                let cell = BaseTableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: BaseTableViewCell.identifier)
                cell.setData(menus[indexPath.row])
                return cell
            }
        }
        return UITableViewCell()
    }
}
