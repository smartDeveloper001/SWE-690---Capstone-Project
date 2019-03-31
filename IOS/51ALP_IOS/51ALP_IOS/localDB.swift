//
//  localDB.swift
//  51ALP_IOS
//
//  Created by xiu on 3/6/19.
//  Copyright © 2019 wma. All rights reserved.
//

import Foundation

import RealmSwift
class LocalUserInfo: Object {
    @objc dynamic var userId = 0
    @objc dynamic var userName = ""
    @objc dynamic var userEmail = ""
    @objc dynamic var userToken = ""
    @objc dynamic var localUserAvataImage = ""
    @objc dynamic var needLogin = true
    @objc dynamic var userType_id = 0
}
