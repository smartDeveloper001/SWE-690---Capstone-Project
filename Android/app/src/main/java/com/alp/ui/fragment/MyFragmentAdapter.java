package com.alp.ui.fragment;

import com.alp.ui.fragment.consultant.ConsultantHostFragment;

import java.util.ArrayList;
import java.util.List;

import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentManager;
import androidx.fragment.app.FragmentPagerAdapter;

public class MyFragmentAdapter extends FragmentPagerAdapter {
    String TAG="MyFragmentAdapter";
    List<Fragment> mlist = new ArrayList<>();
    //视频课程 (处理任务) (剖析管理) 学习任务  我的视频  我的信息
    //视频课程 处理任务 剖析管理 （学习任务）  我的视频  我的信息
    public MyFragmentAdapter(FragmentManager fm) {
        super(fm);
        VideoTaskFragment mStudyFragment = VideoTaskFragment.getInstance();


        ConsultantHostFragment consultantTask = ConsultantHostFragment.getInstance();
        FourFragment fourFragment = FourFragment.getInstance();

        HostFragment hostFragment = HostFragment.getInstance();

        mlist.add(mStudyFragment);
        mlist.add(consultantTask);
        mlist.add(fourFragment);
        mlist.add(hostFragment);

    }

    @Override
    public Fragment getItem(int position) {
        return mlist.get(position);
    }

    @Override
    public int getCount() {
        return mlist.size();
    }



}
