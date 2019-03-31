package com.alp.ui.fragment;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.alp.R;
import com.alp.SLog;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentPagerAdapter;
import androidx.fragment.app.FragmentTransaction;

public class HostFragment extends BaseFragment{
    String ID="HostFragment";
    private static  HostFragment mFragment;
    private  static String TAG ="HostFragment";


    private MyFragmentAdapter adapter;

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        super.onCreateView(inflater, container, savedInstanceState);
        View view = inflater.inflate(R.layout.host_fragment, container, false);
        return view;
    }


    public void replaceFragment(Fragment fragment, boolean addToBackstack) {
        //TODO
        FragmentTransaction fx =getChildFragmentManager().beginTransaction();
        if (addToBackstack) {

            fx .replace(R.id.hosted_fragment, fragment).addToBackStack(null).commit();
        } else {

            fx.add(R.id.hosted_fragment, fragment).commit();
        }

    }

    public void addFragment(Fragment fragment, String tag,boolean addToBackstack, boolean hide) {
        FragmentTransaction fx =getChildFragmentManager().beginTransaction();
        if (addToBackstack) {
            if(hide){
                //TODO hide old fragment rather than this
                //fx.hide(this);
            }
            if(fx == getChildFragmentManager().beginTransaction()){
                SLog.i(TAG,"two Fragment transaction are the same");
            }
           fx .add(R.id.hosted_fragment, fragment,tag).addToBackStack(null).commit();
        } else {

            fx.add(R.id.hosted_fragment, fragment,tag).commit();
        }



    }


    public static HostFragment getInstance() {

        if(null == mFragment){
            mFragment = new HostFragment();
        }
        return mFragment;
    }

    @Override
    public String getID() {
        return ID;
    }

    public void setID(String ID) {
        this.ID = ID;
    }

    public MyFragmentAdapter getAdapter() {
        return adapter;
    }

    public void setAdapter(MyFragmentAdapter adapter) {
        this.adapter = adapter;
    }
}
