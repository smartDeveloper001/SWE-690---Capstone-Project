package com.alp.web

import com.alp.web.bean.*
import io.reactivex.Observable
import okhttp3.OkHttpClient
import okhttp3.logging.HttpLoggingInterceptor
import retrofit2.Retrofit
import retrofit2.adapter.rxjava2.Result
import retrofit2.adapter.rxjava2.RxJava2CallAdapterFactory
import retrofit2.converter.gson.GsonConverterFactory
import java.util.concurrent.TimeUnit

class ApiService private constructor(){
    private var client: OkHttpClient? = null
    private var retrofit: Retrofit ?= null
    internal var apiService: ApiEndpoints ?= null
    val  basicUrl:String="http://api.51alp.com/api/"

    init {
        var logging = HttpLoggingInterceptor( HttpLoggingInterceptor.Logger.DEFAULT)
        logging.level = HttpLoggingInterceptor.Level.BODY
        this.client = OkHttpClient.Builder().addInterceptor(logging)
                .connectTimeout(25, TimeUnit.SECONDS)
                .readTimeout(25, TimeUnit.SECONDS)
                .build()

        this.retrofit = Retrofit.Builder().baseUrl(basicUrl).addConverterFactory(GsonConverterFactory.create())
                .addCallAdapterFactory(RxJava2CallAdapterFactory.create())
                .client(client)
                .build()
        this.apiService = retrofit!!.create(ApiEndpoints::class.java)
    }

    companion object {
        @JvmStatic
        val instance by lazy {
            ApiService()
        }
    }

    fun signUp(userInfo: UserInfo): Observable<Result<SignupResponse>> = apiService!!.signUp(userInfo)

    fun signIn(userInfo: UserInfo): Observable<Result<SignInResponse>> = apiService!!.signIn(userInfo)

    fun getProfile(token:String,userId:Int):Observable<Result<ProfileResponse>> = apiService!!.getProfile(token,userId)

    fun getProvinces(token: String):Observable<Result<List<Province>>> = apiService!!.getProvinces(token)

    fun updatePwd(token: String,id:Int, oldpwd:String,newpwd:String):Observable<Result<List<Province>>> = apiService!!.updatePwd(token,id,oldpwd,newpwd)


    fun getConsultants(token: String):Observable<Result<List<Consultant>>> = apiService!!.getConsultants(token)

    fun requestConsultant(token: String,mRequest:ApplyConsultantRequest):Observable<Result<ApplyConsultantResponse>> = apiService!!.requestConsultant(token,mRequest)

    fun getParentTasks(token: String, parentId:Int):Observable<Result<TaskSummary>> = apiService!!.getParentTasks(token,parentId)

    fun getConsultantTasks(token: String, consultantId:Int):Observable<Result<List<TaskSummary>>> = apiService!!.getConsultantTasks(token,consultantId)

    fun getCourses(token: String):Observable<Result<List<Course>>> = apiService!!.getCourses(token)

    fun getGoals(token: String):Observable<Result<List<Goal>>> = apiService!!.getGoal(token)

    fun getGoalBreaks(token:String):Observable<Result<List<Goalbreak>>> = apiService!!.getGoalBreaks(token)

    fun consultantRelyApply(token: String,parentId:Int,answer:Int):Observable<Result<ConsultReplyApplyResponse>> = apiService!!.answerApply(token,parentId,answer)

}