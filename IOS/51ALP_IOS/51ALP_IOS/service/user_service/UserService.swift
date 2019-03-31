//
//  userService.swift
//  51ALP_IOS
//
//  Created by xiu on 2/27/19.
//  Copyright © 2019 wma. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit

class UserService {
    
    static let shared = UserService()
    var localUserToken:String?
    var localUserName:String?
    var localUserEmail:String?
    var localUserAvataImage:String?
    var localUserTypeId:Int?
    var localUserId:Int?
    var processStatus:Int?  // 0  manager break  1  assigen Task 
    
    let semaphore = DispatchSemaphore(value: 0)
    init(){}
    
    
     var usersMap:[Int:User] = [:]
    
    func initUsersMap(){
        
        if UserService.shared.localUserTypeId == 1 {
            getUsersByParentId(parentId:UserService.shared.localUserId!).done {  userList in
                for user in userList{
                    self.usersMap[user.id!] = user
                }
            }
            
        }else{
            
            getUsersByConsultantId(consultant_id: UserService.shared.localUserId!).done {  userList in
                for user in userList{
                    self.usersMap[user.id!] = user
                }
            }
            
        }
       
    }
    
    func getUsersByParentId(parentId:Int) -> Promise<Array<User>> {
        
        let url = ENV.BACKENDURL.rawValue+"/api/users/parent/"+String(parentId)
        
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
                                let users = try decoder.decode([User].self, from: data)
                                seal.fulfill(users)
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
    
    
    
    func getUsersByConsultantId(consultant_id:Int) -> Promise<Array<User>> {
        
        let url = ENV.BACKENDURL.rawValue+"/api/users/consultant/"+String(consultant_id)
        
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
                                let users = try decoder.decode([User].self, from: data)
                                seal.fulfill(users)
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
    
    
    func getAssociatedUsers(consultantId:Int) -> Promise<Array<User>> {
        
        let url = ENV.BACKENDURL.rawValue+"/api/users/"+String(consultantId)
        
        let token = UserService.shared.localUserToken!
        return Promise { seal in
            Alamofire.request(url, method: .get,parameters: [:],headers: ["token": token])
                .responseData { response in
                    print(response)
                    switch (response.result) {
                    case .success:
                        if let data = response.result.value, let utf8Text = String(data: data, encoding: .utf8) {
                            print("getAssociatedUsers Data: \(utf8Text)")
                            
                            do {
                                let decoder = JSONDecoder()
                                let users = try decoder.decode([User].self, from: data)
                                seal.fulfill(users)
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
    
    
    

    
    
    
    func login(loginemail:String, password:String) -> Promise<Bool> {
        
        let login:[String : String] = [
            "user_email": loginemail,
            "user_password": password
            
        ]

        let url = ENV.BACKENDURL.rawValue+"/api/login"
    
        print("http reuest:\(url)")
        print("http data:\(login)")
        
         return Promise { seal in
            Alamofire.request(url, method: .post,parameters: login,encoding: JSONEncoding.default)
                .responseData { response in
                    switch (response.result) {
                    case .success:
                        if let data = response.result.value, let utf8Text = String(data: data, encoding: .utf8) {
                                print("Data: \(utf8Text)")
                                do {
                                    let decoder = JSONDecoder()
                                    let userLoginRes = try decoder.decode(UserRes.self, from: data)
                                    print("login status:\(userLoginRes.success)")
                           
                                    if(userLoginRes.success){
                                        self.removeLocalUserInfo()
                                        let realm = SSRealmTool.ss_realm
                                        let localUserInfo = LocalUserInfo()
                                        localUserInfo.needLogin = false
                                        if let token = userLoginRes.token {
                                            localUserInfo.userToken = token
                                             UserService.shared.localUserToken = token
                                            if let user  = userLoginRes.user{
                                                localUserInfo.userName = user.userName!
                                                localUserInfo.userEmail = user.userEmail!
                                                
                                                if user.userAvatarPath != nil {
                                                    localUserInfo.localUserAvataImage = user.userAvatarPath!
                                                    
                                                }
                                               
                                                localUserInfo.userType_id = user.userTypeID!
                                                localUserInfo.userId = user.id!
                                                print("-----user Type is:\(localUserInfo.userType_id)")
                                                
                                                UserService.shared.localUserName = user.userName!
                                                UserService.shared.localUserEmail = user.userEmail!
                                                UserService.shared.localUserTypeId = user.userTypeID!
                                                UserService.shared.localUserId = user.id!
                                                UserService.shared.localUserTypeId = user.userTypeID!
                                                
                                                
                                                try! realm.write {
                                                    realm.add(localUserInfo)
                                                    print("add local user info to realm")
                                                }
                                            }
                                            
                                        }
                                        
                                    }
                                    
 
                                    seal.fulfill(userLoginRes.success)
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


  
    
    func logout() -> Promise<Bool> {
        let token = UserService.shared.localUserToken!
        let url = ENV.BACKENDURL.rawValue+"/api/logout/"
        return Promise { seal in
            Alamofire.request(url, method: .get,parameters: [:],headers: ["token": token])
                .responseData { response in
                    switch (response.result) {
                    case .success:
                        if let data = response.result.value, let utf8Text = String(data: data, encoding: .utf8) {
                            print("Data: \(utf8Text)")
                          
                            do {
                                let decoder = JSONDecoder()
                                let logoutRes = try decoder.decode(LogoutRes.self, from: data)
                                print("login status:\(logoutRes.success)")
                                
                               
                                seal.fulfill(logoutRes.success)
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
    
    
    
    func getConsultants() -> Promise<Array<User>> {
        
        let url = ENV.BACKENDURL.rawValue+"/api/consultants/"
        
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
                                let users = try decoder.decode([User].self, from: data)
                                seal.fulfill(users)
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


    
    func removeLocalUserInfo()->Bool{
        var result = false
        let realm = SSRealmTool.ss_realm
        let items = realm.objects(LocalUserInfo.self)
        try! realm.write {
            realm.delete(items)
            print("remove local user information successfully")
            result =  true
        }
        return result;
    }

    
    
    
//    UserService.shared.logout().done{ status -> Void in
//    print(status)
//    
//    }.catch { error in
//
//    print(error)
//    }
//
    
func signup(signupReq:SignupReq) -> Promise<Bool> {
    let url = ENV.BACKENDURL.rawValue+"/api/signup"
    var  request = try! DictionaryEncoder().encode(signupReq)

    return Promise { seal in
        Alamofire.request(url, method: .post, parameters: request, encoding: JSONEncoding.default)
            .responseData { response in
                switch (response.result) {
                case .success:
                    if let data = response.result.value, let utf8Text = String(data: data, encoding: .utf8) {
                        print("Data: \(utf8Text)")
                        do {
                            let decoder = JSONDecoder()
                            let userData = try decoder.decode(UserRes.self, from: data)
                            seal.fulfill(userData.success)
                            
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



func requestConsulent(requestConsulentReq:RequestConsulentReq) -> Promise<RequestConsulentRes> {
    let url = ENV.BACKENDURL.rawValue+"/api/parentConsultant"
    let token = UserService.shared.localUserToken!
    let  request = try! DictionaryEncoder().encode(requestConsulentReq)
    return Promise { seal in
        Alamofire.request(url, method: .post, parameters: request, encoding: JSONEncoding.default,headers: ["token": token])
            .responseData { response in
                switch (response.result) {
                case .success:
                    if let data = response.result.value, let utf8Text = String(data: data, encoding: .utf8) {
                        print("Data: \(utf8Text)")
                        do {
                            let decoder = JSONDecoder()
                            let requestConsulentRes = try decoder.decode(RequestConsulentRes.self, from: data)
                            seal.fulfill(requestConsulentRes)
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
    func responseParentRequest(parentId:Int,statusId:Int) -> Promise<RequestConsulentRes> {
        let url = ENV.BACKENDURL.rawValue+"/api/parentConsultant/"+String(parentId)+"/"+String(statusId)
        let token = UserService.shared.localUserToken!
        return Promise { seal in
            Alamofire.request(url, method: .put, parameters: nil, encoding: JSONEncoding.default,headers: ["token": token])
                .responseData { response in
                    switch (response.result) {
                    case .success:
                        if let data = response.result.value, let utf8Text = String(data: data, encoding: .utf8) {
                            print("Data: \(utf8Text)")
                            do {
                                let decoder = JSONDecoder()
                                let requestConsulentRes = try decoder.decode(RequestConsulentRes.self, from: data)
                                seal.fulfill(requestConsulentRes)
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
//  -get  parentConsultant by parent Id
    
func getParentConsultantByParentId(parentId:Int) -> Promise<RequestConsulentRes> {
    
    let url = ENV.BACKENDURL.rawValue+"/api/parentConsultant/parent/"+String(parentId)
    
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
                            let requestConsulentRes = try decoder.decode(RequestConsulentRes.self, from: data)
                            seal.fulfill(requestConsulentRes)
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

//  -get  parentConsultant by parent Id

func getParentConsultantByConsultantId(consultantId:Int) -> Promise<Array<RequestConsulentRes>> {
    
    let url = ENV.BACKENDURL.rawValue+"/api/parentConsultant/consultant/"+String(consultantId)
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
                            let requestConsulentRes = try decoder.decode([RequestConsulentRes].self, from: data)
                            seal.fulfill(requestConsulentRes)
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
    
    
    
func getUserByUserId(userId:Int) -> Promise<UserRes> {
    
    let url = ENV.BACKENDURL.rawValue+"/api/user/"+String(userId)
    print(url)
    
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
                            let userRes = try! decoder.decode(UserRes.self, from: data)
                            seal.fulfill(userRes)
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
    func updateUser(updateUserReq:UpdateUserReq) -> Promise<Bool> {
        let url = ENV.BACKENDURL.rawValue+"/api/user"
        let token = UserService.shared.localUserToken!
        let  request = try! DictionaryEncoder().encode(updateUserReq)
        return Promise { seal in
            Alamofire.request(url, method: .put, parameters: request, encoding: JSONEncoding.default,headers: ["token": token])
                .responseData { response in
                    switch (response.result) {
                    case .success:
                        seal.fulfill(true)
                        break
                    case .failure(let error):
                        seal.reject(error)
                        break
                    }
                    
            }
        }
        
        
    }
    
    
    func changePassword(userId:Int,oldPs:String,newPs:String) -> Promise<ChangePsRes> {
        let url = ENV.BACKENDURL.rawValue+"/api/user"+"/"+String(userId)+"/"+oldPs+"/"+newPs
        let token = UserService.shared.localUserToken!
        
        return Promise { seal in
            Alamofire.request(url, method: .put, parameters: nil, encoding: JSONEncoding.default,headers: ["token": token])
                .responseData { response in
                    switch (response.result) {
                    case .success:
                        if let data = response.result.value, let utf8Text = String(data: data, encoding: .utf8) {
                            print("Data: \(utf8Text)")
                            
                            do {
                                let decoder = JSONDecoder()
                                let changePsRes = try! decoder.decode(ChangePsRes.self, from: data)
                                seal.fulfill(changePsRes)
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
    





class DictionaryEncoder {
    
    private let encoder = JSONEncoder()
    
    var dateEncodingStrategy: JSONEncoder.DateEncodingStrategy {
        set { encoder.dateEncodingStrategy = newValue }
        get { return encoder.dateEncodingStrategy }
    }
    
    var dataEncodingStrategy: JSONEncoder.DataEncodingStrategy {
        set { encoder.dataEncodingStrategy = newValue }
        get { return encoder.dataEncodingStrategy }
    }
    
    var nonConformingFloatEncodingStrategy: JSONEncoder.NonConformingFloatEncodingStrategy {
        set { encoder.nonConformingFloatEncodingStrategy = newValue }
        get { return encoder.nonConformingFloatEncodingStrategy }
    }
    
    var keyEncodingStrategy: JSONEncoder.KeyEncodingStrategy {
        set { encoder.keyEncodingStrategy = newValue }
        get { return encoder.keyEncodingStrategy }
    }
    
    func encode<T>(_ value: T) throws -> [String: Any] where T : Encodable {
        let data = try encoder.encode(value)
        return try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any]
    }
}





