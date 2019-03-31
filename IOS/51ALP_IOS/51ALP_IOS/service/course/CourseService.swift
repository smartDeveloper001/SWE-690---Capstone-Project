//
//  CourseService.swift
//  51ALP_IOS
//
//  Created by xiu on 2/27/19.
//  Copyright © 2019 wma. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit

class CourseService {
    
    static let shared = CourseService()
    
    var courseMap:[Int:CourseRs] = [:]
    
    func initCourseMap(){
        getCourses().done {  courseRsList in
            print("initCourseMap:\(courseRsList)")
            for courseRs in courseRsList{
                self.courseMap[courseRs.id] = courseRs
            }
        }
    }
    
    var gogalMap:[Int:GogalRes] = [:]
    
    func initGogalMap(){
        getGogals().done{  gogalRsList in
            print("initGogalMap:\(gogalRsList)")
            for gogalRes in gogalRsList{
                self.gogalMap[gogalRes.id] = gogalRes
            }
        }
    }


    
    init(){
    }
    
    
    
    func getCourses() -> Promise<Array<CourseRs>> {
        
        let url = ENV.BACKENDURL.rawValue+"/api/courses/"
        let token = UserService.shared.localUserToken!
        
        return Promise { seal in
            Alamofire.request(url, method: .get,parameters: [:],headers: ["token": token])
                .responseData { response in
                    print(response)
                    switch (response.result) {
                    case .success:
                        if let data = response.result.value, let utf8Text = String(data: data, encoding: .utf8) {
                           print("Data: \(utf8Text)")
                            
                            do {
                                let decoder = JSONDecoder()
                                let courseRslist = try decoder.decode([CourseRs].self, from: data)
                                seal.fulfill(courseRslist)
                            }catch let error {
                                print("error:\(error)")
                                seal.reject(error)
                            }
                        }
                        
                        break
                    case .failure(let error):
                        print(error)
                        seal.reject(error)
                        break
                    }
                    
            }
        }
    }


    func getGogalsByCourseId(courseId:Int) -> Promise<Array<GogalRes>> {
        
        let url = ENV.BACKENDURL.rawValue+"/api/gogals/"+String(courseId)
        print("CourseService getGogalsByCourseId url:\(url)")
        let token = UserService.shared.localUserToken!
        
        return Promise { seal in
            Alamofire.request(url, method: .get,parameters: [:],headers: ["token": token])
                .responseData { response in
                    print(response)
                    switch (response.result) {
                    case .success:
                        if let data = response.result.value, let utf8Text = String(data: data, encoding: .utf8) {
                            //print("Data: \(utf8Text)")
                            
                            do {
                                let decoder = JSONDecoder()
                                let gogalResList = try decoder.decode([GogalRes].self, from: data)
                                seal.fulfill(gogalResList)
                            }catch let error {
                                print("error:\(error)")
                                seal.reject(error)
                            }
                        }
                        
                        break
                    case .failure(let error):
                        print(error)
                        seal.reject(error)
                        break
                    }
                    
            }
        }
    }
    
    

    func getGogals() -> Promise<Array<GogalRes>> {
        
        let url = ENV.BACKENDURL.rawValue+"/api/gogals/"
        print("CourseService getGogals url:\(url)")
        let token = UserService.shared.localUserToken!
        
        return Promise { seal in
            Alamofire.request(url, method: .get,parameters: [:],headers: ["token": token])
                .responseData { response in
                    print(response)
                    switch (response.result) {
                    case .success:
                        if let data = response.result.value, let utf8Text = String(data: data, encoding: .utf8) {
                            print("Data: \(utf8Text)")
                            
                            do {
                                let decoder = JSONDecoder()
                                let gogalResList = try decoder.decode([GogalRes].self, from: data)
                                seal.fulfill(gogalResList)
                            }catch let error {
                                print("error:\(error)")
                                seal.reject(error)
                            }
                        }
                        
                        break
                    case .failure(let error):
                        print(error)
                        seal.reject(error)
                        break
                    }
                    
            }
        }
    }
    
}

