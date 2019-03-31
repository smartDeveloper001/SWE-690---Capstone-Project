//
//  userDataModel.swift
//  51ALP_IOS
//
//  Created by xiu on 2/27/19.
//  Copyright © 2019 wma. All rights reserved.
//

import Foundation

struct UserRes: Codable {
    let success: Bool
    let message: String?
    var user: User?
    var token: String?
}


struct LogoutRes: Codable {
    let success: Bool
    let message: String
}

struct UpdateUserReq: Codable {
    let id: Int
    let userName: String
    let userStateCode: Int
    let userState, userCity: String
    let userCityCode: Int
    let userSelfIntroduce: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case userName = "user_name"
        case userStateCode = "user_state_code"
        case userState = "user_state"
        case userCity = "user_city"
        case userCityCode = "user_city_code"
        case userSelfIntroduce = "user_self_introduce"
    }
}


struct RequestConsulentReq: Codable {
    let parentID, numTasksReplay: Int
    let parentName, parentEmail: String
    let status, consultantID, numTasksHandle: Int
    
    enum CodingKeys: String, CodingKey {
        case parentID = "parent_id"
        case numTasksReplay = "num_tasks_replay"
        case parentName = "parent_name"
        case parentEmail = "parent_email"
        case status
        case consultantID = "consultant_id"
        case numTasksHandle = "num_tasks_handle"
    }
}

struct RequestConsulentRes: Codable {
    let id: Int!
    let createdAt, updatedAt: String!
    let parentID, numTasksReplay: Int!
    let parentName, parentEmail: String!
    let status, consultantID, numTasksHandle, v: Int!
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case createdAt, updatedAt
        case parentID = "parent_id"
        case numTasksReplay = "num_tasks_replay"
        case parentName = "parent_name"
        case parentEmail = "parent_email"
        case status
        case consultantID = "consultant_id"
        case numTasksHandle = "num_tasks_handle"
        case v = "__v"
    }
}




struct User: Codable {
    let id: Int?
    let createdAt, updatedAt: String?
    let userStatus: Int?
    let userName, userEmail, userPassword, userType: String?
    let userTypeID, v: Int?
    let userCity, userSelfIntroduce, userState: String?
    let userStateID, userCityCode, userStateCode: Int?
    let userAvatarPath: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case createdAt, updatedAt
        case userStatus = "user_status"
        case userName = "user_name"
        case userEmail = "user_email"
        case userPassword = "user_password"
        case userType = "user_type"
        case userTypeID = "user_type_id"
        case v = "__v"
        case userCity = "user_city"
        case userSelfIntroduce = "user_self_introduce"
        case userState = "user_state"
        case userStateID = "user_state_id"
        case userCityCode = "user_city_code"
        case userStateCode = "user_state_code"
        case userAvatarPath = "user_avatar_path"
    }
}


struct SignupReq: Codable {
    let userName, userEmail, userPassword, userType: String
    let userTypeID: Int
    
    enum CodingKeys: String, CodingKey {
        case userName = "user_name"
        case userEmail = "user_email"
        case userPassword = "user_password"
        case userType = "user_type"
        case userTypeID = "user_type_id"
    }
}


