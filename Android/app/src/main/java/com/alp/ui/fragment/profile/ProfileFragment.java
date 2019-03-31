package com.alp.ui.fragment.profile;

import android.content.Intent;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.alp.R;
import com.alp.ui.ChangePWDActivity;
import com.alp.ui.fragment.HostFragment;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentManager;
import androidx.fragment.app.FragmentTransaction;

public class ProfileFragment extends Fragment {
    public static String TAG = "ProfileFragment";
    public  static final String mProfile="PROFILE";
    private static String key="ProfileFragment";
    private static ProfileFragment mProfileFragment =null;


    public static ProfileFragment getInstance(){
        if(null == mProfileFragment){
            mProfileFragment = new ProfileFragment();
            // Supply num input as an argument.
            Bundle args = new Bundle();
            args.putString(key, mProfile);
            mProfileFragment.setArguments(args);
        }
        return mProfileFragment;
    }

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View v = inflater.inflate(R.layout.profile,container,false);
        initView(v);

        return v;
    }

    private void initView(View v){
        v.findViewById(R.id.change_home).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                HostFragment mHostFragment = HostFragment.getInstance();
                mHostFragment.addFragment(ProvinceFragment.getInstance(),ProvinceFragment.getInstance().getKey(),true,true);
            }
        });
        v.findViewById(R.id.change_pwd).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                startChangePWDActivity();

            }
        });
        v.findViewById(R.id.my_consultant).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                HostFragment mHostFragment = HostFragment.getInstance();
                mHostFragment.addFragment(ConsultantsFragment.getInstance(),ConsultantsFragment.getInstance().getKey(),true,true);
            }
        });

    }

    private void startChangePWDActivity(){
        Intent mIntent = new Intent(getContext(), ChangePWDActivity.class);
        startActivity(mIntent);
    }

    //TODO why doesn't work?
    private void addFragment(){
        FragmentManager fm = getFragmentManager();
        FragmentTransaction tx = fm.beginTransaction();
        tx.hide(this);
        //TODO CHANG PROVINCE TO VARIABLE
        tx.add(R.id.hosted_fragment , ProvinceFragment.getInstance(), "PROVINCE");
    }

    public static String getKey() {
        return key;
    }

    public static void setKey(String key) {
        ProfileFragment.key = key;
    }
}
