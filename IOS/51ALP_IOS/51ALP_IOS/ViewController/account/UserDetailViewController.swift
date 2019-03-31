//
//  UserDetailViewController.swift
//  51ALP_IOS
//
//  Created by xiu on 3/7/19.
//  Copyright © 2019 wma. All rights reserved.
//

import UIKit
import SnapKit
import Material
import SCLAlertView
import SwiftMessages
import Material
import SwiftMessages
import SwiftValidators

class UserDetailViewController: UIViewController , UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate ,UITextViewDelegate{
   
    
    
    @objc internal func doneClick() {
        activityTextField.resignFirstResponder()
    
    }
     @objc internal func cancelClick() {
        activityTextField.resignFirstResponder()
     
    }
    
    
    
    var myPickerView : UIPickerView!
    var pickerData:Array<String> = []
    
    var activityTextField: UITextField!
    var isState = true
    var stateTextField = UITextField()
    var cityTextField = UITextField()
    var selfTextView = UITextView()
    var save:RaisedButton!
    var cancel:RaisedButton!
    var stateToCode=[String:Int]()
    var citysArray:Array<[String:Int]> = []
    var stateToCity = [String:Int]()
    
    
    
    func pickUp(_ textField : UITextField){
        
      
        self.myPickerView = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.myPickerView.delegate = self
        self.myPickerView.dataSource = self
        self.myPickerView.backgroundColor = UIColor.white
        textField.inputView = self.myPickerView
   
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        

        let doneButton = UIBarButtonItem(title: "确定", style: .plain, target: self, action: #selector(doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
        
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.activityTextField.text = pickerData[row]
       
    }
  

    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activityTextField = textField
  
        if self.activityTextField.placeholder == "请选择市" {
            
            if let stateName = self.stateTextField.text{
                // prepare for city
                print("prepare for city")
                
                print("stateName \(stateName)")
                let index = stateToCity[stateName]
                print("index \(index)")
                let cityMap = citysArray[index!]
                pickerData.removeAll()
                for (key, _) in cityMap {
                    pickerData.append(key)
                }
                
                
            }else{
                 print("need select state firstly ")
                
            }
   

        }
        
        if self.activityTextField.placeholder == "请选择省" {
            // prepare for city
            pickerData.removeAll()
            print("prepare for state")
            for cities in CommonService.shared.citiesArray!{
                pickerData.append(cities.name)
            }
            
        }
        
        pickUp(textField)
        if pickerData.count>0{
            if textField.text == ""{
                textField.text = pickerData[0]
            }
        }
        
        
    }


    func textFieldDidEndEditing(_ textField: UITextField) {
        if self.activityTextField.placeholder == "请选择省" {
            self.cityTextField.text = ""
            
        }

        
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

 
    var userDtailLabel:UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        prepareForm()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(gestureReconizer:)))
        view.addGestureRecognizer(tapGesture)
        
        
        
   
        
        
        
        // build pickup data
        var index:Int = 0
        for cities in CommonService.shared.citiesArray!{
            pickerData.append(cities.name)
            stateToCode[cities.name] = cities.code
            var cityToCode=[String:Int]()
            for city in  cities.city{
               cityToCode[city.name] = city.code
            }
            citysArray.append(cityToCode)
            stateToCity[cities.name] = index
            index = index+1
  
        }
        print("citysArray:\(citysArray)")
         print("stateToCity:\(stateToCity)")
        

        let keyboardToolBar = UIToolbar()
        keyboardToolBar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem:
            UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem:
            UIBarButtonItem.SystemItem.done, target: self, action: #selector(self.doneButtonAction) )
        keyboardToolBar.setItems([flexibleSpace, doneButton], animated: true)
        self.selfTextView.inputAccessoryView = keyboardToolBar
 
        
        
        
        
    }
    
    @objc func doneButtonAction()
    {
        self.view.endEditing(true)
    }
    
    @objc func viewTapped(gestureReconizer:UITapGestureRecognizer){
        self.view.endEditing(true)
    }
    

    func prepareForm(){
        
        userDtailLabel = UILabel()
        userDtailLabel.text = "详细信息"
        userDtailLabel.textColor = UIColor.black
        userDtailLabel.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.bold)
        self.view.addSubview(userDtailLabel)
        userDtailLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.view.snp.top).offset(10)
            make.centerX.equalTo(self.view)
            make.height.equalTo(20)
        }
        
    
     
        stateTextField.layer.cornerRadius = 5
        stateTextField.layer.borderColor = UIColor.lightGray.cgColor
        stateTextField.layer.borderWidth = 0.5
        
        stateTextField.delegate = self
        stateTextField.placeholder = "请选择省"
        self.view.addSubview(stateTextField)
        stateTextField.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.view.snp.top).offset(60)
            make.centerX.equalTo(self.view)
            make.height.equalTo(30)
            make.width.equalTo(250)
        }
        
    
        cityTextField.delegate = self
        cityTextField.layer.cornerRadius = 5
        cityTextField.layer.borderColor = UIColor.lightGray.cgColor
        cityTextField.layer.borderWidth = 0.5
        cityTextField.placeholder = "请选择市"
        self.view.addSubview(cityTextField)
        cityTextField.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(stateTextField.snp.bottom).offset(20)
            make.centerX.equalTo(self.view)
            make.height.equalTo(30)
            make.width.equalTo(250)
        }
        
        if selfTextView.text == "" {
            if UserService.shared.localUserTypeId == 1 {
                selfTextView.text = "让顾问了解你更多信息"
            }else{
                selfTextView.text = "让家长了解你更多信息"
            }
    
        }

        let screensize: CGRect = UIScreen.main.bounds
        let screenWidth = screensize.width
        let screenHight = screensize.height
        selfTextView.textContainerInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        selfTextView.textColor = UIColor.lightGray
        selfTextView.textAlignment = .left
        selfTextView.backgroundColor = UIColor.white
        selfTextView.layer.cornerRadius = 2
        selfTextView.layer.borderColor = UIColor.lightGray.cgColor
        selfTextView.layer.borderWidth = 0.2
        selfTextView.layer.cornerRadius = 10
