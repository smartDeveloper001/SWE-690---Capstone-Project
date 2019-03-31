package com.alp.ui;

import android.app.Activity;
import android.os.Bundle;
import android.view.View;

import com.alp.R;
import com.alp.ui.util.ContentUtil;
import com.alp.ui.util.Utils;
import com.alp.web.ApiService;
import com.alp.web.ResultToResponseWithErrorHandlingTransformer;
import com.alp.web.bean.ApplyConsultantRequest;
import com.alp.web.bean.ApplyConsultantResponse;
import com.alp.web.bean.Consultant;

import io.reactivex.android.schedulers.AndroidSchedulers;
import io.reactivex.functions.Action;
import io.reactivex.functions.Consumer;
import io.reactivex.schedulers.Schedulers;
import retrofit2.Response;

public class RequestConsultantActivity  extends Activity {
    private String TAG = "RequestConsultantActivity";
    ApiService mApiService = ApiService.getInstance();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.request_consultant_confirm);
        findViewById(R.id.request_consultant).setOnClickListener(new View.OnClickListener() {

            @Override
            public void onClick(View v) {
               Consultant mConsultant = ContentUtil.getInstance().getConsultant();
                ApplyConsultantRequest mRequest =new ApplyConsultantRequest();
                mRequest.setConsultant_id(mConsultant.get_id());
                mRequest.setNum_tasks_replay(0);;
                mRequest.setParent_name(Utils.getUserName());
                mRequest.setParent_email(Utils.getUserEmail());
                mRequest.setStatus(2);
                mRequest.setParent_id(Utils.getUserId());
                mRequest.setNum_tasks_handle(0);
                requestConsultant(mRequest);
            }
        });


        findViewById(R.id.cancel_request_consultant).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                close();
            }
        });
    }

    private void requestConsultant(ApplyConsultantRequest mRequest) {
        mApiService.requestConsultant(Utils.getToken(), mRequest).subscribeOn(Schedulers.io()).observeOn(AndroidSchedulers.mainThread()).compose(new ResultToResponseWithErrorHandlingTransformer<ApplyConsultantResponse>()).subscribe(

                new Consumer<Response<?>>() {
                    @Override
                    public void accept(Response<?> response) throws Exception {
                        ApplyConsultantResponse mResponse = (ApplyConsultantResponse) response.body();
                        close();


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
    }

    private void close(){
        finish();
    }
}
