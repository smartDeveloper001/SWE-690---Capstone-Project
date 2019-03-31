package com.alp.ui.util;

import android.app.Activity;
import android.content.Context;
import android.content.SharedPreferences;

import com.alp.SLog;
import com.alp.ui.AlpApplication;
import com.alp.web.bean.SignInResponse;

public class Utils {
    private static String TAG="Utils";
    static private AlpApplication mApplication = null;
    private static String ALP="ALP";
    private static SharedPreferences sharedPreferences;
    private static SharedPreferences.Editor editor;
    public static SignInResponse mReponse;
    public static String userID="userID";
    public static String userName="userName";
    public static String userEmail="userEmail";
    public static String PROVINCES ="PROVINCES";
    private static String mToken="token";
    private static String course="COURSE";
    private static String goals="GOALS";
    private static String COURSE_NAME="COURSE NAME";
    private static int GOAL_ID=0;
    public static  void setApplication(AlpApplication context){
        mApplication = context;
        createSharedPreference();
    }

    public static Context getApplication(){
        return getApplication();
    }
    public static AlpApplication getmApplication(){
        return mApplication;
    }

    public static void createSharedPreference(){
        sharedPreferences = mApplication.getSharedPreferences(ALP,Activity.MODE_PRIVATE);
        editor = sharedPreferences.edit();

    }
    public static void saveToken(String token){
        editor.putString(mToken,token);
        editor.apply();

    }

    public static String getToken() {
        SLog.i(TAG,"token: "+sharedPreferences.getString(mToken, ""));
        return sharedPreferences.getString(mToken, "");
    }

    public static void saveProvince(String city){
        editor.putString(PROVINCES,city);
        editor.apply();

    }

    public static String getCity(){
        return  sharedPreferences.getString(PROVINCES,"");

    }

    public static int getUserId(){

        return  sharedPreferences.getInt(userID,0);
    }

    public static void saveID(int userId){
        editor.putInt(userID,userId);
        editor.apply();
    }

    public static String getUserName(){
        return  sharedPreferences.getString(userName,"");
    }

    public static void saveUserName(String name){
        editor.putString(userName,name);
        editor.apply();
    }

    public static String getUserEmail(){

        return  sharedPreferences.getString(userEmail,"");
    }

    public static void saveUserEmail(String mUserEmail){
        editor.putString(userEmail,mUserEmail);
        editor.apply();
    }

    public static  String getCourses(){
        return  sharedPreferences.getString(course,"");
    }

    public static void saveCourse(String mCourse){
        editor.putString(course,mCourse);
        editor.apply();
    }

    public static String getGoal(){
        return  sharedPreferences.getString(goals,"");
    }

    public static void saveGoal(String mGoal){
        editor.putString(goals,mGoal);
        editor.apply();
    }

    public static String getCourseName() {
        return COURSE_NAME;
    }

    public static void setCourseName(String courseName) {
        COURSE_NAME = courseName;
    }

    public static void setGoalID(int id){
        GOAL_ID = id;
    }

    public static int getGoalID(){
        return GOAL_ID;
    }
}
