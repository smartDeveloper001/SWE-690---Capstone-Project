//
//  GogalDetailPopUp.swift
//  51ALP_IOS
//
//  Created by xiu on 3/24/19.
//  Copyright © 2019 wma. All rights reserved.
//

import UIKit

class GogalDetailPopUp: UIViewController,UITextViewDelegate {
    var popupTitle:UILabel!
    var gogalTarget:UITextView!
    var gogalres:GogalRes!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screensize: CGRect = UIScreen.main.bounds
        let screenWidth = screensize.width
        let screenHight = screensize.height
        
        self.view.frame=CGRect(x: 0,y: 0,width: screenWidth*0.8,height: screenHight*0.8)
        popupTitle = UILabel()
        popupTitle.text = gogalres.goalName
        popupTitle.font=UIFont.systemFont(ofSize: 15)
        popupTitle.textAlignment = NSTextAlignment.center
        view.addSubview(popupTitle)
        popupTitle.translatesAutoresizingMaskIntoConstraints = false
        popupTitle.topAnchor.constraint(equalTo:view.topAnchor,constant: 10).isActive = true
        popupTitle.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
        popupTitle.heightAnchor.constraint(equalToConstant: 25  ).isActive = true
        popupTitle.widthAnchor.constraint(equalToConstant: 150).isActive = true
        popupTitle.bottomAnchor.constraint(equalTo:view.bottomAnchor,constant: -screenHight*0.8).isActive = true
        
        
        
        let gogalTargetTitle = UILabel()
        gogalTargetTitle.text = "目标说明"
        gogalTargetTitle.font=UIFont.systemFont(ofSize:12)
        gogalTargetTitle.textAlignment = NSTextAlignment.center
        view.addSubview(gogalTargetTitle)
        gogalTargetTitle.translatesAutoresizingMaskIntoConstraints = false
        gogalTargetTitle.topAnchor.constraint(equalTo:popupTitle.bottomAnchor,constant: 5).isActive = true
        gogalTargetTitle.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
        gogalTargetTitle.heightAnchor.constraint(equalToConstant: 25  ).isActive = true
        gogalTargetTitle.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
        
        
        
        gogalTarget = UITextView(frame:CGRect(x:10, y:20, width:screenWidth*0.6, height:screenHight*0.3))
        gogalTarget.isEditable = false
        gogalTarget.text = gogalres.goalDescrib
        
        gogalTarget.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        gogalTarget.layer.borderWidth = 1.0
        gogalTarget.layer.cornerRadius = 5
        
        view.addSubview(gogalTarget)
        gogalTarget.translatesAutoresizingMaskIntoConstraints = false
        gogalTarget.topAnchor.constraint(equalTo:gogalTargetTitle.bottomAnchor,constant: 10).isActive = true
        gogalTarget.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
        gogalTarget.heightAnchor.constraint(equalToConstant: screenHight*0.3  ).isActive = true
        gogalTarget.widthAnchor.constraint(equalToConstant: screenWidth*0.75).isActive = true
        
        
        
        
        let gogalContent = UILabel()
        gogalContent.text = "目标内容"
        gogalContent.font=UIFont.systemFont(ofSize:12)
        gogalContent.textAlignment = NSTextAlignment.center
        view.addSubview(gogalContent)
        gogalContent.translatesAutoresizingMaskIntoConstraints = false
        gogalContent.topAnchor.constraint(equalTo:gogalTarget.bottomAnchor,constant: 20).isActive = true
        gogalContent.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
        gogalContent.heightAnchor.constraint(equalToConstant: 25  ).isActive = true
        gogalContent.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
        
        
        let gogalConetent = UITextView(frame:CGRect(x:10, y:20, width:screenWidth*0.6, height:screenHight*0.3))
        gogalConetent.isEditable = false
        gogalConetent.text = gogalres.goalRequirement
        gogalConetent.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        gogalConetent.layer.borderWidth = 1.0
        gogalConetent.layer.cornerRadius = 5
        
        view.addSubview(gogalConetent)
        gogalConetent.translatesAutoresizingMaskIntoConstraints = false
        gogalConetent.topAnchor.constraint(equalTo:gogalContent.bottomAnchor,constant: 5).isActive = true
        gogalConetent.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
        gogalConetent.heightAnchor.constraint(equalToConstant: screenHight*0.3  ).isActive = true
        gogalConetent.widthAnchor.constraint(equalToConstant: screenWidth*0.75).isActive = true
        
    }
    
    
    
    
}

