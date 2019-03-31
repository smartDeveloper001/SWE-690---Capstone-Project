package com.alp.ui.util;

import com.alp.web.bean.Consultant;

public class ContentUtil {
    private static ContentUtil mContentUtil = null;
    private  ContentUtil (){}

    public static   ContentUtil getInstance(){
        if(mContentUtil == null){
            mContentUtil = new ContentUtil();
        }
        return mContentUtil;

    }
    private static Consultant consultant = null;

    public  Consultant getConsultant() {
        return consultant;
    }

    public  void setConsultant(Consultant consultant) {
        ContentUtil.consultant = consultant;
    }
}
