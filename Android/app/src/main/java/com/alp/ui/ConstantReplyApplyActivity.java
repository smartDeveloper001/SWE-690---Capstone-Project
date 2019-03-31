package com.alp.ui;

import android.app.Activity;
import android.os.Bundle;
import android.view.View;

import com.alp.R;
import com.alp.ui.util.Utils;
import com.alp.web.ApiService;
import com.alp.web.ResultToResponseWithErrorHandlingTransformer;
import com.alp.web.bean.ConsultReplyApplyResponse;

import io.reactivex.android.schedulers.AndroidSchedulers;
import io.reactivex.functions.Action;
import io.reactivex.functions.Consumer;
import io.reactivex.schedulers.Schedulers;
import retrofit2.Response;

    public class ConstantReplyApplyActivity extends Activity {
        private String TAG = "RequestConsultantActivity";
        ApiService mApiService = ApiService.getInstance();
        int parentId;


        @Override
        protected void onCreate(Bundle savedInstanceState) {
            super.onCreate(savedInstanceState);
            setContentView(R.layout.consultant_reply_apply);
            parentId = getIntent().getIntExtra("parent",0);
            findViewById(R.id.accept_apply).setOnClickListener(new View.OnClickListener() {

                @Override
                public void onClick(View v) {

                    answerReply(parentId,1);
                }
            });


            findViewById(R.id.deny_apply).setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    answerReply(parentId,0);

                }
            });
        }

        private void answerReply(int parentId,int answer) {
            mApiService.consultantRelyApply(Utils.getToken(), parentId,answer).subscribeOn(Schedulers.io()).observeOn(AndroidSchedulers.mainThread()).compose(new ResultToResponseWithErrorHandlingTransformer<ConsultReplyApplyResponse>()).subscribe(

                    new Consumer<Response<?>>() {
                        @Override
                        public void accept(Response<?> response) throws Exception {
                            ConsultReplyApplyResponse mResponse = (ConsultReplyApplyResponse) response.body();
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

        private void close() {
            finish();
        }
    }

