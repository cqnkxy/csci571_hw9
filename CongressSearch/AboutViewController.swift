//
//  AboutViewController.swift
//  SlideMenuControllerSwift
//
//  Created by YuanX on 11/24/16.
//  
//

import UIKit

class AboutViewController: UIViewController {

    @IBOutlet weak var author: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        author.image = UIImage(named: "author")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Action
    @IBAction func showLeft(_ sender: UIBarButtonItem) {
        self.slideMenuController()?.openLeft()
    }
}
