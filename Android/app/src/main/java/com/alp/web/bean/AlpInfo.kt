package com.alp.web.bean

data class UserInfo(var user_name:String ?=null, var user_email:String? =null,var user_password:String?=null ,var user_type:String?=null,var user_type_id:Int?=null)
data class SignupResponse(
        val message: String,
        val success: Boolean,
        val user: User
)

data class User(
        val __v: Int,
        val _id: Int,
        val createdAt: String,
        val updatedAt: String,
        val user_email: String,
        val user_name: String,
        val user_password: String,
        val user_status: Int,
        val user_type: String,
        val user_type_id: Int
)

data class SignInResponse(
    val message: String,
    val success: Boolean,
    val token: String,
    val user: User
)

// update User
data class UpdateUserRquest(
    val id: Int,
    val user_city: String,
    val user_name: String,
    val user_self_introduce: String,
    val user_state: String,
    val user_state_id: Int
)

data class UpdateUserResponse(
    val __v: Int,
    val _id: Int,
    val createdAt: String,
    val updatedAt: String,
    val user_city: String,
    val user_email: String,
    val user_name: String,
    val user_password: String,
    val user_self_introduce: String,
    val user_state: String,
    val user_state_id: Int,
    val user_status: Int,
    val user_type: String,
    val user_type_id: Int
)

// getConsultants
data class Consultant(
    val __v: Int,
    val _id: Int,
    val createdAt: String,
    val updatedAt: String,
    val user_city: String,
    val user_email: String,
    val user_name: String,
    val user_password: String,
    val user_self_introduce: String,
    val user_state: String,
    val user_state_id: Int,
    val user_status: Int,
    val user_type: String,
    val user_type_id: Int
)
/// apply consultant
 class ApplyConsultantRequest {
    var consultant_id: Int? = null
    var num_tasks_handle: Int? = null
    var num_tasks_replay: Int? = null
    var parent_email: String? = null
    var parent_id: Int? = null
    var parent_name: String? = null
    var status: Int? = null
}

data class ApplyConsultantResponse(
    val __v: Int,
    val _id: Int,
    val consultant_id: Int,
    val createdAt: String,
    val num_tasks_handle: Int,
    val num_tasks_replay: Int,
    val parent_email: String,
    val parent_id: Int,
    val parent_name: String,
    val status: Int,
    val updatedAt: String
)

//Consultant Handle Reply
data class GetApplyResponse(
    val __v: Int,
    val _id: Int,
    val consultant_id: Int,
    val createdAt: String,
    val num_tasks_handle: Int,
    val num_tasks_replay: Int,
    val parent_email: String,
    val parent_id: Int,
    val parent_name: String,
    val status: Int,
    val updatedAt: String
)
//7 Get Tasks
data class TaskSummary(
    val __v: Int,
    val _id: Int,
    val consultant_id: Int,
    val createdAt: String,
    val num_tasks_handle: Int,
    val num_tasks_replay: Int,
    val parent_email: String,
    val parent_id: Int,
    val parent_name: String,
    val status: Int,
    val updatedAt: String
)


//9 assignTask
data class AssignTaskRequest(
    val course_id: Int,
    val goal_break_id: Int,
    val goal_id: Int,
    val task_content: String,
    val task_title: String,
    val user_id: Int
)

data class AssignTaskResponse(
    val __v: Int,
    val _id: Int,
    val course_id: Int,
    val createdAt: String,
    val goal_break_id: Int,
    val goal_id: Int,
    val replays: List<Any>,
    val task_content: String,
    val task_status: Int,
    val task_title: String,
    val updatedAt: String,
    val user_id: Int
)
//10  Reply Task Request

data class ReplyTaskRequest(
    val replay_content: String,
    val replay_title: String,
    val replay_type: Int,
    val replay_vides: List<ReplayVide>,
    val user_id: Int
)

data class ReplayVide(
    val video_name: String,
    val video_path: String
)

