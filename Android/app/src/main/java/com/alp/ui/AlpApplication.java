package com.alp.ui;

import android.app.Application;

import com.alp.ui.util.Utils;

public class AlpApplication extends Application {
    @Override
    public void onCreate() {
        super.onCreate();
        Utils.setApplication(AlpApplication.this);
    }
}
