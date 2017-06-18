//
//  BaseNavController.swift
//  es_club
//
//  Created by 岳业骑 on 2017/5/31.
//  Copyright © 2017年 岳业骑. All rights reserved.
//

import UIKit

class BaseNavController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        
        self.navigationBar.isTranslucent = false
        self.navigationBar.barTintColor = UIColor.DefalutColor()
        self.navigationBar.backgroundColor = UIColor.white
        self.navigationItem.hidesBackButton = true

        UINavigationBar.appearance().tintColor = UIColor.white
        
        let navAtt = NSDictionary(objects: [UIColor.white], forKeys: [NSForegroundColorAttributeName as NSCopying])
        self.navigationBar.titleTextAttributes = navAtt as? [String : Any]
        
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        viewController.hidesBottomBarWhenPushed = true
        
        let newBackButton = UIBarButtonItem(image: #imageLiteral(resourceName: "leftArrow"), style: .plain, target: self, action: #selector(back))
        viewController.navigationItem.leftBarButtonItem = newBackButton
        viewController.navigationController?.navigationBar.tintColor = UIColor.white
        super.pushViewController(viewController, animated: true)
    }
    
    func back() {
        self.popViewController(animated: true)
    }

}
