package com.alp.ui.fragment.profile;

import android.os.Bundle;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.Spinner;

import com.alp.R;
import com.alp.SLog;
import com.alp.ui.fragment.BaseFragment;
import com.alp.ui.fragment.HostFragment;
import com.alp.ui.util.Utils;
import com.alp.web.ApiService;
import com.alp.web.ResultToResponseWithErrorHandlingTransformer;
import com.alp.web.bean.City;
import com.alp.web.bean.Province;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import io.reactivex.android.schedulers.AndroidSchedulers;
import io.reactivex.functions.Action;
import io.reactivex.functions.Consumer;
import io.reactivex.schedulers.Schedulers;
import retrofit2.Response;

public class ProvinceFragment extends BaseFragment {
    String ID ="ProvinceFragment";
    String key ="ProvinceFragment";
    private static ProvinceFragment mFragment ;
    ApiService mServie = ApiService.getInstance();
    private String TAG = "ProvinceFragment";
    List<Province> cities = null;
    Spinner provinceSpinner =null;
    Spinner citySpinner = null;
    List<String> provinces = new ArrayList<>();
    Map<String, List<String>> cityMap = new HashMap<>();
    Gson mGson = new Gson();


    boolean referesh =false;


    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        SLog.i(TAG,"oncreateView");
        View v = inflater.inflate(R.layout.hometown,container,false);
       initView(v);
        return v;
    }

    private void initView(View v){
        referesh =false;
        provinceSpinner = v.findViewById(R.id.spinner_province);
        citySpinner = v.findViewById(R.id.spinner_city);
        v.findViewById(R.id.left).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                closeCurFragment();
            }
        });


        if(!TextUtils.isEmpty(Utils.getCity())){
            cities = mGson.fromJson(Utils.getCity(),new TypeToken<List<Province>>(){}.getType());
            getHomeInfo(cities);
            inflateCity();
        }else{

            mServie.getProvinces(Utils.getToken()).subscribeOn(Schedulers.io()).observeOn(AndroidSchedulers.mainThread()).compose(new ResultToResponseWithErrorHandlingTransformer<List<Province>>()).subscribe(
                    new Consumer<Response<?>>() {
                        @Override
                        public void accept(Response<?> response) throws Exception {
                            List<Province> mResponse =  (List<Province>) response.body();
                            if(mResponse.size()>0){
                                Utils.saveProvince(mGson.toJson(mResponse));
                            }
                            cities = mResponse;
                            getHomeInfo(mResponse);
                            inflateCity();
                        }
                    },
                    new Consumer<Throwable>() {
                        @Override
                        public void accept(Throwable throwable)  {
                            throwable.printStackTrace();

                        }
                    },
                    new Action() {
                        @Override
                        public void run()  {

                        }
                    }

            );
        }




    }


    private void getHomeInfo(List<Province> mlist){
        for(Province c: mlist){
            provinces.add(c.getName());
            List<String> citilist = new ArrayList<>();
            for(City city: c.getCity()){
                citilist.add(city.getName());
            }
            cityMap.put(c.getName(),citilist);
        }
    }

    public void inflateCity(){
        ArrayAdapter adapter = new ArrayAdapter<>(getContext(),android.R.layout.simple_spinner_item,provinces);
        adapter.setDropDownViewResource(android.R.layout.simple_dropdown_item_1line);
        provinceSpinner.setAdapter(adapter);
        provinceSpinner.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                ArrayAdapter adapterCity = new ArrayAdapter<>(getContext(),android.R.layout.simple_spinner_item,cityMap.get(provinces.get(position)));
                adapterCity.setDropDownViewResource(android.R.layout.simple_dropdown_item_1line);
                citySpinner.setAdapter(adapterCity);
            }

            @Override
            public void onNothingSelected(AdapterView<?> parent) {

            }
        });


        provinceSpinner.setSelection(0);


    }

    public static ProvinceFragment getInstance(){
        if(null == mFragment){
            mFragment = new ProvinceFragment();
        }
        return  mFragment;
    }


    @Override
    public String getID() {
        return ID;
    }

    public void setID(String ID) {
        this.ID = ID;
    }

    private  void closeCurFragment(){
        HostFragment host = HostFragment.getInstance();
        host.getChildFragmentManager().popBackStack();

    }
    public String getKey(){
        return  key;
    }
}
