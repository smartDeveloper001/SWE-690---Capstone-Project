package com.alp.ui.fragment.consultant;

import android.content.Intent;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.TextView;

import com.alp.R;
import com.alp.ui.ConstantReplyApplyActivity;
import com.alp.ui.util.Utils;
import com.alp.web.ApiService;
import com.alp.web.ResultToResponseWithErrorHandlingTransformer;
import com.alp.web.bean.TaskSummary;

import java.util.ArrayList;
import java.util.List;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.constraintlayout.widget.ConstraintLayout;
import androidx.fragment.app.Fragment;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import io.reactivex.android.schedulers.AndroidSchedulers;
import io.reactivex.functions.Action;
import io.reactivex.functions.Consumer;
import io.reactivex.schedulers.Schedulers;
import retrofit2.Response;

public class ConsultantTaskCaseFragment extends Fragment {
    private static String mThree ="ConsultantTaskCaseFragment";
    private static String key="key";
    private static ConsultantTaskCaseFragment mFragment = null;
    private RecyclerView mCurrentTaskRecycleView = null;
    private RecyclerView newTaskRecycleView = null;
    private CurrentTaskCaseAdapter mAdapter;
    private NewTaskCaseAdapter newTaskAdapter;
    private ApiService apiService = ApiService.getInstance();
    private List<TaskSummary> newParentCase= new ArrayList<>();
    private List<TaskSummary> oldParentCase = new ArrayList<>();
    private View mlayout =null;

    public static ConsultantTaskCaseFragment getInstance(){
        if(null == mFragment){
            mFragment = new ConsultantTaskCaseFragment();
            Bundle args = new Bundle();
            args.putString(key, mThree);
            mFragment.setArguments(args);
        }
        return  mFragment;
    }
    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View v = inflater.inflate(R.layout.class_select,container,false);
        mlayout = v;

        return v;
    }

    @Override
    public void onResume() {
        super.onResume();
        getTask();
    }

    private void getTask(){
        apiService.getConsultantTasks(Utils.getToken(),Utils.getUserId()).subscribeOn(Schedulers.io()).observeOn(AndroidSchedulers.mainThread()).compose(new ResultToResponseWithErrorHandlingTransformer<List<TaskSummary>>()).subscribe(
                new Consumer<Response<?>>() {
                    @Override
                    public void accept(Response<?> response) throws Exception {
                        List<TaskSummary> mResponse =  (List<TaskSummary> ) response.body();
                        for(TaskSummary mTask: mResponse){
                            if(mTask.getStatus()==2){
                                newParentCase.add(mTask);
                            }else {
                                oldParentCase.add(mTask);
                            }
                        }
                        initView();
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
    private void initView(){
        //For current parent Case
        mCurrentTaskRecycleView = mlayout.findViewById(R.id.current_parent_case);
        mCurrentTaskRecycleView.setHasFixedSize(true);
        // use a linear layout manager
        RecyclerView.LayoutManager layoutManager = new LinearLayoutManager(getContext());
        mCurrentTaskRecycleView.setLayoutManager(layoutManager);
        mAdapter = new CurrentTaskCaseAdapter(oldParentCase);
        mCurrentTaskRecycleView.setAdapter(mAdapter);


        //for new parent case
        newTaskRecycleView = mlayout.findViewById(R.id.new_parent_request);
        newTaskRecycleView.setHasFixedSize(true);
        // use a linear layout manager
        layoutManager = new LinearLayoutManager(getContext());
        newTaskRecycleView.setLayoutManager(layoutManager);
        newTaskAdapter = new NewTaskCaseAdapter(newParentCase);
        newTaskRecycleView.setAdapter(newTaskAdapter);
    }

    /**
     * Current my case (parents are already my customer)
     */
    static class CurrentTaskCaseAdapter extends RecyclerView.Adapter<CurrentTaskCaseAdapter.MyViewHolder>{

        private List<TaskSummary> taskList = new ArrayList<>();

        public CurrentTaskCaseAdapter(List<TaskSummary> taskList){
            this.taskList = taskList;
        }


        public static class MyViewHolder extends RecyclerView.ViewHolder {
            // each data item is just a string in this case

            Button newTask;
            Button checkTask;
            TextView name;
            public MyViewHolder(View v) {
                super(v);
                newTask = v.findViewById(R.id.task_new);
                newTask.setOnClickListener(new View.OnClickListener(){

                    @Override
                    public void onClick(View v) {
                        ConsultantHostFragment.getInstance().addChildFragment(CourseFragment.getInstance(),CourseFragment.key,true,true);

                    }
                });
                checkTask = v.findViewById(R.id.check_task_detail);
                name = v.findViewById(R.id.task_profile_name);
            }
        }


        @NonNull
        @Override
        public MyViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
            ConstraintLayout lv = (ConstraintLayout)LayoutInflater.from(parent.getContext()).inflate(R.layout.task_item,parent,false);
            MyViewHolder vh = new MyViewHolder(lv);
            return vh;
        }

        @Override
        public void onBindViewHolder(@NonNull MyViewHolder holder, int position) {
            holder.name.setText(taskList.get(position).getParent_name());
        }

        @Override
        public int getItemCount() {
            return taskList.size();
        }
    }

    /**
     * Current my case (parents are already my customer)
     */
     class NewTaskCaseAdapter extends RecyclerView.Adapter<NewTaskCaseAdapter.MyViewHolder>{


        private List<TaskSummary> taskList = new ArrayList<>();
        public NewTaskCaseAdapter(List<TaskSummary> taskList){
            this.taskList = taskList;
        }

        public  class MyViewHolder extends RecyclerView.ViewHolder {
            // each data item is just a string in this case

            Button newTask;
            Button checkTask;
            TextView name;
            public MyViewHolder(View v) {
                super(v);
                newTask = v.findViewById(R.id.task_new);

                checkTask = v.findViewById(R.id.check_task_detail);
                name = v.findViewById(R.id.task_profile_name);
            }
        }


        @NonNull
        @Override
        public MyViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
            ConstraintLayout lv = (ConstraintLayout)LayoutInflater.from(parent.getContext()).inflate(R.layout.task_item,parent,false);
            MyViewHolder vh = new MyViewHolder(lv);
            return vh;
        }

        @Override
        public void onBindViewHolder(@NonNull MyViewHolder holder, final int position) {
            holder.name.setText(taskList.get(position).getParent_name());
            holder.newTask.setVisibility(View.INVISIBLE);
            holder.checkTask.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {


                    startActivity(taskList.get(position).getParent_id());



                }
            });
        }

        @Override
        public int getItemCount() {
            return taskList.size();
        }




    }

    void   startActivity(int parentId){
        Intent mIntent = new Intent(ConsultantTaskCaseFragment.this.getContext(), ConstantReplyApplyActivity.class);
        mIntent.putExtra("parentId",parentId);
        startActivity(mIntent);

    }

}