//        selfTextView.layer.masksToBounds = true
        selfTextView.isEditable = true
        //selfTextView.keyboardType = UIKeyboardType.default
//        selfTextView.isScrollEnabled = true
        selfTextView.delegate = self
        self.view.addSubview(selfTextView)
        selfTextView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.cityTextField.snp.bottom).offset(30)
            make.centerX.equalTo(self.view)
            make.height.equalTo(screenHight/2)
            make.width.equalTo(screenWidth-20)
        }
        
        save = RaisedButton(title: "保存")
        save.pulseColor = .white
        save.titleColor = .white
        save.backgroundColor = Color.blue.base
        view.addSubview(save)
        save.snp.makeConstraints { (make) in
            make.width.equalTo(100)
            make.height.equalTo(30)
            make.top.equalTo(self.selfTextView.snp.bottom).offset(10)
            make.left.equalTo(view.snp.left).offset(screenWidth/4)
        }
        
        
        save.addTarget(self, action: #selector(handleSaveResponderButton(button:)), for: .touchUpInside)
        
        cancel = RaisedButton(title: "取消")
        cancel.pulseColor = .white
        cancel.titleColor = .white
        cancel.backgroundColor = Color.blue.base
        view.addSubview(cancel)
        cancel.snp.makeConstraints { (make) in
            make.width.equalTo(100)
            make.height.equalTo(30)
            make.top.equalTo(self.selfTextView.snp.bottom).offset(10)
            make.left.equalTo(save.snp.right).offset(30)
        }
        
        cancel.addTarget(self, action: #selector(handleCancelButton(button:)), for: .touchUpInside)
        
    }
    
        
    
    
    

    
    
    
    @objc
    internal func handleSaveResponderButton(button: UIButton) {
        
        let view = MessageView.viewFromNib(layout: .cardView)
        view.layoutMarginAdditions = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        view.button?.isHidden = true
        (view.backgroundView as? CornerRoundingView)?.cornerRadius = 10
        
        
        
        if let stateValue = stateTextField.text {
            if stateValue == "" {
                view.configureTheme(.error)
                view.configureContent(title: "错误", body: "所在省不能为空", iconText: "")
                SwiftMessages.show(view: view)
                return
                
            }
            
        }
        

       if let cityValue = cityTextField.text {
            if cityValue == "" {
                view.configureTheme(.error)
                view.configureContent(title: "错误", body: "所在城市不能为空", iconText: "")
                SwiftMessages.show(view: view)
                return
                
            }
       
        }
        
        
        if let selfIntroduce = selfTextView.text {
            print("new selfIntroduce:\(selfIntroduce)")
            if selfIntroduce == "" {
                view.configureTheme(.error)
                view.configureContent(title: "错误", body: "自我介绍不能为空", iconText: "")
                SwiftMessages.show(view: view)
                return
                
            }
            
        }
        
        // call update API
        var city_code = 0
        for city in citysArray{
            if let code = city[cityTextField.text!]{
                city_code = code
                break
            }
        }
       
        
        
        let request = UpdateUserReq(id:UserService.shared.localUserId!,
                                userName:UserService.shared.localUserName!,
                                userStateCode:stateToCode[stateTextField.text!]!,
                                userState:stateTextField.text!,
                                userCity:cityTextField.text!,
                                 userCityCode:city_code,
                                userSelfIntroduce:selfTextView.text!
        )
    
        
        UserService.shared.updateUser(updateUserReq:request).done { status -> Void in
           
            if status{
                view.configureTheme(.success)
                view.configureContent(title: "成功", body: "保存成功！", iconText: "")
              
                SwiftMessages.show(view: view)
               self.navigationController?.popViewController(animated: false)
                
            }else{
                view.configureTheme(.error)
                view.configureContent(title: "保存失败！", body: "稍后重试", iconText: "")
                SwiftMessages.show(view: view)
                
            }
            }
            .catch { error in
                view.configureTheme(.error)
                view.configureContent(title: "保存失败！", body: "网络故障请重试", iconText: "")
                SwiftMessages.show(view: view)
                print(error)
        }
        
    
        
        
    }
    
    
    
    @objc
    internal func handleCancelButton(button: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            if UserService.shared.localUserTypeId == 1{
                textView.text = "让顾问了解你更多信息"
            }else{
                textView.text = "让家长了解你更多信息"
            }
            
            
            textView.textColor = UIColor.lightGray
        }
       
    }
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
         textView.resignFirstResponder()
        return true
        
    }
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
       
        if (text ==  "\n") {
            textView.resignFirstResponder()
            return false;
        }
        return true
    }
    


}
