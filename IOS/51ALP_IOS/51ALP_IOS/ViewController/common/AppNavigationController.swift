//
//  AppNavigationController.swift
//  51ALP_IOS
//
//  Created by xiu on 1/30/19.
//  Copyright © 2019 wma. All rights reserved.
//

import UIKit

import Material

class AppNavigationController: NavigationController {
    open override func prepare() {
        super.prepare()
        isMotionEnabled = true
        // motionNavigationTransitionType = .fadeSlide(direction: .down)
        guard let v = navigationBar as? NavigationBar else {
            return
        }
        
        v.backgroundColor = .white
        v.depthPreset = .none
        v.dividerColor = Color.grey.lighten2
    }
}
