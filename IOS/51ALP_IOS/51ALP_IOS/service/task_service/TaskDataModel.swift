//
//  TaskDataModel.swift
//  51ALP_IOS
//
//  Created by xiu on 3/9/19.
//  Copyright © 2019 wma. All rights reserved.
//

import Foundation


struct TaskReq: Codable {
    let userID,consultantID, courseID, goalID, goalBreakID: Int
    let taskTitle, taskContent: String
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case consultantID = "consultant_id"
        case courseID = "course_id"
        case goalID = "goal_id"
        case goalBreakID = "goal_break_id"
        case taskTitle = "task_title"
        case taskContent = "task_content"
    }
}
struct TaskRes: Codable {
    let id: Int
    let createdAt, updatedAt: String
    let taskStatus, consultantID,userID, courseID, goalID: Int
    let goalBreakID: Int
    let taskTitle, taskContent: String
    let v: Int
    let replays: [ReplayObj]?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case createdAt, updatedAt
        case taskStatus = "task_status"
        case userID = "user_id"
        case consultantID = "consultant_id"
        case courseID = "course_id"
        case goalID = "goal_id"
        case goalBreakID = "goal_break_id"
        case taskTitle = "task_title"
        case taskContent = "task_content"
        case v = "__v"
        case replays
    }
}

struct ReplayObj: Codable {
    let id: Int
    let createdAt, updatedAt, replayContent, replayTitle: String
    let replayType, userID: Int
    let replayVides: [ReplayVide]
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case createdAt, updatedAt
        case replayContent = "replay_content"
        case replayTitle = "replay_title"
        case replayType = "replay_type"
        case userID = "user_id"
        case replayVides = "replay_vides"
    }
}

struct ReplayVide: Codable {
    let id: Int
    let createdAt, updatedAt, videoName, videoPath: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case createdAt, updatedAt
        case videoName = "video_name"
        case videoPath = "video_path"
    }
}

struct ReplayTaskReq: Codable {
    let userID, replayType: Int
    let replayTitle, replayContent: String
    let replayVides: [ReplayVideObj]
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case replayType = "replay_type"
        case replayTitle = "replay_title"
        case replayContent = "replay_content"
        case replayVides = "replay_vides"
    }
}

struct ReplayVideObj: Codable {
    let videoName, videoPath: String
    
    enum CodingKeys: String, CodingKey {
        case videoName = "video_name"
        case videoPath = "video_path"
    }
}



