package com.alp.ui.fragment.consultant;

import android.os.Bundle;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.alp.R;
import com.alp.ui.util.Utils;
import com.alp.web.ApiService;
import com.alp.web.ResultToResponseWithErrorHandlingTransformer;
import com.alp.web.bean.Goalbreak;

import java.util.ArrayList;
import java.util.List;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import io.reactivex.android.schedulers.AndroidSchedulers;
import io.reactivex.functions.Action;
import io.reactivex.functions.Consumer;
import io.reactivex.schedulers.Schedulers;
import retrofit2.Response;

public class GoalBreakFragment extends Fragment {
    private static GoalBreakFragment mFragment;
    private View v;

    public static GoalBreakFragment getInstance(){
        if(mFragment == null){
            mFragment= new GoalBreakFragment();
        }
        return mFragment;
    }



    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View v = inflater.inflate(R.layout.goal_break_layout,container,false);
        this.v = v;
        v.findViewById(R.id.left).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                ConsultantHostFragment.getInstance().getChildFragmentManager().popBackStack();
            }
        });
       // ((TextView)v.findViewById(R.id.goal_break)).setText("abc");

        return  v;
    }

    @Override
    public void onResume() {
        super.onResume();
        getGoalBreak();;

    }

    private void getGoalBreak(){
        ApiService.getInstance().getGoalBreaks(Utils.getToken()).subscribeOn(Schedulers.io()).observeOn(AndroidSchedulers.mainThread()).compose(new ResultToResponseWithErrorHandlingTransformer<List<Goalbreak>>()).subscribe(

                new Consumer<Response<?>>() {
                    @Override
                    public void accept(Response<?> response) throws Exception {
                        List<Goalbreak> goals =  (List<Goalbreak>) response.body();
                        initView(goals);


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
    private void initView(List<Goalbreak> gb){
        RecyclerView recyclerView =  v.findViewById(R.id.goal_break_recycleview);
        recyclerView.setHasFixedSize(true);
        RecyclerView.LayoutManager layoutManager = new LinearLayoutManager(getContext());
        recyclerView.setLayoutManager(layoutManager);
        if(gb.size()>0){
            TextView couseName =  v.findViewById(R.id.goal_break);
            couseName.setText("Break id: "+gb.get(0).get_id());
        }
        GoalBreakAdapter mAdapter = new GoalBreakAdapter(gb);
        recyclerView.setAdapter(mAdapter);
    }
    private  class GoalBreakAdapter extends RecyclerView.Adapter<GoalBreakAdapter.MyViewHolder>{
        private List<Goalbreak> goalbreaks;

        public GoalBreakAdapter(List<Goalbreak> goals){
            this.goalbreaks = new ArrayList<>();
            for(Goalbreak gb: goals){
                if(gb.get_id()== Utils.getGoalID()){
                    this.goalbreaks.add(gb);
                }
            }
        }
        @NonNull
        @Override
        public MyViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
            LinearLayout layout =(LinearLayout) LayoutInflater.from(parent.getContext()).inflate(R.layout.goal_break_item,parent,false);
            MyViewHolder hodler = new MyViewHolder(layout);
            return hodler;
        }

        @Override
        public void onBindViewHolder(@NonNull MyViewHolder holder, int position) {
            if(!TextUtils.isEmpty(goalbreaks.get(position).getBreak_title())) {
                holder.goalBreakName.setText(goalbreaks.get(position).getBreak_title());
            }
            holder.createTask.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {

                }
            });

        }

        @Override
        public int getItemCount() {
            return goalbreaks.size();
        }

        private  class MyViewHolder extends  RecyclerView.ViewHolder{

            private TextView goalBreakName;
            private ImageView createTask;
            MyViewHolder(View v){
                super(v);
                goalBreakName = v.findViewById(R.id.goal_break);
                createTask = v.findViewById(R.id.create_task);
            }

        }
    }


}
