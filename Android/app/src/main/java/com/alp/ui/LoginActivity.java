package com.alp.ui;

import android.app.AlertDialog;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.TextView;

import com.alp.R;
import com.alp.SLog;
import com.alp.web.ApiService;
import com.alp.web.ResultToResponseWithErrorHandlingTransformer;
import com.alp.web.bean.SignInResponse;
import com.alp.web.bean.SignupResponse;
import com.alp.web.bean.UserInfo;
import com.google.gson.Gson;

import androidx.appcompat.app.AppCompatActivity;
import io.reactivex.disposables.CompositeDisposable;
import io.reactivex.disposables.Disposable;
import io.reactivex.functions.Action;
import io.reactivex.functions.Consumer;
import retrofit2.Response;

public class LoginActivity extends AppCompatActivity {

    ApiService mServie = ApiService.getInstance();
    private CompositeDisposable mCompositeDisposable  = new CompositeDisposable();
    final String TAG = "LoginActivity";
    Gson mGson = new Gson();
    private AlertDialog dialog;
    private TextView mEmail;
    private TextView mPwd;
    private Button mLogin;
//    UserInfo mUser = new UserInfo("Hanlu", "123456789", "fenghanlu@gmail.com");
    //signUp(mUser);

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        setContentView(R.layout.activity_main);

        mEmail = findViewById(R.id.user_email);
        mPwd = findViewById(R.id.user_password);
        mLogin = findViewById(R.id.login);
        mLogin.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                //TODO signIn
            }
        });




    }


    private void signUp(UserInfo mUser){
        Disposable mDisposable = mServie.signUp(mUser).compose(new ResultToResponseWithErrorHandlingTransformer<SignupResponse>()).subscribe(
                new Consumer<Response<?>>() {
                    @Override
                    public void accept(Response<?> response) throws Exception {
                        SignInResponse mResponse =  (SignInResponse) response.body();
                        SLog.i(TAG,mGson.toJson(mResponse));

                    }
                },
                new Consumer<Throwable>() {
                    @Override
                    public void accept(Throwable throwable) throws Exception {

                    }
                },
                new Action() {
                    @Override
                    public void run() throws Exception {

                    }
                }
        );
        mCompositeDisposable.add(mDisposable);
    }

    private void signIn(UserInfo mUser){
        Disposable mDisposable = mServie.signIn(mUser).compose(new ResultToResponseWithErrorHandlingTransformer<SignInResponse>()).subscribe(
                new Consumer<Response<?>>() {
                    @Override
                    public void accept(Response<?> response) throws Exception {
                        SignInResponse mResponse =  (SignInResponse) response.body();
                        SLog.i(TAG,mGson.toJson(mResponse));
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
        mCompositeDisposable.add(mDisposable);
    }


    public void showProgressBar(String message) {
        if(null == dialog) {
            AlertDialog.Builder builder = new AlertDialog.Builder(LoginActivity.this, android.R.style.Theme_DeviceDefault_Light_Dialog_Alert);
            builder.setCancelable(false); // if you want user to wait for some process to finish,
            LayoutInflater inflater = getLayoutInflater();
            View dialogLayout = inflater.inflate(R.layout.layout_dialog, null);
            builder.setView(dialogLayout);
//            builder.setView(R.layout.layout_dialog);
            dialog = builder.create();
            dialog.getWindow().setBackgroundDrawable(new ColorDrawable(Color.TRANSPARENT));
            WindowManager.LayoutParams wmlp = dialog.getWindow().getAttributes();
            wmlp.gravity = Gravity.CENTER;
            dialog.getWindow().setAttributes(wmlp);
        }
        dialog.show();
        ((TextView)dialog.findViewById(R.id.progress_dialog_text)).setText(message);
    }

    public void dialogDismiss() {
        if (null != dialog && dialog.isShowing()) {
            dialog.dismiss();
            dialog = null;
        }
    }
}




