//
//  common_service.swift
//  51ALP_IOS
//
//  Created by xiu on 3/7/19.
//  Copyright © 2019 wma. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit

class CommonService {
    
    static let shared = CommonService()
    init(){}
    var citiesArray:Array<Cities>?
    
    
    func getCities() -> Promise<Array<Cities>> {
    
        let url = ENV.BACKENDURL.rawValue+"/api/cities/"
        
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
                                let cities = try! decoder.decode([Cities].self, from: data)
                                seal.fulfill(cities)
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
   
    
    
//    Alamofire.upload(.POST, url, multipartFormData: { (multipartFormData) in
//
//
//    for image in imageArrays {
//    let data = UIImageJPEGRepresentation(image as! UIImage, 0.5)
//    let imageName = String(NSDate()) + ".png"
//    multipartFormData.appendBodyPart(data: data!, name: "name", fileName: imageName, mimeType: "image/png")
//    }
//
//    // 这里就是绑定参数的地方 param 是需要上传的参数，我这里是封装了一个方法从外面传过来的参数，你可以根据自己的需求用NSDictionary封装一个param
//    for (key, value) in param {
//    assert(value is String, "参数必须能够转换为NSData的类型，比如String")
//    multipartFormData.appendBodyPart(data: value.dataUsingEncoding(NSUTF8StringEncoding)!, name: key )
//    }
//
//    }) { (encodingResult) in
//    switch encodingResult {
//    case .Success(let upload, _, _):
//    upload.responseJSON(completionHandler: { (response) in
//    completeBlock(responseObject: response.result.value!, error: nil)
//    })
//    case .Failure(let error):
//    completeBlock(responseObject: nil, error: error)
//    }
//
   
 
//    if let data = upload.result.value, let utf8Text = String(data: data, encoding: .utf8) {
//        //print("Data: \(utf8Text)")
//
//        do {
//            let decoder = JSONDecoder()
//            let uploadRes = try decoder.decode([UploadRes].self, from: data)
//            seal.fulfill(uploadRes)
//        }catch let error {
//            print("error:\(error)")
//            seal.reject(error)
//        }
//    }

    

    func upload(mp4Path:String) -> Promise<UploadRes> {
         let mp4PathURL = URL.init(fileURLWithPath: mp4Path)
        
        let videoInfoArray = mp4Path.split(separator: "/")
        let fileName = String((videoInfoArray.last)!)
        
        
        let url = ENV.BACKENDURL.rawValue+"/api/upload"
        
        let token = UserService.shared.localUserToken!
        
        let headers: HTTPHeaders = [
            "token": token
        ]
        
        let request = try! URLRequest(url: url, method: .post, headers: headers)

        return Promise { seal in
            
            Alamofire.upload(
                multipartFormData: { multipartFormData in
                    multipartFormData.append(mp4PathURL, withName: "file", fileName: fileName, mimeType: "video/mp4")
            },with: request,encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
         
                    upload.responseData { response in
             
                        guard let result = response.result.value else { return }
                        print("json:\(result)")
                                do {
                                    let decoder = JSONDecoder()
                                    let uploadRes = try decoder.decode(UploadRes.self, from: result)
                                    seal.fulfill(uploadRes)
                                }catch let error {
                                    print("error:\(error)")
                                    seal.reject(error)
                                }
            
                    }
                    //上传进度
                    upload.uploadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
                        print("---> upload process pecent: \(progress.fractionCompleted)")
                    }
                   
                case .failure(let encodingError):
                    print(encodingError)
                      seal.reject(encodingError)
                }
            })
            
        }
        
        
    }
            
    func uploadImage(imagePath:String) -> Promise<UploadRes> {
        let imagePathURL = URL.init(fileURLWithPath: imagePath)
        
        let imageInfoArray = imagePath.split(separator: "/")
        let fileName = String((imageInfoArray.last)!)
        
        
        let url = ENV.BACKENDURL.rawValue+"/api/uploadImage"
        
        let token = UserService.shared.localUserToken!
        
        let headers: HTTPHeaders = [
            "token": token
        ]
        
        let request = try! URLRequest(url: url, method: .post, headers: headers)
        
        return Promise { seal in
            
            Alamofire.upload(
                multipartFormData: { multipartFormData in
                    multipartFormData.append(imagePathURL, withName: "file", fileName: fileName, mimeType: "image/jpeg")
            },with: request,encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    
                    upload.responseData { response in
                        
                        guard let result = response.result.value else { return }
                        print("json:\(result)")
                        do {
                            let decoder = JSONDecoder()
                            let uploadRes = try decoder.decode(UploadRes.self, from: result)
                            seal.fulfill(uploadRes)
                        }catch let error {
                            print("error:\(error)")
                            seal.reject(error)
                        }
                        
                    }
                    //上传进度
                    upload.uploadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
                        print("---> upload process pecent: \(progress.fractionCompleted)")
                    }
                    
                case .failure(let encodingError):
                    print(encodingError)
                    seal.reject(encodingError)
                }
            })
                    
                    
        }
        
        
    }
            
//            Alamofire.upload(multipartFormData:{ multipartFormData in
//                multipartFormData.append(path, withName: "file")
//
//            },
//                             usingThreshold:UInt64.init(),
//                             to:url,
//                             method:.post,
//                             ["token": token],
//                             encodingCompletion: { encodingResult in
//                                switch encodingResult {
//                                case .success(let upload, _, _):
//                                    upload.responseJSON { response in
//                                        debugPrint(response)
//                                    }
//                                case .failure(let encodingError):
//                                    print(encodingError)
//                                }
//            })
   
    
    
    
    
    func addFeedback(feedbackRq:FeedbackRq) -> Promise<FeedbackRs> {
        let url = ENV.BACKENDURL.rawValue+"/api/feedback"
        let token = UserService.shared.localUserToken!
        let  request = try! DictionaryEncoder().encode(feedbackRq)
        return Promise { seal in
            Alamofire.request(url, method: .post, parameters: request, encoding: JSONEncoding.default,headers: ["token": token])
                .responseData { response in
                    switch (response.result) {
                    case .success:
                        if let data = response.result.value, let utf8Text = String(data: data, encoding: .utf8) {
                            print("Data: \(utf8Text)")
                            
                            do {
                                let decoder = JSONDecoder()
                                let feedbackRs = try! decoder.decode(FeedbackRs.self, from: data)
                                seal.fulfill(feedbackRs)
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
