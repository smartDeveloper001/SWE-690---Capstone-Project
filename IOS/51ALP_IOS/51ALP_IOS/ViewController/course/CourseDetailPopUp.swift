//
//  CourseDetailPopUp.swift
//  51ALP_IOS
//
//  Created by xiu on 3/24/19.
//  Copyright © 2019 wma. All rights reserved.
//

import UIKit


class CourseDetailPopUp: UIViewController,UITextViewDelegate {
    var popupTitle:UILabel!
    var courseTarget:UITextView!
    var courseRs:CourseRs!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screensize: CGRect = UIScreen.main.bounds
        let screenWidth = screensize.width
        let screenHight = screensize.height
        
        self.view.frame=CGRect(x: 0,y: 0,width: screenWidth*0.8,height: screenHight*0.8)
        popupTitle = UILabel()
        popupTitle.text = courseRs.courseName
        popupTitle.font=UIFont.systemFont(ofSize: 15)
        popupTitle.textAlignment = NSTextAlignment.center
        view.addSubview(popupTitle)
        popupTitle.translatesAutoresizingMaskIntoConstraints = false
        popupTitle.topAnchor.constraint(equalTo:view.topAnchor,constant: 10).isActive = true
        popupTitle.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
        popupTitle.heightAnchor.constraint(equalToConstant: 25  ).isActive = true
        popupTitle.widthAnchor.constraint(equalToConstant: 150).isActive = true
        popupTitle.bottomAnchor.constraint(equalTo:view.bottomAnchor,constant: -screenHight*0.8).isActive = true
        
        
        
        let courseTargetTitel = UILabel()
        courseTargetTitel.text = "课程目标"
        courseTargetTitel.font=UIFont.systemFont(ofSize:12)
        courseTargetTitel.textAlignment = NSTextAlignment.center
        view.addSubview(courseTargetTitel)
        courseTargetTitel.translatesAutoresizingMaskIntoConstraints = false
        courseTargetTitel.topAnchor.constraint(equalTo:popupTitle.bottomAnchor,constant: 5).isActive = true
        courseTargetTitel.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
        courseTargetTitel.heightAnchor.constraint(equalToConstant: 25  ).isActive = true
        courseTargetTitel.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
        
        
       
        courseTarget = UITextView(frame:CGRect(x:10, y:20, width:screenWidth*0.6, height:screenHight*0.3))
        courseTarget.isEditable = false
         courseTarget.text = courseRs.courseGoal
        
        courseTarget.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        courseTarget.layer.borderWidth = 1.0
        courseTarget.layer.cornerRadius = 5
        
        view.addSubview(courseTarget)
        courseTarget.translatesAutoresizingMaskIntoConstraints = false
        courseTarget.topAnchor.constraint(equalTo:courseTargetTitel.bottomAnchor,constant: 10).isActive = true
        courseTarget.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
        courseTarget.heightAnchor.constraint(equalToConstant: screenHight*0.3  ).isActive = true
        courseTarget.widthAnchor.constraint(equalToConstant: screenWidth*0.75).isActive = true
        
        
        
        
        let courseContentLabel = UILabel()
        courseContentLabel.text = "课程内容"
        courseContentLabel.font=UIFont.systemFont(ofSize:12)
        courseContentLabel.textAlignment = NSTextAlignment.center
        view.addSubview(courseContentLabel)
        courseContentLabel.translatesAutoresizingMaskIntoConstraints = false
        courseContentLabel.topAnchor.constraint(equalTo:courseTarget.bottomAnchor,constant: 20).isActive = true
        courseContentLabel.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
        courseContentLabel.heightAnchor.constraint(equalToConstant: 25  ).isActive = true
        courseContentLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
        
        
        let courseContent = UITextView(frame:CGRect(x:10, y:20, width:screenWidth*0.6, height:screenHight*0.3))
        courseContent.isEditable = false
        courseContent.text = courseRs.courseSyllabus
        courseContent.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        courseContent.layer.borderWidth = 1.0
        courseContent.layer.cornerRadius = 5
        
        view.addSubview(courseContent)
        courseContent.translatesAutoresizingMaskIntoConstraints = false
        courseContent.topAnchor.constraint(equalTo:courseContentLabel.bottomAnchor,constant: 5).isActive = true
        courseContent.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
        courseContent.heightAnchor.constraint(equalToConstant: screenHight*0.3  ).isActive = true
        courseContent.widthAnchor.constraint(equalToConstant: screenWidth*0.75).isActive = true

    }
    

    
    
}

