//
//  CourseDataModel.swift
//  51ALP_IOS
//
//  Created by xiu on 3/10/19.
//  Copyright © 2019 wma. All rights reserved.
//

import Foundation

struct CourseRs: Codable {
    let id: Int!
    let createdAt, updatedAt: String!
    let courseLevel: Int!
    let courseLevelName, courseName, courseGoal, courseSyllabus: String!
    let courseType: String!
    let v: Int!
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case createdAt, updatedAt
        case courseLevel = "course_level"
        case courseLevelName = "course_level_name"
        case courseName = "course_name"
        case courseGoal = "course_goal"
        case courseSyllabus = "course_syllabus"
        case courseType = "course_type"
        case v = "__v"
    }
}

struct GogalRes: Codable {
    let id: Int!
    let createdAt, updatedAt: String!
    let courseID, courseLevel: Int!
    let courseLevelName, courseName, courseGoal, courseSyllabus: String!
    let courseType: String!
    let goalSeq: Int!
    let goalName, goalDescrib, goalRequirement: String!
    let v: Int!
    let demoVideo: [DemoVideo]!
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case createdAt, updatedAt
        case courseID = "course_id"
        case courseLevel = "course_level"
        case courseLevelName = "course_level_name"
        case courseName = "course_name"
        case courseGoal = "course_goal"
        case courseSyllabus = "course_syllabus"
        case courseType = "course_type"
        case goalSeq = "goal_seq"
        case goalName = "goal_name"
        case goalDescrib = "goal_describ"
        case goalRequirement = "goal_requirement"
        case v = "__v"
        case demoVideo = "demo_video"
    }
}

struct DemoVideo: Codable {
    let id: Int!
    let createdAt, updatedAt, videoName, videoPath: String!
    let videoType: String!
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case createdAt, updatedAt
        case videoName = "video_name"
        case videoPath = "video_path"
        case videoType = "video_type"
    }
}

