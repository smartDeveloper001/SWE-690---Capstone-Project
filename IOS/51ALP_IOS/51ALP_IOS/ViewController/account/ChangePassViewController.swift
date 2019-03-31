//
//  ChangePassViewController.swift
//  51ALP_IOS
//
//  Created by xiu on 2/10/19.
//  Copyright © 2019 wma. All rights reserved.
//

import UIKit
import SnapKit
import Material
class ChangePassViewController: UIViewController {
    var popupTitle:UILabel!
    var old_passwordField: TextField!
    var new_passwordField: TextField!
    var new2_passwordField: TextField!
    
  
    override func viewDidLoad() {

        super.viewDidLoad()
        self.view = UIView(frame: CGRect(x: 0,y: 0,width: 400,height: 400))
       
        
        
        popupTitle = UILabel()
        popupTitle.text = "修改密码"
        popupTitle.font=UIFont.systemFont(ofSize: 15)
        popupTitle.textAlignment = NSTextAlignment.center
        view.addSubview(popupTitle)
        popupTitle.translatesAutoresizingMaskIntoConstraints = false
        popupTitle.topAnchor.constraint(equalTo:view.topAnchor,constant: 10).isActive = true
        popupTitle.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
        popupTitle.heightAnchor.constraint(equalToConstant: 25  ).isActive = true
        popupTitle.widthAnchor.constraint(equalToConstant: 150).isActive = true
        popupTitle.bottomAnchor.constraint(equalTo:view.bottomAnchor,constant: -300).isActive = true
    
    
    
        old_passwordField = TextField()
        old_passwordField.placeholder = "旧密码"
        
        old_passwordField.detail = "At least 8 characters"
        old_passwordField.clearButtonMode = .whileEditing
        old_passwordField.isVisibilityIconButtonEnabled = true
        old_passwordField.dividerNormalColor = .gray
        old_passwordField.visibilityIconButton?.tintColor = Color.green.base.withAlphaComponent(old_passwordField.isSecureTextEntry ? 0.38 : 0.54)
        view.addSubview(old_passwordField)
        old_passwordField.translatesAutoresizingMaskIntoConstraints = false
        old_passwordField.topAnchor.constraint(equalTo:popupTitle.bottomAnchor,constant: 40).isActive = true
        old_passwordField.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
        old_passwordField.heightAnchor.constraint(equalToConstant: 30  ).isActive = true
        old_passwordField.widthAnchor.constraint(equalToConstant: 300).isActive = true

        
        
        
        new_passwordField = TextField()
        new_passwordField.placeholder = "新密码"
        new_passwordField.detail = "At least 8 characters"
        new_passwordField.clearButtonMode = .whileEditing
        new_passwordField.isVisibilityIconButtonEnabled = true
        new_passwordField.dividerNormalColor = .gray
        new_passwordField.visibilityIconButton?.tintColor = Color.green.base.withAlphaComponent(new_passwordField.isSecureTextEntry ? 0.38 : 0.54)
        view.addSubview(new_passwordField)
        new_passwordField.translatesAutoresizingMaskIntoConstraints = false
        new_passwordField.topAnchor.constraint(equalTo:old_passwordField.bottomAnchor,constant: 40).isActive = true
        new_passwordField.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
        new_passwordField.heightAnchor.constraint(equalToConstant: 30  ).isActive = true
        new_passwordField.widthAnchor.constraint(equalToConstant: 300).isActive = true
        
        
        
        new2_passwordField = TextField()
        new2_passwordField.placeholder = "再次输入新密码"
        new2_passwordField.detail = "At least 8 characters"
        new2_passwordField.clearButtonMode = .whileEditing
        new2_passwordField.isVisibilityIconButtonEnabled = true
        new2_passwordField.dividerNormalColor = .gray
        new2_passwordField.visibilityIconButton?.tintColor = Color.green.base.withAlphaComponent(new2_passwordField.isSecureTextEntry ? 0.38 : 0.54)
        view.addSubview(new2_passwordField)
        new2_passwordField.translatesAutoresizingMaskIntoConstraints = false
        new2_passwordField.topAnchor.constraint(equalTo:new_passwordField.bottomAnchor,constant: 40).isActive = true
        new2_passwordField.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
        new2_passwordField.heightAnchor.constraint(equalToConstant: 30  ).isActive = true
        new2_passwordField.widthAnchor.constraint(equalToConstant: 300).isActive = true

        
      
        
        let keyboardToolBar = UIToolbar()
        keyboardToolBar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem:
            UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem:
            UIBarButtonItem.SystemItem.done, target: self, action: #selector(self.doneButtonAction) )
        keyboardToolBar.setItems([flexibleSpace, doneButton], animated: true)
        old_passwordField.inputAccessoryView = keyboardToolBar
        new_passwordField.inputAccessoryView = keyboardToolBar
        new2_passwordField.inputAccessoryView = keyboardToolBar
        
        
        
        
    }
    
    @objc func doneButtonAction()
    {
        self.view.endEditing(true)
    }
    

}