data class ReplyTaskResponse(
    val __v: Int,
    val _id: Int,
    val course_id: Int,
    val createdAt: String,
    val goal_break_id: Int,
    val goal_id: Int,
    val replays: List<Replay>,
    val task_content: String,
    val task_status: Int,
    val task_title: String,
    val updatedAt: String,
    val user_id: Int
)

data class Replay(
    val _id: Int,
    val createdAt: String,
    val replay_content: String,
    val replay_title: String,
    val replay_type: Int,
    val replay_vides: List<ReplayVide>,
    val updatedAt: String,
    val user_id: Int
)


//11 getTask by user Id

data class Task(
    val __v: Int,
    val _id: Int,
    val course_id: Int,
    val createdAt: String,
    val goal_break_id: Int,
    val goal_id: Int,
    val replays: List<Replay>,
    val task_content: String,
    val task_status: Int,
    val task_title: String,
    val updatedAt: String,
    val user_id: Int
)

// 12 Set Task done
data class TaskDoneResponse(
    val __v: Int,
    val _id: Int,
    val course_id: Int,
    val createdAt: String,
    val goal_break_id: Int,
    val goal_id: Int,
    val replays: List<Replay>,
    val task_content: String,
    val task_status: Int,
    val task_title: String,
    val updatedAt: String,
    val user_id: Int
)

// add Goal break
data class AddGoalBreakRequest(
    val break_desc: String,
    val break_question: String,
    val break_requirement: String,
    val break_title: String,
    val course_id: Int,
    val goal_id: Int,
    val user_id: Int
)

data class GoalResponse(
    val __v: Int,
    val _id: Int,
    val break_desc: String,
    val break_question: String,
    val break_requirement: String,
    val break_status: Int,
    val break_title: String,
    val course_id: Int,
    val createdAt: String,
    val goal_id: Int,
    val updatedAt: String,
    val user_id: Int
)
//14 update Goal Break

data class UpdateGoalBreakRequest(
    val break_desc: String,
    val break_question: String,
    val break_requirement: String,
    val break_title: String,
    val id: Int
)

//15 Get Goal Break list by consultant id

//16 delte Goal
data class DeleteGoalResponse(
    val __v: Int,
    val _id: Int,
    val break_status: Int,
    val createdAt: String,
    val updatedAt: String
)


data class ProfileResponse(
    val success: Boolean,
    val user: User
)

data class Province(
    val _id: String,
    val city: List<City>,
    val code: Int,
    val name: String
)



data class City(
    val code: Int,
    val district: List<District>,
    val name: String
)

data class District(
    val code: Int,
    val name: String
)

data class Goal(
    val __v: Int,
    val _id: Int,
    val course_goal: String,
    val course_id: Int,
    val course_level: Int,
    val course_level_name: String,
    val course_name: String,
    val course_syllabus: String,
    val course_type: String,
    val createdAt: String,
    val demo_video: List<DemoVideo>,
    val goal_describ: String,
    val goal_name: String,
    val goal_requirement: String,
    val goal_seq: Int,
    val updatedAt: String
)

data class DemoVideo(
    val _id: Int,
    val createdAt: String,
    val updatedAt: String,
    val video_name: String,
    val video_path: String,
    val video_type: String
)

data class Course(
    val __v: Int,
    val _id: Int,
    val course_goal: String,
    val course_level: Int,
    val course_level_name: String,
    val course_name: String,
    val course_syllabus: String,
    val course_type: String,
    val createdAt: String,
    val updatedAt: String
)

data class Goalbreak(
    val __v: Int,
    val _id: Int,
    val break_desc: String,
    val break_question: String,
    val break_requirement: String,
    val break_title: String,
    val course_id: Int,
    val createdAt: String,
    val goal_id: Int,
    val updatedAt: String,
    val user_id: Int
)

data class ConsultReplyApplyResponse(
    val __v: Int,
    val _id: Int,
    val consultant_id: Int,
    val createdAt: String,
    val num_tasks_handle: Int,
    val num_tasks_replay: Int,
    val parent_email: String,
    val parent_id: Int,
    val parent_name: String,
    val status: Int,
    val updatedAt: String
)