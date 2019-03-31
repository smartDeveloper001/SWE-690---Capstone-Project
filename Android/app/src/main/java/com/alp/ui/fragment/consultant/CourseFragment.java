package com.alp.ui.fragment.consultant;

import android.content.Context;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;

import com.alp.R;
import com.alp.ui.util.Utils;
import com.alp.web.ApiService;
import com.alp.web.ResultToResponseWithErrorHandlingTransformer;
import com.alp.web.bean.Course;
import com.google.gson.Gson;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;
import io.reactivex.android.schedulers.AndroidSchedulers;
import io.reactivex.functions.Action;
import io.reactivex.functions.Consumer;
import io.reactivex.schedulers.Schedulers;
import retrofit2.Response;

public class CourseFragment extends Fragment {
    private static CourseFragment mFragment = null;
    public static  String key="CourseFragment";
    private ApiService apiService = ApiService.getInstance();
    private Gson mGson = new Gson();
    private View v;
    private List<Object> mlist = new ArrayList<>();
    private Map<String,List<Course>> map = new HashMap<>();
    private Set<String> set = new LinkedHashSet<>();

    public static CourseFragment getInstance(){
        if(mFragment == null){
            mFragment = new CourseFragment();
        }
        return  mFragment;
    }

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View v = inflater.inflate(R.layout.cousre_layout,container,false);
        this.v = v;
        v.findViewById(R.id.left).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                ConsultantHostFragment.getInstance().getChildFragmentManager().popBackStack();
            }
        });
        return  v;
    }

    @Override
    public void onResume() {
        super.onResume();
        getCourses();
    }

    private void  initView(List<Object> mlist){
        ListView ListView =  v.findViewById(R.id.course_recycleview);
        CourseAdapter mAdapter = new CourseAdapter(getContext(),mlist);
        ListView.setAdapter(mAdapter);


    }

    public void getCourses(){
        apiService.getCourses(Utils.getToken()).subscribeOn(Schedulers.io()).observeOn(AndroidSchedulers.mainThread()).compose(new ResultToResponseWithErrorHandlingTransformer<List<Course>>()).subscribe(

                new Consumer<Response<?>>() {
                    @Override
                    public void accept(Response<?> response) throws Exception {
                        List<Course> courses =  (List<Course>) response.body();
                        for(Course c: courses){

                            if(!set.contains(c.getCourse_level())){
                                set.add(c.getCourse_level_name());
                            }
                            if(map.containsKey(c.getCourse_level_name())){
                                map.get(c.getCourse_level_name()).add(c);
                            }else{
                               List<Course> list = new ArrayList<>();
                               list.add(c);
                               map.put(c.getCourse_level_name(),list);
                            }

                        }
                        for(String s: set){
                            mlist.add(s);
                            mlist.addAll(map.get(s));
                        }

                        initView(mlist);


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

    private class CourseAdapter  extends BaseAdapter {

        private List<Object> couseList= new ArrayList<>();


        private LayoutInflater mLayoutInflater;


        public CourseAdapter(Context context,List<Object> couseList) {
            this.couseList = couseList;
            mLayoutInflater= LayoutInflater.from(context);
        }


        @Override
        public long getItemId(int position) {
            return 0;
        }

        @Override
        public int getCount() {
            return couseList.size();
        }

        @Override
        public Object getItem(int position) {
            return couseList.get(position);
        }

        @Override
        public View getView(int position, View convertView, ViewGroup parent) {
            MyViewHolder holder = null;
            if(null == convertView){
                convertView = mLayoutInflater.inflate(R.layout.couse_item,null);
                holder = new MyViewHolder();
                holder.courseLevleName = convertView.findViewById(R.id.course_level_name);
                holder.courseName = convertView.findViewById(R.id.course_name);
                holder.courseDetailItem = convertView.findViewById(R.id.course_detail_layout);
                holder.goToGoalView = convertView.findViewById(R.id.go_to_goal);
                convertView.setTag(holder);
            }else{
                holder =(MyViewHolder) convertView.getTag();
            }
            final Object item = couseList.get(position);
            holder.goToGoalView.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    if(item instanceof String){
                        Utils.setCourseName((String)item);
                    }else{
                        Utils.setCourseName(((Course)item).getCourse_name());
                    }

                    ConsultantHostFragment.getInstance().addChildFragment(GoalFragment.getInstance(),"GoalFragment",true,true);
                }
            });


            if(item instanceof String){
                holder.courseDetailItem.setVisibility(View.GONE);
                holder.courseLevleName.setVisibility(View.VISIBLE);
                holder.courseLevleName.setText((String)item);
            }else{
                holder.courseLevleName.setVisibility(View.GONE);
                holder.courseDetailItem.setVisibility(View.VISIBLE);
                holder.courseName.setText(((Course)item).getCourse_name());
            }
            return convertView;
        }

        private  class MyViewHolder {

            private TextView courseLevleName;
            private View courseDetailItem;
            private TextView courseName;
            private ImageView goToGoalView;
            MyViewHolder(){

            }

        }
    }
}
