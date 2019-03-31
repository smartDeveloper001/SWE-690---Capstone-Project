package com.alp.ui;

import android.net.Uri;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.View;

import com.alp.R;
import com.alp.SLog;
import com.alp.ui.fragment.HostFragment;
import com.alp.ui.fragment.MyFragmentAdapter;
import com.alp.ui.fragment.profile.ProfileFragment;
import com.alp.ui.util.Utils;
import com.alp.web.ApiService;
import com.alp.web.ResultToResponseWithErrorHandlingTransformer;
import com.alp.web.bean.SignInResponse;
import com.alp.web.bean.UserInfo;
import com.google.gson.Gson;

import androidx.appcompat.app.AppCompatActivity;
import androidx.viewpager.widget.ViewPager;
import io.reactivex.android.schedulers.AndroidSchedulers;
import io.reactivex.disposables.Disposable;
import io.reactivex.functions.Action;
import io.reactivex.functions.Consumer;
import io.reactivex.schedulers.Schedulers;
import retrofit2.Response;

public class HomeActivity extends AppCompatActivity {
    public static String TAG = "HomeActivity";
    MyFragmentAdapter mAdapter;
    ViewPager mPager;
    ApiService mServie = ApiService.getInstance();//TODO remove
    Gson mGson = new Gson();
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.home);
        initUI();
//        getDirectory();
        login("consultant3@consultant.com","aaaaaaaa");

    }

    private void initUI(){
        mAdapter = new MyFragmentAdapter(getSupportFragmentManager());
        mPager = findViewById(R.id.pager);
        mPager.setAdapter(mAdapter);

        mPager.setCurrentItem(0);
        findViewById(R.id.study_item).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                mPager.setCurrentItem(0);
            }
        });

        findViewById(R.id.second_item).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                mPager.setCurrentItem(1);
            }
        });

        findViewById(R.id.third_item).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                mPager.setCurrentItem(2);
            }
        });

        findViewById(R.id.four_item).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                mPager.setCurrentItem(3);
                //TODO we should check popup child fragment
                HostFragment host = HostFragment.getInstance();

                ProfileFragment mProfileFragment = ProfileFragment.getInstance();
                if(null == host.getChildFragmentManager().findFragmentByTag(mProfileFragment.getKey())){

                    ( (HostFragment) mAdapter.getItem(3)).addFragment(mProfileFragment,mProfileFragment.getKey(),false,false);
                }



            }
        });
    }

    public  void getDirectory() {


      Uri uri=   Uri.fromFile( getCacheDir());
        SLog.i(TAG+"uri",getCacheDir()+"");
        SLog.i(TAG+"uri",uri.toString());
        uri = Uri.parse(uri.toString());
        SLog.i(TAG+"uri",uri.toString());



        Uri myUri = Uri.parse("http://stackoverflow.com");
        SLog.i(TAG+"uri",myUri.toString());
    }

    public void login(String userName,String password){
        UserInfo mUser = new UserInfo(null,userName, password,null,null);
        //TODO remove in the future
        if(!TextUtils.isEmpty(Utils.getToken())){
//            return;
        }
        Disposable mDisposable = mServie.signIn(mUser).subscribeOn(Schedulers.io()).observeOn(AndroidSchedulers.mainThread()).compose(new ResultToResponseWithErrorHandlingTransformer<SignInResponse>()).subscribe(
                new Consumer<Response<?>>() {
                    @Override
                    public void accept(Response<?> response) throws Exception {
                        SignInResponse mResponse =  (SignInResponse) response.body();
                        Utils.mReponse = mResponse;
                        SLog.i(TAG,mGson.toJson(mResponse));
                        Utils.saveToken(mResponse.getToken());
                        Utils.saveID(mResponse.getUser().get_id());
                        Utils.saveUserEmail(mResponse.getUser().getUser_email());
                        Utils.saveUserName(mResponse.getUser().getUser_name());
                    }
                },
                new Consumer<Throwable>() {
                    @Override
                    public void accept(Throwable throwable)  {

                    }
                },
                new Action() {
                    @Override
                    public void run()  {

                    }
                }
        );
    }

}
