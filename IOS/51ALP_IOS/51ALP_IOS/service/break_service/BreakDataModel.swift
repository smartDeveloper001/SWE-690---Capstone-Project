//
//  BreakDataModel.swift
//  51ALP_IOS
//
//  Created by xiu on 3/9/19.
//  Copyright © 2019 wma. All rights reserved.
//

import Foundation


struct BreakReq: Codable {
    let userID, courseID, goalID: Int
    let breakTitle, breakDesc, breakQuestion, breakRequirement: String
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case courseID = "course_id"
        case goalID = "goal_id"
        case breakTitle = "break_title"
        case breakDesc = "break_desc"
        case breakQuestion = "break_question"
        case breakRequirement = "break_requirement"
    }
}


struct UpdateReq: Codable {
    let id: Int
    let breakTitle, breakDesc, breakQuestion, breakRequirement: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case breakTitle = "break_title"
        case breakDesc = "break_desc"
        case breakQuestion = "break_question"
        case breakRequirement = "break_requirement"
    }
}



struct BreakRes: Codable {
    let v, id: Int
    let createdAt, updatedAt: String?
    let breakStatus, userID, courseID, goalID: Int?
    let breakTitle, breakDesc, breakQuestion, breakRequirement: String?
    
    enum CodingKeys: String, CodingKey {
        case v = "__v"
        case id = "_id"
        case createdAt, updatedAt
        case breakStatus = "break_status"
        case userID = "user_id"
        case courseID = "course_id"
        case goalID = "goal_id"
        case breakTitle = "break_title"
        case breakDesc = "break_desc"
        case breakQuestion = "break_question"
        case breakRequirement = "break_requirement"
    }
}

struct DeleteBreakRes: Codable {
    let id: Int
    let createdAt, updatedAt: String
    let breakStatus, v: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case createdAt, updatedAt
        case breakStatus = "break_status"
        case v = "__v"
    }
}

