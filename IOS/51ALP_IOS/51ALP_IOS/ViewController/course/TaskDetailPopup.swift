//
//  TaskDetailPopup.swift
//  51ALP_IOS
//
//  Created by xiu on 3/24/19.
//  Copyright © 2019 wma. All rights reserved.
//

import UIKit

class TaskDetailPopup:UIViewController,UITextViewDelegate {
    var popupTitle:UILabel!
    var taskContent:UITextView!
    var taskRes:TaskRes!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screensize: CGRect = UIScreen.main.bounds
        let screenWidth = screensize.width
        let screenHight = screensize.height
        
        self.view.frame=CGRect(x: 0,y: 0,width: screenWidth*0.8,height: screenHight*0.8)
        popupTitle = UILabel()
        popupTitle.text = taskRes.taskTitle
        popupTitle.font=UIFont.systemFont(ofSize: 15)
        popupTitle.textAlignment = NSTextAlignment.center
        view.addSubview(popupTitle)
        popupTitle.translatesAutoresizingMaskIntoConstraints = false
        popupTitle.topAnchor.constraint(equalTo:view.topAnchor,constant: 10).isActive = true
        popupTitle.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
        popupTitle.heightAnchor.constraint(equalToConstant: 25  ).isActive = true
        popupTitle.widthAnchor.constraint(equalToConstant: 150).isActive = true
        popupTitle.bottomAnchor.constraint(equalTo:view.bottomAnchor,constant: -screenHight*0.4).isActive = true
        
  
        
        taskContent = UITextView(frame:CGRect(x:10, y:20, width:screenWidth*0.6, height:screenHight*0.3))
        taskContent.isEditable = false
        taskContent.text = taskRes.taskContent
        
        taskContent.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        taskContent.layer.borderWidth = 1.0
        taskContent.layer.cornerRadius = 5
        
        view.addSubview(taskContent)
        taskContent.translatesAutoresizingMaskIntoConstraints = false
        taskContent.topAnchor.constraint(equalTo:popupTitle.bottomAnchor,constant: 10).isActive = true
        taskContent.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
        taskContent.heightAnchor.constraint(equalToConstant: screenHight*0.2  ).isActive = true
        taskContent.widthAnchor.constraint(equalToConstant: screenWidth*0.75).isActive = true
        
        
        
       
        
    }
    
    
    
    
}

