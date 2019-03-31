package com.alp.web

import com.alp.web.bean.*
import io.reactivex.Observable
import retrofit2.adapter.rxjava2.Result
import retrofit2.http.*

interface ApiEndpoints {
    @Headers("Accept: application/json;charset=utf-8", "Content-Type: application/json;charset=utf-8")
    @POST("signup")
    fun signUp(
            @Body mRequest: UserInfo): Observable<Result<SignupResponse>>

    @Headers("Accept: application/json;charset=utf-8", "Content-Type: application/json;charset=utf-8")
    @POST("login")
    fun signIn(
            @Body mRequest: UserInfo): Observable<Result<SignInResponse>>



    @Headers("Accept: application/json;charset=utf-8", "Content-Type: application/json;charset=utf-8")
    @GET("user/{userId}")
    fun getProfile(@Header("token") token:String,
            @Path("userId") userId:Int): Observable<Result<ProfileResponse>>

    @Headers("Accept: application/json;charset=utf-8", "Content-Type: application/json;charset=utf-8")
    @GET("cities")
    fun getProvinces(@Header("token") token:String): Observable<Result<List<Province>>>

    //get all consultants
    @Headers("Accept: application/json;charset=utf-8", "Content-Type: application/json;charset=utf-8")
    @GET("consultants")
    fun getConsultants(@Header("token") token:String): Observable<Result<List<Consultant>>>


    //ask to connect a consultant
    @Headers("Accept: application/json;charset=utf-8", "Content-Type: application/json;charset=utf-8")
    @POST("parentConsultant")
    fun requestConsultant(@Header("token") token:String,@Body mRequest:ApplyConsultantRequest): Observable<Result<ApplyConsultantResponse>>

    //parent get all of the pending task
    @Headers("Accept: application/json;charset=utf-8", "Content-Type: application/json;charset=utf-8")
    @GET("parentConsultant/parent/{parentId}")
    fun getParentTasks(@Header("token") token:String, @Path("parentId") parentId:Int): Observable<Result<TaskSummary>>


    @Headers("Accept: application/json;charset=utf-8", "Content-Type: application/json;charset=utf-8")
    @PUT("parentConsultant/{parentId}/{answer}")
    fun answerApply(@Header("token") token:String,@Path("parentId") parentId:Int,@Path("answer") answer:Int): Observable<Result<ConsultReplyApplyResponse>>


    //parent get all of the pending task
    @Headers("Accept: application/json;charset=utf-8", "Content-Type: application/json;charset=utf-8")
    @GET("parentConsultant/consultant/{consultantId}")
    fun getConsultantTasks(@Header("token") token:String, @Path("consultantId") consultantId:Int): Observable<Result<List<TaskSummary>>>

    @Headers("Accept: application/json;charset=utf-8", "Content-Type: application/json;charset=utf-8")
    @PUT("user/{userId}/{oldpwd}/{newpwd}")
    fun updatePwd(@Header("token") token:String,@Path("userId") userId:Int,@Path("oldpwd") oldpwd:String,@Path("newpwd") newpwd:String): Observable<Result<List<Province>>>


    @Headers("Accept: application/json;charset=utf-8", "Content-Type: application/json;charset=utf-8")
    @GET("gogals")
    fun getGoal(@Header("token")token: String): Observable<Result<List<Goal>>>

    @Headers("Accept: application/json;charset=utf-8", "Content-Type: application/json;charset=utf-8")
    @GET("courses")
    fun getCourses(@Header("token")token: String): Observable<Result<List<Course>>>


    @Headers("Accept: application/json;charset=utf-8", "Content-Type: application/json;charset=utf-8")
    @GET("gogalbreaks")
    fun getGoalBreaks(@Header("token")token: String): Observable<Result<List<Goalbreak>>>

}