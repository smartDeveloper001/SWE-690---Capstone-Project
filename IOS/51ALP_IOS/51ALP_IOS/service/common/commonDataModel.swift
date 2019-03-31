//
//  commonDataModel.swift
//  51ALP_IOS
//
//  Created by xiu on 3/7/19.
//  Copyright © 2019 wma. All rights reserved.
//

import Foundation


struct Cities: Codable {
    let id, name: String
    let code: Int
    let city: [City]
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, code, city
    }
}

struct City: Codable {
    let name: String
    let code: Int
}

struct UploadRes: Codable {
    let message: String
    let success: Bool
}

struct ChangePsRes: Codable {
    let message: String
    let success: Bool
}

struct FeedbackRq: Codable {
    let userID: Int
    let feedback: String
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case feedback
    }
}


struct FeedbackRs: Codable {
    let v, id: Int
    let createdAt, updatedAt: String
    let userID: Int
    let feedback: String
    
    enum CodingKeys: String, CodingKey {
        case v = "__v"
        case id = "_id"
        case createdAt, updatedAt
        case userID = "user_id"
        case feedback
    }
}






