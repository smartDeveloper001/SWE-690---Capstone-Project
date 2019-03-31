package com.alp.ui.fragment.consultant;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.alp.R;
import com.alp.SLog;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentManager;
import androidx.fragment.app.FragmentTransaction;

public class ConsultantHostFragment extends Fragment {

    private String On_Going_Task ="On going Task ";
    private static String mThree ="THREE";
    private static String key="ConsultantHostFragment";
    private static ConsultantHostFragment mFragment = null;

    public static ConsultantHostFragment getInstance(){
        if(null == mFragment){
            mFragment = new ConsultantHostFragment();
            Bundle args = new Bundle();
            args.putString(key, mThree);
            mFragment.setArguments(args);
        }
        return  mFragment;
    }
    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View v = inflater.inflate(R.layout.consultant_host,container,false);
        FragmentManager fm = getFragmentManager();
        fm.beginTransaction().add(R.id.study_assignment_content, ConsultantTaskCaseFragment.getInstance(), key).commit();
        return  v;
    }

    public void addChildFragment(Fragment fragment, String tag, boolean addToBackstack, boolean hide) {
        FragmentTransaction fx =getChildFragmentManager().beginTransaction();
        if (addToBackstack) {
            if(hide){
                //TODO hide old fragment rather than this
                //fx.hide(this);
            }
            if(fx == getChildFragmentManager().beginTransaction()){
                SLog.i(key,"two Fragment transaction are the same");
            }
            fx .add(R.id.study_assignment_content, fragment,tag).addToBackStack(null).commit();
        } else {

            fx.add(R.id.study_assignment_content, fragment,tag).commit();
        }



    }
}
