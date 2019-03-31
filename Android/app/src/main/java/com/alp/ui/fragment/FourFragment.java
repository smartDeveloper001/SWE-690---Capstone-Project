package com.alp.ui.fragment;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.alp.R;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;

public class FourFragment extends BaseFragment {
    String ID ="FourFragment";
    private static String mThree ="FOUR";
    private static String key="key";
    private static FourFragment mFragment = null;
    
    public static FourFragment getInstance(){
        if(null == mFragment){
            mFragment = new FourFragment();
            Bundle args = new Bundle();
            args.putString(key, mThree);
            mFragment.setArguments(args);
        }
        return mFragment;

    }
    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View v = inflater.inflate(R.layout.fragment_four,container,false);
        return v;
    }

    @Override
    public String getID() {
        return ID;
    }

    public void setID(String ID) {
        this.ID = ID;
    }
}
