//
//  AddNewTaskPopup.swift
//  51ALP_IOS
//
//  Created by xiu on 2/12/19.
//  Copyright © 2019 wma. All rights reserved.
//

import UIKit
import Material
class AddNewTaskPopup: UIViewController,UITextViewDelegate {
    var popupTitle:UILabel!
    var errorLebel:UILabel!
    var taskNameField:TextField!
    var taskContentTextField:UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screensize: CGRect = UIScreen.main.bounds
        let screenWidth = screensize.width
        let screenHight = screensize.height
        self.view.frame=CGRect(x: 0,y: 0,width: screenWidth*0.8,height: screenHight*0.4)
        popupTitle = UILabel()
        popupTitle.text = "添加新任务"
        popupTitle.font=UIFont.systemFont(ofSize: 15)
        popupTitle.textAlignment = NSTextAlignment.center
        view.addSubview(popupTitle)
        popupTitle.translatesAutoresizingMaskIntoConstraints = false
        popupTitle.topAnchor.constraint(equalTo:view.topAnchor,constant: 10).isActive = true
        popupTitle.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
        popupTitle.heightAnchor.constraint(equalToConstant: 25  ).isActive = true
        popupTitle.widthAnchor.constraint(equalToConstant: 150).isActive = true
        popupTitle.bottomAnchor.constraint(equalTo:view.bottomAnchor,constant: -screenHight*0.4).isActive = true
        
        errorLebel = UILabel()
        errorLebel.text = "错误 请输入任务内容"
        errorLebel.isHidden = true
        errorLebel.textColor = UIColor.red
        errorLebel.font=UIFont.systemFont(ofSize: 15)
        errorLebel.textAlignment = NSTextAlignment.center
        view.addSubview(errorLebel)
        errorLebel.translatesAutoresizingMaskIntoConstraints = false
        errorLebel.topAnchor.constraint(equalTo:view.topAnchor,constant: 30).isActive = true
        errorLebel.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
        errorLebel.heightAnchor.constraint(equalToConstant: 25  ).isActive = true
        errorLebel.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
        
        
        
        taskNameField = TextField()
        
        taskNameField.placeholder = "新任务名称"
        taskNameField.isClearIconButtonEnabled = true
        taskNameField.isPlaceholderUppercasedWhenEditing = true
        taskNameField.placeholderAnimation = .hidden
        taskNameField.dividerNormalColor = .gray
        view.addSubview(taskNameField)
        taskNameField.translatesAutoresizingMaskIntoConstraints = false
        taskNameField.topAnchor.constraint(equalTo:popupTitle.bottomAnchor,constant: 40).isActive = true
        taskNameField.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
        taskNameField.heightAnchor.constraint(equalToConstant: 20  ).isActive = true
        taskNameField.widthAnchor.constraint( equalToConstant: screenWidth*0.75).isActive = true
        
        
        
        taskContentTextField = UITextView()
        taskContentTextField.isEditable = true
        
        taskContentTextField.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        taskContentTextField.layer.borderWidth = 1.0
        taskContentTextField.layer.cornerRadius = 5
        
        view.addSubview(taskContentTextField)
        taskContentTextField.translatesAutoresizingMaskIntoConstraints = false
        taskContentTextField.topAnchor.constraint(equalTo:taskNameField.bottomAnchor,constant: 10).isActive = true
        taskContentTextField.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
        taskContentTextField.heightAnchor.constraint(equalToConstant:screenHight*0.25   ).isActive = true
        taskContentTextField.widthAnchor.constraint( equalToConstant: screenWidth*0.75).isActive = true
        
 
        let keyboardToolBar = UIToolbar()
        keyboardToolBar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem:
            UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem:
            UIBarButtonItem.SystemItem.done, target: self, action: #selector(self.doneButtonAction) )
        keyboardToolBar.setItems([flexibleSpace, doneButton], animated: true)
        self.taskNameField.inputAccessoryView = keyboardToolBar
        self.taskContentTextField.inputAccessoryView = keyboardToolBar
     
 
        
    }
    
    @objc func doneButtonAction()
    {
        self.view.endEditing(true)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let str = textView.text!
        let paraph = NSMutableParagraphStyle()
        
        paraph.lineSpacing = 20
        
        let attributes = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 15),
                          NSAttributedString.Key.paragraphStyle: paraph]
        textView.attributedText = NSAttributedString(string: str, attributes: attributes)
    }
    
    
    
}
