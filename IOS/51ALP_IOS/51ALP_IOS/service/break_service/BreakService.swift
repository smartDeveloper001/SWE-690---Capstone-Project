//
//  break_service.swift
//  51ALP_IOS
//
//  Created by xiu on 3/9/19.
//  Copyright © 2019 wma. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit



class BreakService {
    
    static let shared = BreakService()
    init(){}
    
    
    
    
    var breakMap:[Int:BreakRes] = [:]
    
    func initBreakMap(){
        getBreaks().done {  breakRsList in
            print("initCourseMap:\(breakRsList)")
            for breakReq in breakRsList{
                self.breakMap[breakReq.id] = breakReq
            }
        }
    }
    
    func addBreak(breakReq:BreakReq) -> Promise<BreakRes> {
        let token = UserService.shared.localUserToken!
        let url = ENV.BACKENDURL.rawValue+"/api/gogalBreak"
        let  request = try! DictionaryEncoder().encode(breakReq)
        return Promise { seal in
            Alamofire.request(url, method: .post, parameters: request, encoding: JSONEncoding.default,headers: ["token": token])
                .responseData { response in
                    switch (response.result) {
                    case .success:
                        if let data = response.result.value, let utf8Text = String(data: data, encoding: .utf8) {
                            print("Data: \(utf8Text)")
                            do {
                                let decoder = JSONDecoder()
                                let breakRes = try decoder.decode(BreakRes.self, from: data)
                                seal.fulfill(breakRes)
                            } catch let error {
                                 print("error:\(error)")
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


    func updateBreak(updateReq:UpdateReq) -> Promise<BreakRes> {
        let token = UserService.shared.localUserToken!
        let url = ENV.BACKENDURL.rawValue+"/api/gogalBreak"
        let  request = try! DictionaryEncoder().encode(updateReq)
        return Promise { seal in
            Alamofire.request(url, method: .put, parameters: request, encoding: JSONEncoding.default,headers: ["token": token])
                .responseData { response in
                    switch (response.result) {
                    case .success:
                        if let data = response.result.value, let utf8Text = String(data: data, encoding: .utf8) {
                            print("Data: \(utf8Text)")
                            do {
                                let decoder = JSONDecoder()
                                let breakRes = try decoder.decode(BreakRes.self, from: data)
                                seal.fulfill(breakRes)
                            } catch let error {
                                 print("error:\(error)")
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

    func getBreaks(consultantId:Int) -> Promise<Array<BreakRes>> {
        
        let url = ENV.BACKENDURL.rawValue+"/api/gogalBreaks/"+String(consultantId)
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
                                let breakResList = try decoder.decode([BreakRes].self, from: data)
                                seal.fulfill(breakResList)
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


    
    func getBreaks() -> Promise<Array<BreakRes>> {
        
        let url = ENV.BACKENDURL.rawValue+"/api/gogalBreaks/"
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
                                let breakResList = try decoder.decode([BreakRes].self, from: data)
                                seal.fulfill(breakResList)
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
    
    
    func deleteBreak(breakId:Int) -> Promise<DeleteBreakRes> {
        
        let url = ENV.BACKENDURL.rawValue+"/api/gogalBreak/"+String(breakId)
        let token = UserService.shared.localUserToken!
        return Promise { seal in
            Alamofire.request(url, method: .delete,parameters: [:],headers: ["token": token])
                .responseData { response in
                    print(response)
                    switch (response.result) {
                    case .success:
                        if let data = response.result.value, let utf8Text = String(data: data, encoding: .utf8) {
                            //print("Data: \(utf8Text)")
                            do {
                                let decoder = JSONDecoder()
                                let deleteBreakRes = try decoder.decode(DeleteBreakRes.self, from: data)
                                seal.fulfill(deleteBreakRes)
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




