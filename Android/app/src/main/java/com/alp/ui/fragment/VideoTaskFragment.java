package com.alp.ui.fragment;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;

import com.alp.R;
import com.yarolegovich.discretescrollview.DiscreteScrollView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;
import androidx.recyclerview.widget.RecyclerView;

public class VideoTaskFragment extends Fragment {
    private static String mStudyFragment="STUDY";
    private static String key="key";
    private static VideoTaskFragment mFragment = null;
    public static VideoTaskFragment getInstance(){
        if(null == mFragment){
            mFragment = new VideoTaskFragment();
            Bundle args = new Bundle();
            args.putString(key,mStudyFragment);
            mFragment.setArguments(args);
        }
        return mFragment;

    }
    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        //TODO create Differnt view depends on diffrent fragment
        View v = inflater.inflate(R.layout.fragment_one,container,false);
        DiscreteScrollView scrollView = v.findViewById(R.id.picker);
        scrollView.setAdapter(new MyAdpater());
        scrollView.setOverScrollEnabled(true);
        scrollView.setHasFixedSize(true);

        DiscreteScrollView scrollView2 = v.findViewById(R.id.picker2);
        scrollView2.setAdapter(new MyAdpater());
        scrollView2.setOverScrollEnabled(true);
        scrollView2.setHasFixedSize(true);
        return v;
    }




    class MyAdpater extends  RecyclerView.Adapter<MyAdpater.MyViewHolder>{
        private int [] size = new int [10];
        @NonNull
        @Override
        public MyViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
            LinearLayout lv = (LinearLayout)LayoutInflater.from(parent.getContext()).inflate(R.layout.class_item,parent,false);
            MyViewHolder vh = new MyViewHolder(lv);
            return vh;
        }

        @Override
        public void onBindViewHolder(@NonNull MyViewHolder holder, int position) {
            //TODO set background and click listerner
            //holder.imageView.setBackground();

        }

        @Override
        public int getItemCount() {
            return size.length;
        }

        public  class MyViewHolder extends RecyclerView.ViewHolder {
            // each data item is just a string in this case
            public ImageView imageView;
            public MyViewHolder(View v) {
                super(v);
                imageView = v.findViewById(R.id.class_shortcut);
            }

        }
    }
}
