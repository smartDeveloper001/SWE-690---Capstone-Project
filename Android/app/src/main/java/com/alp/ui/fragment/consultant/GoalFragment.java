package com.alp.ui.fragment.consultant;

import android.os.Bundle;
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
import com.alp.web.bean.Goal;

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

public class GoalFragment extends Fragment {
   private static GoalFragment mFragment = null;
    private View v;
    private String key="GoalFragment";
    public static GoalFragment getInstance(){
        if(mFragment == null){
            mFragment= new GoalFragment();
        }
        return mFragment;
    }


    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View v = inflater.inflate(R.layout.goal_layout,container,false);
        this.v = v;
        v.findViewById(R.id.left).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                ConsultantHostFragment.getInstance().getChildFragmentManager().popBackStack();
            }
        });
//        initView(v);
        return  v;
    }

    @Override
    public void onResume() {
        super.onResume();
        getGoals();
    }

    public void getGoals(){
        ApiService.getInstance().getGoals(Utils.getToken()).subscribeOn(Schedulers.io()).observeOn(AndroidSchedulers.mainThread()).compose(new ResultToResponseWithErrorHandlingTransformer<List<Goal>>()).subscribe(

                new Consumer<Response<?>>() {
                    @Override
                    public void accept(Response<?> response) throws Exception {
                        List<Goal> goals =  (List<Goal>) response.body();
                        initView(v, goals);


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
    private void  initView(View v,List<Goal> goals){
        RecyclerView recyclerView =  v.findViewById(R.id.goal_recycleview);
        recyclerView.setHasFixedSize(true);
        RecyclerView.LayoutManager layoutManager = new LinearLayoutManager(getContext());
        recyclerView.setLayoutManager(layoutManager);
        if(goals.size()>0){
           TextView couseName =  v.findViewById(R.id.goal_course_name);
           couseName.setText(goals.get(0).getCourse_name());
        }
        GoalAdapter mAdapter = new GoalAdapter(goals);
        recyclerView.setAdapter(mAdapter);


    }



    private  class GoalAdapter extends RecyclerView.Adapter<GoalAdapter.MyViewHolder>{
        private List<Goal> goals ;

        public GoalAdapter(List<Goal> goals){
            this.goals = new ArrayList<>();
            for(Goal g: goals){
                if(g.getCourse_name().equals(Utils.getCourseName())){
                    this.goals.add(g);
                }
            }
        }
        @NonNull
        @Override
        public MyViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
            LinearLayout layout =(LinearLayout) LayoutInflater.from(parent.getContext()).inflate(R.layout.goal_item,parent,false);
            MyViewHolder hodler = new MyViewHolder(layout);
            return hodler;
        }

        @Override
        public void onBindViewHolder(@NonNull MyViewHolder holder, final int position) {
            holder.goalName.setText(goals.get(position).getGoal_name());
            holder.goToBreak.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    ConsultantHostFragment.getInstance().addChildFragment(GoalBreakFragment.getInstance(),"GoalBreakFragment",true,true);
                    Utils.setGoalID(goals.get(position).get_id());
                }
            });

        }

        @Override
        public int getItemCount() {
            return goals.size();
        }

        private  class MyViewHolder extends  RecyclerView.ViewHolder{

            private TextView goalName;
            private ImageView goToBreak;
            MyViewHolder(View v){
                super(v);
                goalName = v.findViewById(R.id.goal_name);
                goToBreak = v.findViewById(R.id.go_to_break);
            }

        }
    }
}
