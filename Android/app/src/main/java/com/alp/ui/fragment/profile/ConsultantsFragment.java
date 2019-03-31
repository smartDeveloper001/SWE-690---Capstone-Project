package com.alp.ui.fragment.profile;

import android.content.Intent;
import android.graphics.Color;
import android.graphics.drawable.ShapeDrawable;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.alp.R;
import com.alp.ui.RequestConsultantActivity;
import com.alp.ui.fragment.HostFragment;
import com.alp.ui.util.ContentUtil;
import com.alp.ui.util.Utils;
import com.alp.web.ApiService;
import com.alp.web.ResultToResponseWithErrorHandlingTransformer;
import com.alp.web.bean.Consultant;

import java.util.ArrayList;
import java.util.List;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.constraintlayout.widget.ConstraintLayout;
import androidx.fragment.app.Fragment;
import androidx.recyclerview.widget.DividerItemDecoration;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import io.reactivex.android.schedulers.AndroidSchedulers;
import io.reactivex.functions.Action;
import io.reactivex.functions.Consumer;
import io.reactivex.schedulers.Schedulers;
import retrofit2.Response;

public class ConsultantsFragment extends Fragment {
    private String TAG ="ConsultantsFragment";
    public  static final String constultant="ConsultantsFragment";
    private ApiService apiService = ApiService.getInstance();
    private static String key="ConsultantsFragment";
    static  ConsultantsFragment mFragment;
    private RecyclerView mRecyclerView = null;
    private RecyclerView.LayoutManager layoutManager;
    private ConsultantsAdapter mAdapter;

    private View v;

    public static ConsultantsFragment getInstance(){
        if(null == mFragment){
            mFragment = new ConsultantsFragment();
            // Supply num input as an argument.
            Bundle args = new Bundle();
            args.putString(key, constultant);
            mFragment.setArguments(args);
        }
        return mFragment;
    }
    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
         v = inflater.inflate(R.layout.consultants,container,false);

        return v;
    }

    @Override
    public void onResume() {
        super.onResume();
        if(null != v)
        initView(v);
    }

    private void initView(View v){
        mRecyclerView = v.findViewById(R.id.consultants);
        mRecyclerView.setHasFixedSize(true);
        layoutManager = new LinearLayoutManager(getContext());
        mRecyclerView.setLayoutManager(layoutManager);
        DividerItemDecoration divider = new DividerItemDecoration(getActivity(), DividerItemDecoration.VERTICAL);
        ShapeDrawable mShapeDrawable = new ShapeDrawable();
        mShapeDrawable.setIntrinsicHeight(getResources().getDimensionPixelOffset(R.dimen.divider));
        mShapeDrawable.getPaint().setColor(Color.BLACK);
        divider.setDrawable(mShapeDrawable);
        mRecyclerView.addItemDecoration(divider);
        v.findViewById(R.id.left).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                closeCurFragment();
            }
        });
        getConsultants();
    }

    private void getConsultants(){
        apiService.getConsultants(Utils.getToken()).subscribeOn(Schedulers.io()).observeOn(AndroidSchedulers.mainThread()).compose(new ResultToResponseWithErrorHandlingTransformer<List<Consultant>>()).subscribe(
                new Consumer<Response<?>>() {
                    @Override
                    public void accept(Response<?> response) throws Exception {
                        List<Consultant> mResponse =  (List<Consultant>) response.body();
                        mAdapter = new ConsultantsAdapter(mResponse);
                        mRecyclerView.setAdapter(mAdapter);
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

      class ConsultantsAdapter extends RecyclerView.Adapter<ConsultantsAdapter.MyViewHolder> {

        List<Consultant> consultants = new ArrayList<>();

        ConsultantsAdapter( List<Consultant> consultants){
            this.consultants = consultants;
        }

        public  class MyViewHolder extends RecyclerView.ViewHolder {
            // each data item is just a string in this case

            TextView requestConsultant;
            TextView consultantName;
            public MyViewHolder(View v) {
                super(v);
                consultantName = v.findViewById(R.id.consult_name);
                consultantName.setClickable(false);
                requestConsultant = v.findViewById(R.id.consult_request);

            }
        }

        @NonNull
        @Override
        public MyViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
            ConstraintLayout lv = (ConstraintLayout)LayoutInflater.from(parent.getContext()).inflate(R.layout.consultant_item,parent,false);
            ConsultantsAdapter.MyViewHolder vh = new ConsultantsAdapter.MyViewHolder(lv);
            return vh;
        }

        @Override
        public void onBindViewHolder(@NonNull MyViewHolder holder, final int position) {
            Consultant mConsultant = consultants.get(position);
            holder.consultantName.setText(mConsultant.getUser_name());
            holder.requestConsultant.setClickable(true);
            holder.requestConsultant.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {

                    //TODO request consultant
                    ContentUtil.getInstance().setConsultant(consultants.get(position));
                    startActivity();

                }
            });

        }

        @Override
        public int getItemCount() {
            return consultants.size();
        }


    }


    private void startActivity(){
        Intent mIntent = new Intent(getActivity(), RequestConsultantActivity.class);
        startActivity(mIntent);
    }

    public String getKey(){
        return  key;
    }

    private  void closeCurFragment(){
        HostFragment host = HostFragment.getInstance();
        host.getChildFragmentManager().popBackStack();

    }

}


