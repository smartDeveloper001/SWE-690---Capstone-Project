//
//  SSRealmTool.swift
//  51ALP_IOS
//
//  Created by xiu on 3/6/19.
//  Copyright © 2019 wma. All rights reserved.
//

import Foundation
import RealmSwift

class SSRealmTool {

    static var schemaVersion: UInt64 = 1
    static let ss_realm = realm()

    private static func realm() -> Realm {
        let fileURL = URL(string: NSHomeDirectory() + "/Documents/db/51alp.realm")
        let config = Realm.Configuration(fileURL: fileURL, schemaVersion: schemaVersion)
        return try! Realm(configuration: config)
    }

}
