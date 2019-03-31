package com.alp.ui;

import android.app.Activity;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;

import com.alp.R;
import com.alp.ui.util.Utils;
import com.alp.web.ApiService;
import com.alp.web.ResultToResponseWithErrorHandlingTransformer;
import com.alp.web.bean.Province;

import java.util.List;

import androidx.annotation.Nullable;
import io.reactivex.Scheduler;
import io.reactivex.android.schedulers.AndroidSchedulers;
import io.reactivex.functions.Action;
import io.reactivex.functions.Consumer;
import io.reactivex.schedulers.Schedulers;
import retrofit2.Response;

public class ChangePWDActivity extends Activity {
    TextView oldPwdTextView;
    TextView newPwdTextView;
    TextView newPwdTextViewConfirm;
    Button cancel;
    Button change;
    ApiService mApiService = ApiService.getInstance();

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.change_password);
        initView();
    }

    private void initView(){
        oldPwdTextView = findViewById(R.id.old_pwd);
        newPwdTextView = findViewById(R.id.new_pwd);
        newPwdTextViewConfirm = findViewById(R.id.new_pwd_twice);
        cancel = findViewById(R.id.cancel_pwd_change);
        change = findViewById(R.id.pwd_change);
        cancel.setOnClickListener(new View.OnClickListener(){
            @Override
            public void onClick(View v) {
                cancelChangePwd();

            }
        });

        change.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                changePWD(oldPwdTextView.getText().toString(),newPwdTextView.getText().toString());

            }
        });

    }

    private void cancelChangePwd(){
        this.finish();
    }

    private void changePWD(String oldPWD, String newPWD){
        mApiService.updatePwd(Utils.getToken(),Utils.getUserId(),oldPWD,newPWD).subscribeOn(Schedulers.io()).observeOn(AndroidSchedulers.mainThread()).compose(new ResultToResponseWithErrorHandlingTransformer<List<Province>>()).subscribe(
                new Consumer<Response<?>>() {
                    @Override
                    public void accept(Response<?> response) throws Exception {
                        List<Province> mResponse =  (List<Province>) response.body();

                    }
                },
                new Consumer<Throwable>() {
                    @Override
                    public void accept(Throwable throwable)  {
                        throwable.printStackTrace();

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
