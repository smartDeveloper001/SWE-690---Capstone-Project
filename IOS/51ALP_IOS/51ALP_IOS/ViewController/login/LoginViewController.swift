//
//  LoginViewController.swift
//  51ALP_IOS
//
//  Created by xiu on 1/30/19.
//  Copyright © 2019 wma. All rights reserved.
//

import UIKit
import SnapKit
import Material
import SCLAlertView
import SwiftMessages
import SwiftValidators
class LoginViewController: UIViewController {
    

    
    

    
    
    var logoImage:UIImageView!
    var emailField: TextField!
    var passwordField: TextField!
    var loginButton:RaisedButton!
    var forgetPass: UILabel!
    var signup:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assignbackground()
        prepareLogo()
        prepareLoginForm()
        prepareLoginButton()
        prepareUserAction()
        
        
        let keyboardToolBar = UIToolbar()
        keyboardToolBar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem:
            UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem:
            UIBarButtonItem.SystemItem.done, target: self, action: #selector(self.doneButtonAction) )
        keyboardToolBar.setItems([flexibleSpace, doneButton], animated: true)
        emailField.inputAccessoryView = keyboardToolBar
        passwordField.inputAccessoryView = keyboardToolBar
        
        
        
    }
    
    @objc func doneButtonAction()
    {
        self.view.endEditing(true)
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL,
                  in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if let scheme = URL.scheme {
            switch scheme {
            case "about" :
                   print("about")
            case "feedback" :
                  print("feedback")
            default:
                print("这个是普通的url")
            }
        }
        
        return true
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
        
//        self.view.backgroundColor = UIColor.white
    }
    
    func prepareLogo(){
        
        let imageName = "logo.png"
        let image = UIImage(named: imageName)
        logoImage = UIImageView(image: image!)
        logoImage.contentMode =  UIView.ContentMode.scaleAspectFill
        self.view.addSubview(logoImage)
        logoImage.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.view.snp.top).offset(250)
            make.centerX.equalTo(self.view)
            make.height.equalTo(40)
        }
    }
    
    func prepareLoginForm(){
        emailField = TextField()
        emailField.autocapitalizationType=UITextAutocapitalizationType.none;
        emailField.autocorrectionType=UITextAutocorrectionType.no;
        emailField.placeholder = "Email"
        emailField.detail = "your sign email"
        emailField.isClearIconButtonEnabled = true
        emailField.isPlaceholderUppercasedWhenEditing = true
        emailField.placeholderAnimation = .hidden
        emailField.dividerNormalColor = .gray
        view.addSubview(emailField)
        emailField.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(300)
            make.height.equalTo(30)
            make.center.equalTo(self.view.snp.center)
           
        }
        
        
        passwordField = TextField()
        passwordField.placeholder = "Password"
        passwordField.detail = "your password"
        passwordField.clearButtonMode = .whileEditing
        passwordField.isVisibilityIconButtonEnabled = true
        passwordField.dividerNormalColor = .gray
        passwordField.visibilityIconButton?.tintColor = Color.green.base.withAlphaComponent(passwordField.isSecureTextEntry ? 0.38 : 0.54)
        view.addSubview(passwordField)
        passwordField.snp.makeConstraints { (make) in
            make.width.equalTo(300)
            make.height.equalTo(30)
            make.centerY.equalTo(emailField).offset(80)
            make.centerX.equalTo(emailField)
            
        }
        
        
        
   
        
        
    }
    
    func prepareLoginButton(){
        
        loginButton = RaisedButton(title: "login")
        self.loginButton.pulseColor = .white
        self.loginButton.titleColor = .white
        self.loginButton.backgroundColor = Color.blue.base
        self.view.addSubview(loginButton)
        loginButton.snp.makeConstraints { (make) in
            make.width.equalTo(300)
            make.height.equalTo(30)
            //make.center.equalTo(view)
            make.centerY.equalTo(passwordField).offset(80)
            make.centerX.equalTo(passwordField)
        }
        
        loginButton.addTarget(self, action: #selector(handleLoginResponderButton(button:)), for: .touchUpInside)
        
    }
    
    
    @objc
    internal
    func forgetPassAction(){
        
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "HelveticaNeue", size: 20)!,
            kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
            kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
            showCloseButton: false
        )
        
        
        let alert = SCLAlertView(appearance: appearance)
        
        let txt = alert.addTextField("输入你的注册Email")
        txt.autocapitalizationType=UITextAutocapitalizationType.none;
        txt.autocorrectionType=UITextAutocorrectionType.no;
        alert.addButton("生成新密码") {
            print("Text value: \(txt.text)")
             let view = MessageView.viewFromNib(layout: .cardView)
            view.configureDropShadow()
            if(Validator.isEmail().apply(txt.text)){
                view.configureTheme(.success)
                view.configureContent(title: "成功", body: "密码已发送请查看邮箱", iconText: "")
            }else{
                view.configureTheme(.error)
                view.configureContent(title: "错误", body: "不是有效的Email", iconText: "")
            }
            view.layoutMarginAdditions = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
            view.button?.isHidden = true
    
            (view.backgroundView as? CornerRoundingView)?.cornerRadius = 10
            SwiftMessages.show(view: view)
            
        }
        alert.showEdit("忘记密码", subTitle: "重置密码")
        print("forgetPass")
        
    }
    
    @objc
    internal
    func signupAction(){
        let signupVC = SignupViewController()
        self.present(signupVC, animated: false) {
        
    }
    }

    
    
    
    
    func prepareUserAction(){
        
        forgetPass = UILabel()
        forgetPass.textColor = UIColor.blue
        forgetPass.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.ultraLight)
    
        forgetPass.attributedText = NSAttributedString(string: "忘记密码？", attributes:
            [.underlineStyle: NSUnderlineStyle.single.rawValue])


        forgetPass.isUserInteractionEnabled=true
 
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(LoginViewController.forgetPassAction))
        forgetPass.addGestureRecognizer(tap)
        
        self.view.addSubview(forgetPass)
        forgetPass.snp.makeConstraints { (make) in
            make.width.equalTo(100)
            make.height.equalTo(20)
            //make.center.equalTo(view)
            make.centerY.equalTo(loginButton).offset(40)
            make.leading.equalTo(loginButton).offset(20)
        }
        
        
        signup = UILabel()
        signup.textColor = UIColor.blue
        signup.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.light)
        
        signup.attributedText = NSAttributedString(string: "新用户注册？", attributes:
            [.underlineStyle: NSUnderlineStyle.single.rawValue])
        
        
        signup.isUserInteractionEnabled=true
        
        let signuptap = UITapGestureRecognizer.init(target: self, action: #selector(LoginViewController.signupAction))
        signup.addGestureRecognizer(signuptap)
        
        self.view.addSubview(signup)
        signup.snp.makeConstraints { (make) in
            make.width.equalTo(100)
            make.height.equalTo(20)
            //make.center.equalTo(view)
            make.centerY.equalTo(loginButton).offset(40)
            make.leading.equalTo(forgetPass).offset(120)
        }
        
    
        
    }
    
 
   var window: UIWindow?
    
    @objc
    internal func handleLoginResponderButton(button: UIButton) {
        
        let view = MessageView.viewFromNib(layout: .cardView)
        view.layoutMarginAdditions = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        view.button?.isHidden = true
        (view.backgroundView as? CornerRoundingView)?.cornerRadius = 10
        view.configureTheme(.error)
        
        guard let useremail = self.emailField.text , !useremail.isEmpty else{

            view.configureContent(title: "Email不能为空", body: "请输入有效的Email", iconText: "")
            SwiftMessages.show(view: view)
            return
        }
        
        guard let password = self.passwordField.text , !password.isEmpty else{
            view.configureContent(title: "密码不能为空", body: "请输入有效的密码", iconText: "")
            SwiftMessages.show(view: view)
        
           return
        }
        
        UserService.shared.login(loginemail:useremail,password:password).done { status -> Void in
            print(status)
            if status{
                self.window = UIWindow(frame: Screen.bounds)
                // duplicated code from AppDelegate need fix later
                let realm = SSRealmTool.ss_realm
                print(realm.objects(LocalUserInfo.self).count )
                if realm.objects(LocalUserInfo.self).count == 1 {
                    
                    
                    let localUserInfos = realm.objects(LocalUserInfo.self)
                    
                    print("login --> you have login token is:"+localUserInfos[0].userToken)
                    UserService.shared.localUserToken = localUserInfos[0].userToken
                    UserService.shared.localUserName = localUserInfos[0].userName
                    UserService.shared.localUserEmail = localUserInfos[0].userEmail
                    UserService.shared.localUserTypeId = localUserInfos[0].userType_id
                    UserService.shared.localUserId = localUserInfos[0].userId
                    UserService.shared.localUserAvataImage = localUserInfos[0].localUserAvataImage
                    
                    
                    CourseService.shared.initGogalMap()
                    CourseService.shared.initCourseMap()
                    BreakService.shared.initBreakMap()
                     UserService.shared.initUsersMap()
                    
                    
                    var viewControllers:[AppNavigationController] = []
                    let vlvc = VideoLectureViewController()
                    let nav1 = AppNavigationController(rootViewController:vlvc)
                    viewControllers.append(nav1)
                    
                    
                    
                    if let userType = UserService.shared.localUserTypeId{
                        
                        if userType == 1{
                            let ptvc = Course4ParentViewController()
                            let nav2 = AppNavigationController(rootViewController:ptvc)
                            viewControllers.append(nav2)
                            
                        }
                        
                        if userType == 2{
                            let tvc = TaskViewController()
                            let nav4 = AppNavigationController(rootViewController:tvc)
                            viewControllers.append(nav4)
                            
                            
                            let bvc = CourseViewController()
                            let nav7 = AppNavigationController(rootViewController:bvc)
                            viewControllers.append(nav7)
   
                        }
   
                        
                    }
                    
                    let vvc = VideoViewController()
                    let nav3 = AppNavigationController(rootViewController:vvc)
                    viewControllers.append(nav3)
                    
                    
                    let avc = AccountViewController()
                    let nav5 = AppNavigationController(rootViewController:avc)
                    viewControllers.append(nav5)
                    
                    let appBottomNavigationController = AppBottomNavigationController(viewControllers: viewControllers)
                    appBottomNavigationController.selectedIndex = 0
                    self.window!.rootViewController = appBottomNavigationController
                    self.window!.makeKeyAndVisible()
                    // deplicated code end
                    
                    
                }
                
                
                
                
            
                }else{
                view.configureContent(title: "登录失败！", body: "请输入有效的Email和密码", iconText: "")
                SwiftMessages.show(view: view)
                }
                
            }
            .catch { error in
                view.configureContent(title: "登录失败！", body: "网络故障请重试", iconText: "")
                SwiftMessages.show(view: view)
                print(error)
        }
        
       
    }
    
    


}

extension ViewController: TextFieldDelegate {
    public func textFieldDidEndEditing(_ textField: UITextField) {
        (textField as? ErrorTextField)?.isErrorRevealed = false
    }
    
    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        (textField as? ErrorTextField)?.isErrorRevealed = false
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        (textField as? ErrorTextField)?.isErrorRevealed = true
        return true
    }
}




