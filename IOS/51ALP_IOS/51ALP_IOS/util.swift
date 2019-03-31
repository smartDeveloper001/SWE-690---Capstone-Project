//
//  util.swift
//  51ALP_IOS
//
//  Created by xiu on 3/16/19.
//  Copyright © 2019 wma. All rights reserved.
//

import Foundation

class Util {

 static func createDBfolder(){
    var isExisted = false
    let pathFolder = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
    let pathString = pathFolder[0] as String
    if let lists = try? FileManager.default.contentsOfDirectory(atPath: pathString) {
        for item in lists {
            print("item\(item)")
            if item == "db"{
                isExisted = true
            }
        }
            
    }
    
    if !isExisted{
        let fullDir = pathString+"/"+"db"
        do{
            try FileManager.default.createDirectory(at: NSURL(fileURLWithPath: fullDir, isDirectory: true) as URL, withIntermediateDirectories: true, attributes: nil)
        }catch{
            print("DB folder create fail ")
        }
        print("DB folder create OK")
        
        
    }
    }
}




// https://www.jianshu.com/p/9087c3eda280
//let pathFolder = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
//let pathString = pathFolder[0] as String
//let fullDir = pathString+"/"+"db"
//
//let fileManager = FileManager.default
//do{
//    try fileManager.createDirectory(at: NSURL(fileURLWithPath: fullDir, isDirectory: true) as URL, withIntermediateDirectories: true, attributes: nil)
//}catch{
//    print("DB folder create fail ")
//}
//print("DB folder create OK")
