//
//  TabBarContoroller.swift
//  MyFinalApp
//
//  Created by VERTEX24 on 2019/08/24.
//  Copyright © 2019 VERTEX24. All rights reserved.
//

import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self // UITabBarControllerDelegate
    }
}

// MARK: - UITabBarControllerDelegateに適合
extension TabBarController: UITabBarControllerDelegate {
    // TabBarItemが選択された時に呼ばれる
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        // TabBarItemタップでModal表示をする画面を指定して実装
        if viewController is TargetViewController {
            if let newVC = UIStoryboard(name: "Target", bundle: nil).instantiateInitialViewController() {
                tabBarController.present(newVC, animated: true, completion: nil)
                return false
            }
        }
        return true
    }
}
