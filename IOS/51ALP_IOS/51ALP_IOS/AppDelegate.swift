//
//  AppDelegate.swift
//  51ALP_IOS
//
//  Created by xiu on 1/30/19.
//  Copyright © 2019 wma. All rights reserved.
//

import UIKit
import Material
import PromiseKit
import RealmSwift


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        Util.createDBfolder()
        window = UIWindow(frame: Screen.bounds)
        // init realmswift
        let schemaVersion: UInt64 = 5
        
        
        
        SSRealmTool.schemaVersion = schemaVersion
        
        let config = Realm.Configuration(schemaVersion: schemaVersion, migrationBlock: { (migration, oldSchemaVersion) in
            
            if (oldSchemaVersion < schemaVersion) {
                print("----数据库升级")
            }
        })
        Realm.Configuration.defaultConfiguration = config
        Realm.asyncOpen { (realm, error) in
            
            if let _ = realm {
                
                print("Realm 数据库配置成功")
            } else if let error = error {
                
                print("Realm 数据库配置失败：\(error.localizedDescription)")
            }
        }
        
        let realm = SSRealmTool.ss_realm
        print(realm.objects(LocalUserInfo.self).count )
        if realm.objects(LocalUserInfo.self).count == 1 {
            
            
            let localUserInfos = realm.objects(LocalUserInfo.self)
            
            print("AppDelegate --> you have login token is:"+localUserInfos[0].userToken)
            UserService.shared.localUserToken = localUserInfos[0].userToken
            UserService.shared.localUserName = localUserInfos[0].userName
            UserService.shared.localUserEmail = localUserInfos[0].userEmail
            UserService.shared.localUserTypeId = localUserInfos[0].userType_id
            UserService.shared.localUserId = localUserInfos[0].userId
            UserService.shared.localUserAvataImage = localUserInfos[0].localUserAvataImage
            
            
            
            
            
            CourseService.shared.initGogalMap()
            CourseService.shared.initCourseMap()
            BreakService.shared.initBreakMap()
            UserService.shared.initUsersMap()
            
            
            
            
            
            var viewControllers:[AppNavigationController] = []
            let vlvc = VideoLectureViewController()
            let nav1 = AppNavigationController(rootViewController:vlvc)
            viewControllers.append(nav1)
            
            
            
            if let userType = UserService.shared.localUserTypeId{
                
                if userType == 1{
                    let ptvc = Course4ParentViewController()
                    let nav2 = AppNavigationController(rootViewController:ptvc)
                    viewControllers.append(nav2)
                    
                }
                
                if userType == 2{
                    let tvc = TaskViewController()
                    let nav4 = AppNavigationController(rootViewController:tvc)
                    viewControllers.append(nav4)
                    
                    
                    let bvc = CourseViewController()
                    let nav7 = AppNavigationController(rootViewController:bvc)
                    viewControllers.append(nav7)
                    
                    
                    
                    
                }
                
                
                
                
            }
            
            let vvc = VideoViewController()
            let nav3 = AppNavigationController(rootViewController:vvc)
            viewControllers.append(nav3)
            
            
            let avc = AccountViewController()
            let nav5 = AppNavigationController(rootViewController:avc)
            viewControllers.append(nav5)
            
            let appBottomNavigationController = AppBottomNavigationController(viewControllers: viewControllers)
            appBottomNavigationController.selectedIndex = 0
            window!.rootViewController = appBottomNavigationController
            window!.makeKeyAndVisible()
            
            
        }else{
            
            // go to login
            print("go to login ")
            let loginVC = LoginViewController()
            window!.rootViewController = loginVC
            window!.makeKeyAndVisible()
        }
        
        
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}

