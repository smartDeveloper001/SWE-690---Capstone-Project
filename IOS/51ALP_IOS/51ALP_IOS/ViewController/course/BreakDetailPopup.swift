//
//  BreakDetailPopup.swift
//  51ALP_IOS
//
//  Created by xiu on 3/24/19.
//  Copyright © 2019 wma. All rights reserved.
//

import UIKit

class BreakDetailPopup :UIViewController,UITextViewDelegate {
    var popupTitle:UILabel!
    var breakContent:UITextView!
    var breakRes:BreakRes!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screensize: CGRect = UIScreen.main.bounds
        let screenWidth = screensize.width
        let screenHight = screensize.height
        
        self.view.frame=CGRect(x: 0,y: 0,width: screenWidth*0.8,height: screenHight*0.8)
        popupTitle = UILabel()
        popupTitle.text = breakRes.breakTitle
        popupTitle.font=UIFont.systemFont(ofSize: 15)
        popupTitle.textAlignment = NSTextAlignment.center
        view.addSubview(popupTitle)
        popupTitle.translatesAutoresizingMaskIntoConstraints = false
        popupTitle.topAnchor.constraint(equalTo:view.topAnchor,constant: 10).isActive = true
        popupTitle.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
        popupTitle.heightAnchor.constraint(equalToConstant: 25  ).isActive = true
        popupTitle.widthAnchor.constraint(equalToConstant: 150).isActive = true
        popupTitle.bottomAnchor.constraint(equalTo:view.bottomAnchor,constant: -screenHight*0.8).isActive = true
        
        
        
        let breakTitle = UILabel()
        breakTitle.text = "剖析说明"
        breakTitle.font=UIFont.systemFont(ofSize:12)
        breakTitle.textAlignment = NSTextAlignment.center
        view.addSubview(breakTitle)
        breakTitle.translatesAutoresizingMaskIntoConstraints = false
        breakTitle.topAnchor.constraint(equalTo:popupTitle.bottomAnchor,constant: 5).isActive = true
        breakTitle.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
        breakTitle.heightAnchor.constraint(equalToConstant: 25  ).isActive = true
        breakTitle.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
        
        
        
        breakContent = UITextView(frame:CGRect(x:10, y:20, width:screenWidth*0.6, height:screenHight*0.3))
        breakContent.isEditable = false
        breakContent.text = breakRes.breakDesc
        
        breakContent.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        breakContent.layer.borderWidth = 1.0
        breakContent.layer.cornerRadius = 5
        
        view.addSubview(breakContent)
        breakContent.translatesAutoresizingMaskIntoConstraints = false
        breakContent.topAnchor.constraint(equalTo:breakTitle.bottomAnchor,constant: 10).isActive = true
        breakContent.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
        breakContent.heightAnchor.constraint(equalToConstant: screenHight*0.3  ).isActive = true
        breakContent.widthAnchor.constraint(equalToConstant: screenWidth*0.75).isActive = true
        
        
        
        
        let breakRequrimentLabel = UILabel()
        breakRequrimentLabel.text = "精通条件"
        breakRequrimentLabel.font=UIFont.systemFont(ofSize:12)
        breakRequrimentLabel.textAlignment = NSTextAlignment.center
        view.addSubview(breakRequrimentLabel)
        breakRequrimentLabel.translatesAutoresizingMaskIntoConstraints = false
        breakRequrimentLabel.topAnchor.constraint(equalTo:breakContent.bottomAnchor,constant: 20).isActive = true
        breakRequrimentLabel.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
        breakRequrimentLabel.heightAnchor.constraint(equalToConstant: 25  ).isActive = true
        breakRequrimentLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
        
        
        let breakRequriment = UITextView(frame:CGRect(x:10, y:20, width:screenWidth*0.6, height:screenHight*0.3))
        breakRequriment.isEditable = false
        breakRequriment.text = breakRes.breakRequirement
        breakRequriment.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        breakRequriment.layer.borderWidth = 1.0
        breakRequriment.layer.cornerRadius = 5
        
        view.addSubview(breakRequriment)
        breakRequriment.translatesAutoresizingMaskIntoConstraints = false
        breakRequriment.topAnchor.constraint(equalTo:breakRequrimentLabel.bottomAnchor,constant: 5).isActive = true
        breakRequriment.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
        breakRequriment.heightAnchor.constraint(equalToConstant: screenHight*0.3  ).isActive = true
        breakRequriment.widthAnchor.constraint(equalToConstant: screenWidth*0.75).isActive = true
        
    }
    
    
    
    
}

