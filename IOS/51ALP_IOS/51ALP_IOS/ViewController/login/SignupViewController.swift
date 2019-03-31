//
//  SignupViewController.swift
//  51ALP_IOS
//
//  Created by xiu on 3/5/19.
//  Copyright © 2019 wma. All rights reserved.
//

import UIKit
import SnapKit
import Material
import SCLAlertView
import SwiftMessages
import SwiftValidators


class SignupViewController: UIViewController {

    var signupLabel:UILabel!
    var userNameField: TextField!
    var emailField: TextField!
    var passwordField: TextField!
    var passwordField2: TextField!
    var signup:RaisedButton!
    var cancel:RaisedButton!
    var userTypeLabel:UILabel!
    var userType:Switch!
    var isConsultant = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assignbackground()
        prepareSignLebel()
        prepareLoginForm()
        
        let keyboardToolBar = UIToolbar()
        keyboardToolBar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem:
            UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem:
            UIBarButtonItem.SystemItem.done, target: self, action: #selector(self.doneButtonAction) )
        keyboardToolBar.setItems([flexibleSpace, doneButton], animated: true)
        userNameField.inputAccessoryView = keyboardToolBar
        emailField.inputAccessoryView = keyboardToolBar
        passwordField.inputAccessoryView = keyboardToolBar
        passwordField2.inputAccessoryView = keyboardToolBar
        
        
       
    }
    
    @objc func doneButtonAction()
    {
        self.view.endEditing(true)
    }
    
    
    func assignbackground(){
        let background = UIImage(named: "backgrond")
        
        var imageview : UIImageView!
        imageview = UIImageView(frame: view.bounds)
        imageview.contentMode =  UIView.ContentMode.scaleAspectFill
        imageview.clipsToBounds = true
        imageview.image = background
        imageview.center = view.center
        view.addSubview(imageview)
        self.view.sendSubviewToBack(imageview)
    }
    
    
    func prepareSignLebel(){
        
        signupLabel = UILabel()
        signupLabel.text = "新用户注册"
        signupLabel.textColor = UIColor.black
        signupLabel.font = UIFont.systemFont(ofSize: 25, weight: UIFont.Weight.bold)
        self.view.addSubview(signupLabel)
        signupLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.view.snp.top).offset(100)
            make.centerX.equalTo(self.view)
            make.height.equalTo(100)
        }
    }
   
    
   
    
    
    @objc
    internal func handleSignupResponderButton(button: UIButton) {
 
        // validation for all
        let view = MessageView.viewFromNib(layout: .cardView)
        view.layoutMarginAdditions = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        view.button?.isHidden = true
        (view.backgroundView as? CornerRoundingView)?.cornerRadius = 10
       
        
        if(Validator.isEmpty().apply(userNameField.text)){
            view.configureTheme(.error)
            view.configureContent(title: "错误", body: "用户名不能为空", iconText: "")
             SwiftMessages.show(view: view)
            return
        }
        if(!Validator.isEmail().apply(emailField.text)){
            view.configureTheme(.error)
            view.configureContent(title: "错误", body: "不是有效的Email", iconText: "")
             SwiftMessages.show(view: view)
            return
        }
        
        if(!Validator.minLength(8).apply(passwordField.text) || !Validator.minLength(8).apply(passwordField2.text)){
            view.configureTheme(.error)
            view.configureContent(title: "错误", body: "密码至少８位", iconText: "")
             SwiftMessages.show(view: view)
            return
        }
        if(passwordField.text != passwordField2.text){
            view.configureTheme(.error)
            view.configureContent(title: "错误", body: "两次密码不匹配", iconText: "")
             SwiftMessages.show(view: view)
            return
        }
        var userType = "parent"
        var userType_id = 1
        // invoke api
        if(isConsultant){
            userType = "consultant"
            userType_id = 2
        }
        
        let request = SignupReq(userName:userNameField.text!,
                                  userEmail:emailField.text!,
                                  userPassword:passwordField2.text!,
                                  userType:userType,
                                  userTypeID:userType_id
                                  )

        UserService.shared.signup(signupReq: request).done { status -> Void in
            print(status)
            if status{
                view.configureTheme(.success)
                if(self.isConsultant){
                    view.configureContent(title: "成功", body: "请等待管理员开通账号！", iconText: "")
                }else{
                    view.configureContent(title: "成功", body: "请查看Email激活账号！", iconText: "")
                }
                
                SwiftMessages.show(view: view)
                self.dismiss(animated: true) {}
                
            }else{
                view.configureTheme(.error)
                view.configureContent(title: "注册失败！", body: "请输入有效的Email", iconText: "")
                SwiftMessages.show(view: view)
                
            }
            }
            .catch { error in
                view.configureTheme(.error)
                view.configureContent(title: "注册失败！", body: "网络故障请重试", iconText: "")
                SwiftMessages.show(view: view)
                print(error)
        }
        
       
    }
    
   
    
    @objc
    internal func handleCancelButton(button: UIButton) {
         self.dismiss(animated: true) {}
    }
    
    
    
    
    func prepareLoginForm(){
        
        
        userNameField = TextField()
        userNameField.autocapitalizationType=UITextAutocapitalizationType.none;
        userNameField.autocorrectionType=UITextAutocorrectionType.no;
        userNameField.placeholder = "user name"
        userNameField.detail = "用户名"
        userNameField.isClearIconButtonEnabled = true
        userNameField.isPlaceholderUppercasedWhenEditing = true
        userNameField.placeholderAnimation = .hidden
        userNameField.dividerNormalColor = .gray
        view.addSubview(userNameField)
        userNameField.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.signupLabel.snp.bottom).offset(50)
            make.width.equalTo(300)
              make.centerX.equalTo(self.view)
            make.height.equalTo(30)
            
        }

        
        emailField = TextField()
        emailField.autocapitalizationType=UITextAutocapitalizationType.none;
        emailField.autocorrectionType=UITextAutocorrectionType.no;
        emailField.placeholder = "user email"
        emailField.detail = "登录邮件（需要登录验证）"
        emailField.isClearIconButtonEnabled = true
        emailField.isPlaceholderUppercasedWhenEditing = true
        emailField.placeholderAnimation = .hidden
        emailField.dividerNormalColor = .gray
        view.addSubview(emailField)
        emailField.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.userNameField.snp.bottom).offset(50)
            make.width.equalTo(300)
            make.centerX.equalTo(self.view)
            make.height.equalTo(30)
            
        }
        
        passwordField = TextField()
        passwordField.placeholder = "Password"
        passwordField.detail = "密码(最少８位)"
        passwordField.clearButtonMode = .whileEditing
        passwordField.isVisibilityIconButtonEnabled = true
        passwordField.dividerNormalColor = .gray
        passwordField.visibilityIconButton?.tintColor = Color.green.base.withAlphaComponent(passwordField.isSecureTextEntry ? 0.38 : 0.54)
        view.addSubview(passwordField)
        passwordField.snp.makeConstraints { (make) in
            make.width.equalTo(300)
            make.height.equalTo(30)
            make.top.equalTo(self.emailField.snp.bottom).offset(50)
            make.centerX.equalTo(self.view)
            
        }
        
        passwordField2 = TextField()
        passwordField2.placeholder = "Password"
        passwordField2.detail = "再输入一次密码"
        passwordField2.clearButtonMode = .whileEditing
        passwordField2.isVisibilityIconButtonEnabled = true
        passwordField2.dividerNormalColor = .gray
        passwordField2.visibilityIconButton?.tintColor = Color.green.base.withAlphaComponent(passwordField2.isSecureTextEntry ? 0.38 : 0.54)
        view.addSubview(passwordField2)
        passwordField2.snp.makeConstraints { (make) in
            make.width.equalTo(300)
            make.height.equalTo(30)
            make.top.equalTo(self.passwordField.snp.bottom).offset(50)
            make.centerX.equalTo(self.view)
            
        }
        
        
        
        
        userTypeLabel = UILabel()
        userTypeLabel.text = "顾问注册(家长请勿选择)"
        userTypeLabel.textColor = UIColor.black
        userTypeLabel.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.bold)
        self.view.addSubview(userTypeLabel)
        userTypeLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.passwordField2.snp.top).offset(20)
            make.width.equalTo(200)
            make.height.equalTo(100)
            make.leading.equalTo(passwordField2.snp.leading)
        }
        
    
        userType = Switch(state: .off, style: .light, size: .small)
        
        view.addSubview(userType)
        
        userType.snp.makeConstraints { (make) in
            make.width.equalTo(50)
            make.height.equalTo(30)
            make.top.equalTo(self.passwordField2.snp.bottom).offset(25)
            make.trailing.equalTo(passwordField2.snp.trailing)
            
        }
        
        userType.delegate = self
        
    
        signup = RaisedButton(title: "注册")
        signup.pulseColor = .white
        signup.titleColor = .white
        signup.backgroundColor = Color.blue.base
        view.addSubview(signup)
        signup.snp.makeConstraints { (make) in
            make.width.equalTo(120)
            make.height.equalTo(30)
             make.top.equalTo(self.userType.snp.bottom).offset(30)
            make.leading.equalTo(passwordField2.snp.leading)
        }
        
        
       signup.addTarget(self, action: #selector(handleSignupResponderButton(button:)), for: .touchUpInside)
        
        cancel = RaisedButton(title: "取消")
        cancel.pulseColor = .white
        cancel.titleColor = .white
        cancel.backgroundColor = Color.blue.base
        view.addSubview(cancel)
        cancel.snp.makeConstraints { (make) in
            make.width.equalTo(120)
            make.height.equalTo(30)
            make.top.equalTo(self.userType.snp.bottom).offset(30)
            make.trailing.equalTo(passwordField2.snp.trailing)
        }
        
        cancel.addTarget(self, action: #selector(handleCancelButton(button:)), for: .touchUpInside)
        
    }
    
    
}

extension SignupViewController: SwitchDelegate {
    func switchDidChangeState(control: Switch, state: SwitchState) {
        print("Switch changed state to: ", .on == state ? "on" : "off")
        if (.on == state){
            isConsultant = true
        }else{
           isConsultant = false
        }
    }
}
