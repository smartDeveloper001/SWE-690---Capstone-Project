//
//  TaskService.swift
//  51ALP_IOS
//
//  Created by xiu on 3/9/19.
//  Copyright © 2019 wma. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit



class TaskService {
    
    static let shared = TaskService()
    init(){}
    

func assignTask(taskReq:TaskReq) -> Promise<TaskRes> {
    let url = ENV.BACKENDURL.rawValue+"/api/userTask"
    let token = UserService.shared.localUserToken!
    let  request = try! DictionaryEncoder().encode(taskReq)
    return Promise { seal in
        Alamofire.request(url, method: .post, parameters: request, encoding: JSONEncoding.default, headers: ["token": token])
            .responseData { response in
                switch (response.result) {
                case .success:
                    if let data = response.result.value, let utf8Text = String(data: data, encoding: .utf8) {
                        print("Data: \(utf8Text)")
                        do {
                            let decoder = JSONDecoder()
                            let taskRes = try decoder.decode(TaskRes.self, from: data)
                            seal.fulfill(taskRes)
                        } catch let error {
                            seal.reject(error)
                        }
                    }
                    break
                case .failure(let error):
                    seal.reject(error)
                    break
                }
        }
    }
    
}


    func replyTask(taskId:Int,replayTaskReq:ReplayTaskReq) -> Promise<TaskRes> {
    let token = UserService.shared.localUserToken!
    let url = ENV.BACKENDURL.rawValue+"/api/userTask/"+String(taskId)
    let  request = try! DictionaryEncoder().encode(replayTaskReq)
    return Promise { seal in
        Alamofire.request(url, method: .put, parameters: request, encoding: JSONEncoding.default, headers: ["token": token])
            .responseData { response in
                switch (response.result) {
                case .success:
                    if let data = response.result.value, let utf8Text = String(data: data, encoding: .utf8) {
                        print("Data: \(utf8Text)")
                        do {
                            let decoder = JSONDecoder()
                            let taskRes = try decoder.decode(TaskRes.self, from: data)
                            seal.fulfill(taskRes)
                        } catch let error {
                            seal.reject(error)
                        }
                    }
                    break
                case .failure(let error):
                    seal.reject(error)
                    break
                }
        }
    }
    
}



func getTasks(parentId:Int) -> Promise<Array<TaskRes>> {
    
    let url = ENV.BACKENDURL.rawValue+"/api/userTask/"+String(parentId)
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
                            let taskReslist = try decoder.decode([TaskRes].self, from: data)
                            seal.fulfill(taskReslist)
                        }catch let error {
                            print(error)
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
    
    func getTaskByTaskId(taskId:Int) -> Promise<TaskRes> {
        
        let url = ENV.BACKENDURL.rawValue+"/api/task/"+String(taskId)
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
                                let taskRes = try decoder.decode(TaskRes.self, from: data)
                                seal.fulfill(taskRes)
                            }catch let error {
                                print(error)
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
    
    
    func passTask(taskId:Int) -> Promise<TaskRes> {
        
        let url = ENV.BACKENDURL.rawValue+"/api/userTask/"+String(taskId)+"/0"
        let token = UserService.shared.localUserToken!
        return Promise { seal in
            Alamofire.request(url, method: .put,parameters: [:],headers: ["token": token])
                .responseData { response in
                    print(response)
                    switch (response.result) {
                    case .success:
                        if let data = response.result.value, let utf8Text = String(data: data, encoding: .utf8) {
                            print("Data: \(utf8Text)")
                            
                            do {
                                let decoder = JSONDecoder()
                                let taskRes = try decoder.decode(TaskRes.self, from: data)
                                seal.fulfill(taskRes)
                            }catch let error {
                                print(error)
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


