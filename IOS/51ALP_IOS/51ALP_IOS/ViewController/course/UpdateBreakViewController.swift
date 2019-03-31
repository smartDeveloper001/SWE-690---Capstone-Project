//
//  UpdateBreakViewController.swift
//  51ALP_IOS
//
//  Created by xiu on 3/11/19.
//  Copyright © 2019 wma. All rights reserved.
//

import UIKit
import UIKit
import SnapKit
import Material
import SCLAlertView
import SwiftMessages
import Material
import SwiftMessages
import SwiftValidators
import PopupDialog

class UpdateBreakViewController: UIViewController , UITextFieldDelegate ,UITextViewDelegate{

   
    var isUpdate = false
    
    var courseID:Int!
    var goalID:Int!
    var parentId:Int?
    
    var save:RaisedButton!
    var cancel:RaisedButton!
    var delete:RaisedButton!
    
    var addTask:RaisedButton!
    var cancelTask:RaisedButton!

     var userDtailLabel:UILabel!
    var titleField :TextField!
    var desc = TextView()
    var question = TextView()
    var requirment = TextView()
    var breakObj:BreakRes?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        prepareNavigationItem()
        prepareForm()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(gestureReconizer:)))
        view.addGestureRecognizer(tapGesture)
        
        
        let keyboardToolBar = UIToolbar()
        keyboardToolBar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem:
            UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem:
            UIBarButtonItem.SystemItem.done, target: self, action: #selector(self.doneButtonAction) )
        keyboardToolBar.setItems([flexibleSpace, doneButton], animated: true)
        self.titleField.inputAccessoryView = keyboardToolBar
        self.desc.inputAccessoryView = keyboardToolBar
        self.question.inputAccessoryView = keyboardToolBar
        self.requirment.inputAccessoryView = keyboardToolBar

        
    }
    
    
    
    
    func prepareForm(){
        
        userDtailLabel = UILabel()

        if UserService.shared.processStatus == 1 {

              userDtailLabel.text = "剖析详情"

        }

        if UserService.shared.processStatus == 0 {

            if isUpdate{
                userDtailLabel.text = "修改剖析"
            }else{
                userDtailLabel.text = "添加剖析"
            }
        }
        
        
        self.view.backgroundColor = UIColor(white: 0.95, alpha: 1)
        
        let screensize: CGRect = UIScreen.main.bounds
        let screenWidth = screensize.width
        let scrollView = UIScrollView()
        let containerView = UIView()
        
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        scrollView.isScrollEnabled = true
        scrollView.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(view.snp.centerX)
            make.top.bottom.equalTo(view)
            make.width.equalTo(screenWidth)
        }
        
        
        containerView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(scrollView)
            make.width.equalTo(screenWidth-20)
        }
        

        userDtailLabel.textColor = UIColor.black
        userDtailLabel.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.bold)
        containerView.addSubview(userDtailLabel)
        userDtailLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(containerView.snp.top).offset(20)
            make.centerX.equalTo(containerView)
            make.height.equalTo(20)
        }
        
        titleField = TextField()

        if isUpdate{
            if let titleStr = breakObj?.breakTitle{
                titleField.text = titleStr
            }
        }
        
        
        titleField.autocapitalizationType=UITextAutocapitalizationType.none;
        titleField.autocorrectionType=UITextAutocorrectionType.no;
        titleField.placeholder = "剖析标题"

        titleField.isClearIconButtonEnabled = true
        titleField.isPlaceholderUppercasedWhenEditing = true
        titleField.placeholderAnimation = .hidden
        titleField.dividerNormalColor = .gray
        containerView.addSubview(titleField)
        titleField.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.userDtailLabel.snp.bottom).offset(40)
            make.width.equalTo(screenWidth*0.8)
            make.centerX.equalTo(self.view)
            make.height.equalTo(30)
            
        }
        
        
        let courseDetail = RaisedButton(title: "课程详情")
        courseDetail.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        courseDetail.pulseColor = .white
        courseDetail.titleColor = .white
        courseDetail.backgroundColor = Color.blue.base
        containerView.addSubview(courseDetail)
        courseDetail.snp.makeConstraints { (make) in
            make.width.equalTo(80)
            make.height.equalTo(20)
            make.top.equalTo(self.view.snp.top).offset(10)
            make.left.equalTo(self.view.snp.right).offset(-100)
        }
        
        courseDetail.addTarget(self, action: #selector(handleCourseDetail(button:)) ,for: .touchUpInside)
//
        
//
        let gogalDetail = RaisedButton(title: "目标详情")
        gogalDetail.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        gogalDetail.pulseColor = .white
        gogalDetail.titleColor = .white
        gogalDetail.backgroundColor = Color.blue.base
        containerView.addSubview(gogalDetail)
        gogalDetail.snp.makeConstraints { (make) in
            make.width.equalTo(80)
            make.height.equalTo(20)
            make.top.equalTo(courseDetail.snp.bottom).offset(10)
            make.left.equalTo(self.view.snp.right).offset(-100)
        }
        
       gogalDetail.addTarget(self, action: #selector(handleGogalDetail(button:)),for: .touchUpInside)
//
//
        
        
        desc.tag = 1
        if isUpdate{
            if let descStr = breakObj?.breakDesc{
                desc.text = descStr
            }
        }
        desc.placeholder = "剖析描述"
        desc.autocapitalizationType=UITextAutocapitalizationType.none;
        desc.autocorrectionType=UITextAutocorrectionType.no;
        desc.textContainerInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        desc.textColor = UIColor.lightGray
        desc.textAlignment = .left
        desc.backgroundColor = UIColor.white
        desc.layer.cornerRadius = 0.1
        desc.layer.borderColor = UIColor.black.cgColor
        desc.layer.borderWidth = 0.1
        desc.layer.cornerRadius = 2
        desc.isEditable = true
        desc.delegate = self
        containerView.addSubview(desc)
        desc.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.titleField.snp.bottom).offset(30)
            make.width.equalTo(screenWidth*0.8)
            make.centerX.equalTo(self.view)
            make.height.equalTo(120)
            
        }
        question.tag = 2
        
        if isUpdate{
            if let questionStr = breakObj?.breakQuestion{
                question.text = questionStr
            }
        }
        
        question.placeholder = "有意义的不确定性"
        question.autocapitalizationType=UITextAutocapitalizationType.none;
        question.autocorrectionType=UITextAutocorrectionType.no;
        question.textContainerInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        question.textColor = UIColor.lightGray
        question.textAlignment = .left
        question.backgroundColor = UIColor.white
        question.layer.cornerRadius = 0.1
        question.layer.borderColor = UIColor.black.cgColor
        question.layer.borderWidth = 0.1
        question.layer.cornerRadius = 2
        question.isEditable = true
        question.delegate = self
        containerView.addSubview(question)
        question.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.desc.snp.bottom).offset(20)
            make.width.equalTo(screenWidth*0.8)
            make.centerX.equalTo(self.view)
            make.height.equalTo(120)
            
        }
        
        
        requirment.tag = 3
        
        if isUpdate{
            if let breakRequirementStr = breakObj?.breakRequirement{
                requirment.text = breakRequirementStr
            }
            
        }
        
        requirment.placeholder = "精通条件"
        requirment.autocapitalizationType=UITextAutocapitalizationType.none;
        requirment.autocorrectionType=UITextAutocorrectionType.no;
        requirment.textContainerInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        requirment.textColor = UIColor.lightGray
        requirment.textAlignment = .left
        requirment.backgroundColor = UIColor.white
        requirment.layer.cornerRadius = 0.1
        requirment.layer.borderColor = UIColor.black.cgColor
        requirment.layer.borderWidth = 0.1
        requirment.layer.cornerRadius = 2
        requirment.isEditable = true
        requirment.delegate = self
        
        containerView.addSubview(requirment)
        requirment.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.question.snp.bottom).offset(20)
            make.width.equalTo(screenWidth*0.8)
            make.centerX.equalTo(self.view)
            make.height.equalTo(120)
            
        }
     
        
     
        
        
        if UserService.shared.processStatus == 0 {
            save = RaisedButton(title: "保存")
            save.pulseColor = .white
            save.titleColor = .white
            save.backgroundColor = Color.blue.base
            containerView.addSubview(save)
            save.snp.makeConstraints { (make) in
                make.width.equalTo(120)
                make.height.equalTo(30)
                make.top.equalTo(self.requirment.snp.bottom).offset(20)
                make.leading.equalTo(requirment.snp.leading)
            }
            
         
            
            
            save.addTarget(self, action: #selector(handleSaveResponderButton(button:)), for: .touchUpInside)
            
            if isUpdate{
                delete = RaisedButton(title: "删除")
                delete.pulseColor = .white
                delete.titleColor = .white
                delete.backgroundColor = Color.blue.base
                containerView.addSubview(delete)
                delete.snp.makeConstraints { (make) in
                    make.width.equalTo(120)
                    make.height.equalTo(30)
                    make.top.equalTo(self.requirment.snp.bottom).offset(20)
                    make.trailing.equalTo(requirment.snp.trailing)
                }
                
                delete.addTarget(self, action: #selector(handleDeleteButton(button:)), for: .touchUpInside)
                
                
            }else{
                
                cancel = RaisedButton(title: "取消")
                cancel.pulseColor = .white
                cancel.titleColor = .white
                cancel.backgroundColor = Color.blue.base
                containerView.addSubview(cancel)
                cancel.snp.makeConstraints { (make) in
                    make.width.equalTo(120)
                    make.height.equalTo(30)
                    make.top.equalTo(self.requirment.snp.bottom).offset(20)
                    make.trailing.equalTo(requirment.snp.trailing)
                }
                
                cancel.addTarget(self, action: #selector(handleCancelButton(button:)), for: .touchUpInside)
            
            
        }
     
            
            
        }
        if UserService.shared.processStatus == 1 {
            
            addTask = RaisedButton(title: "添加任务")
            addTask.pulseColor = .white
            addTask.titleColor = .white
            addTask.backgroundColor = Color.blue.base
            containerView.addSubview(addTask)
            addTask.snp.makeConstraints { (make) in
                make.width.equalTo(120)
                make.height.equalTo(30)
                make.top.equalTo(self.requirment.snp.bottom).offset(20)
                make.leading.equalTo(requirment.snp.leading)
            }
            
            
            addTask.addTarget(self, action: #selector(handleAddTaskResponderButton(button:)), for: .touchUpInside)
          
            cancelTask = RaisedButton(title: "取消任务")
            cancelTask.pulseColor = .white
            cancelTask.titleColor = .white
            cancelTask.backgroundColor = Color.blue.base
            containerView.addSubview(cancelTask)
            cancelTask.snp.makeConstraints { (make) in
                make.width.equalTo(120)
                make.height.equalTo(30)
                make.top.equalTo(self.requirment.snp.bottom).offset(20)
                make.trailing.equalTo(requirment.snp.trailing)
            }
            
            cancelTask.addTarget(self, action: #selector(handleCancelAddTaskButton(button:)), for: .touchUpInside)

        }
        
        containerView.snp.makeConstraints({ (make) -> Void in
            
            make.bottom.equalTo(requirment.snp.bottom).offset(50)
            
        })
        
 
        
        
    }
    
   
    
    
    
    @objc func doneButtonAction()
    {
        self.view.endEditing(true)
    }
    
    
    
    
    @objc
    internal func handleGogalDetail(button: UIButton){
        let cdpop = GogalDetailPopUp()
        cdpop.gogalres = CourseService.shared.gogalMap[self.goalID]!
        let popup = PopupDialog(viewController: cdpop,
                                buttonAlignment: .horizontal,
                                transitionStyle: .bounceDown,
                                tapGestureDismissal: true,
                                panGestureDismissal: false)
        
        let buttonOne = CancelButton(title: "关闭") {
            
        }
        popup.addButtons([buttonOne])
        self.present(popup, animated: true, completion: nil)
        
        
    }
    
    
    
    @objc
    internal func handleCourseDetail(button: UIButton){
        let cdpop = CourseDetailPopUp()
        cdpop.courseRs = CourseService.shared.courseMap[self.courseID]
        let popup = PopupDialog(viewController: cdpop,
                                buttonAlignment: .horizontal,
                                transitionStyle: .bounceDown,
                                tapGestureDismissal: true,
                                panGestureDismissal: false)
        
        let buttonOne = CancelButton(title: "关闭") {
            
        }
        popup.addButtons([buttonOne])
        self.present(popup, animated: true, completion: nil)
        
        
    }
    
    
    
    
    @objc
    internal func handleAddTaskResponderButton(button: UIButton) {
        
        
        let atp = AddNewTaskPopup()
        let popup1 = PopupDialog(viewController: atp,
                                 buttonAlignment: .horizontal,
                                 transitionStyle: .bounceDown,
                                 tapGestureDismissal: false,
                                 panGestureDismissal: false)
        
        
        
        let changePw = DefaultButton(title: "添加", dismissOnTap: false) {
            
            
            if let title = atp.taskNameField.text {
                if title == "" {
                    atp.errorLebel.isHidden = false
                    atp.errorLebel.text = "错误 请输入任务标题"
                    return
                    
                }else{
                    atp.errorLebel.isHidden = true
                    atp.errorLebel.text = ""
                }
                
            }
            
            
            if let content = atp.taskContentTextField.text {
                if content == "" {
                    atp.errorLebel.isHidden = false
                    atp.errorLebel.text = "错误 请输入任务内容"
                    return
                    
                }else{
                    atp.errorLebel.isHidden = true
                    atp.errorLebel.text = ""
             
                }
                
            }
            
          
            

            let request = TaskReq(
                userID:self.parentId!,
                consultantID:UserService.shared.localUserId!,
                courseID:self.courseID,
                goalID:self.goalID,
                goalBreakID:self.breakObj!.id,
                taskTitle:atp.taskNameField.text!,
                taskContent:atp.taskContentTextField.text!
            )
            
            let view = MessageView.viewFromNib(layout: .cardView)
            view.layoutMarginAdditions = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
            view.button?.isHidden = true
            (view.backgroundView as? CornerRoundingView)?.cornerRadius = 10
            
            TaskService.shared.assignTask(taskReq: request).done{
                taskRes in
                if taskRes != nil && taskRes.id != nil {
                    
                   
                    
                    view.configureTheme(.success)
                    view.configureContent(title: "成功", body: "添加任务成功！", iconText: "")
                    SwiftMessages.show(view: view)
                    self.navigationController?.popToRootViewController(animated: true)
                    popup1.dismiss()
                }else{
                    view.configureTheme(.error)
                    view.configureContent(title: "失败！", body: "稍后重试", iconText: "")
                    SwiftMessages.show(view: view)
                    popup1.dismiss()
                    
                    
                }
                
                } .catch { error in
                    view.configureTheme(.error)
                    view.configureContent(title: "添加任务失败！", body: "网络故障请重试", iconText: "")
                    SwiftMessages.show(view: view)
                    popup1.dismiss()
                    print(error)
            }
            
            
    
            
            
            
            
            
        };
        let buttonOne = CancelButton(title: "关闭") {
           
        }
        popup1.addButtons([changePw,buttonOne])
        self.present(popup1, animated: true, completion: nil)
        

        
    }
    
    
    
    @objc
    internal func handleCancelAddTaskButton(button: UIButton) {
         self.navigationController?.popViewController(animated: false)

        
        
        
    }
    
    
    @objc
    internal func handleDeleteButton(button: UIButton) {
        
        let view = MessageView.viewFromNib(layout: .cardView)
        view.layoutMarginAdditions = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        view.button?.isHidden = true
        (view.backgroundView as? CornerRoundingView)?.cornerRadius = 10
        
        
        BreakService.shared.deleteBreak(breakId: breakObj!.id).done {
            (deleteBreakRes) in
            
            if deleteBreakRes.id != nil {
                
                view.configureTheme(.success)
                view.configureContent(title: "成功", body: "删除成功！", iconText: "")
                
                SwiftMessages.show(view: view)
                self.navigationController?.popViewController(animated: false)
                
            }else{
                view.configureTheme(.error)
                view.configureContent(title: "删除失败！", body: "稍后重试", iconText: "")
                SwiftMessages.show(view: view)
                
            }
            
            
            
            }  .catch { error in
                view.configureTheme(.error)
                view.configureContent(title: "保存失败！", body: "网络故障请重试", iconText: "")
                SwiftMessages.show(view: view)
                print(error)
        }
        
        self.navigationController?.popViewController(animated: false)
    }
    func prepareNavigationItem() {
        self.navigationController?.navigationBar.barStyle = UIBarStyle.blackTranslucent
        navigationItem.titleLabel.text = "剖析"
    
    }
        
    @objc
    internal func handleSaveResponderButton(button: UIButton) {
        
        let view = MessageView.viewFromNib(layout: .cardView)
        view.layoutMarginAdditions = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        view.button?.isHidden = true
        (view.backgroundView as? CornerRoundingView)?.cornerRadius = 10
        
        
        
        if let titleValue = titleField.text {
            if titleValue == "" {
                view.configureTheme(.error)
                view.configureContent(title: "错误", body: "剖析标题不能为空", iconText: "")
                SwiftMessages.show(view: view)
                return
                
            }
            
        }
        
        if let descValue = desc.text {
            if descValue == "" {
                view.configureTheme(.error)
                view.configureContent(title: "错误", body: "剖析说明不能为空", iconText: "")
                SwiftMessages.show(view: view)
                return
                
            }
            
        }
        var requirmentValue = ""
        var breakQuestionValue = ""
        
        if question.text != nil{
            breakQuestionValue = question.text!
        }
        
        if requirment.text != nil{
            requirmentValue = requirment.text!
        }
        
        
        if isUpdate {
            
            let request = UpdateReq(
                id:breakObj!.id,
                breakTitle:titleField.text!,
                breakDesc:desc.text!,
                breakQuestion:breakQuestionValue,
                breakRequirement:requirmentValue
            )
            BreakService.shared.updateBreak(updateReq: request).done { breakRes in
                if breakRes.id != nil {
                    
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
            
        }else{
            
            let request = BreakReq(
                userID:UserService.shared.localUserId!,
                courseID:self.courseID,
                goalID:self.goalID,
                breakTitle:titleField.text!,
                breakDesc:desc.text!,
                breakQuestion:breakQuestionValue,
                breakRequirement:requirmentValue
            )
            
            
            BreakService.shared.addBreak(breakReq:request).done { breakRes in
                if breakRes.id != nil {
                    
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
 
     
        
    }
    @objc func viewTapped(gestureReconizer:UITapGestureRecognizer){
        self.view.endEditing(true)
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
//        if textView.text == "" {
//            if textView.tag == 1{
//                textView.text = "说明"
//            }
//            if textView.tag == 2{
//                textView.text = "有意义的不确定性"
//            }
//            if textView.tag == 3{
//                textView.text = "精通条件"
//            }
//
//            textView.textColor = UIColor.lightGray
//        }
        
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
    

  


