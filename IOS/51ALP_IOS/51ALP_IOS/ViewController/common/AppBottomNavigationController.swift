//
//  AppBottomNavigationController.swift
//  51ALP_IOS
//
//  Created by xiu on 1/30/19.
//  Copyright © 2019 wma. All rights reserved.
//

import UIKit
import Material
import Motion

class AppBottomNavigationController: BottomNavigationController,UITabBarControllerDelegate {
 
    
    
    open override func prepare() {
        
        
        super.prepare()
        isMotionEnabled = true
        motionTabBarTransitionType = .autoReverse(presenting: .pull(direction: .left))
        prepareTabBar()
        self.delegate = self
       
        
        
    }
    
    
    
    public func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController){
        
        let tabBarIndex = tabBarController.selectedIndex
        
//        viewController.navigationController?.popToRootViewController(animated: true)
//        viewController.dismiss(animated: false, completion: {
//            viewController.navigationController?.popToRootViewController(animated: true)
//
//        })
        
        if tabBarIndex == 2 {
            
            UserService.shared.processStatus = 0
        }
        print("tabBarIndex\(tabBarIndex)")
        
    }
    func tabBarController(_ tabBarController: UITabBarController, didSprepareTabBarItemelect viewController: UIViewController) {
     
        let tabBarIndex = tabBarController.selectedIndex
        print("tabBarIndex\(tabBarIndex)")
        if tabBarIndex == 4 {
            
        }
    }
    
    
     func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) -> Bool {

        return true
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print("Selected item")
    }
    
    
    
    
}

extension AppBottomNavigationController {
    fileprivate func prepareTabBar() {
        tabBar.depthPreset = .none
        tabBar.dividerColor = Color.grey.lighten2
    }
}

