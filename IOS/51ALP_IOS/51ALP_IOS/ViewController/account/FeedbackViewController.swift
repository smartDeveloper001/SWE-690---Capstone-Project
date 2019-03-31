//
//  FeedbackViewController.swift
//  51ALP_IOS
//
//  Created by xiu on 2/10/19.
//  Copyright © 2019 wma. All rights reserved.
//

import UIKit
import Material


class FeedbackViewController: UIViewController,UITextViewDelegate {
    var popupTitle:UILabel!
    var feedbackText:UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screensize: CGRect = UIScreen.main.bounds
        let screenWidth = screensize.width
        let screenHight = screensize.height
   
        //self.view = UIView(frame: CGRect(x: 0,y: 0,width: screenWidth*0.8,height: screenHight*0.4))
        self.view.frame=CGRect(x: 0,y: 0,width: screenWidth*0.8,height: screenHight*0.4)
        popupTitle = UILabel()
        popupTitle.text = "反馈"
        popupTitle.font=UIFont.systemFont(ofSize: 15)
        popupTitle.textAlignment = NSTextAlignment.center
        view.addSubview(popupTitle)
        popupTitle.translatesAutoresizingMaskIntoConstraints = false
        popupTitle.topAnchor.constraint(equalTo:view.topAnchor,constant: 10).isActive = true
        popupTitle.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
        popupTitle.heightAnchor.constraint(equalToConstant: 25  ).isActive = true
        popupTitle.widthAnchor.constraint(equalToConstant: 150).isActive = true
        popupTitle.bottomAnchor.constraint(equalTo:view.bottomAnchor,constant: -screenHight*0.4).isActive = true
        
        
        
        feedbackText = UITextView(frame:CGRect(x:10, y:20, width:screenWidth*0.6, height:screenHight*0.3))
        feedbackText.isEditable = true
      
        feedbackText.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        feedbackText.layer.borderWidth = 1.0
        feedbackText.layer.cornerRadius = 5
        
        view.addSubview(feedbackText)
        feedbackText.translatesAutoresizingMaskIntoConstraints = false
        feedbackText.topAnchor.constraint(equalTo:popupTitle.bottomAnchor,constant: 20).isActive = true
        feedbackText.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
        feedbackText.heightAnchor.constraint(equalToConstant: screenHight*0.3  ).isActive = true
        feedbackText.widthAnchor.constraint(equalToConstant: screenWidth*0.75).isActive = true

        
        let keyboardToolBar = UIToolbar()
        keyboardToolBar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem:
            UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem:
            UIBarButtonItem.SystemItem.done, target: self, action: #selector(self.doneButtonAction) )
        keyboardToolBar.setItems([flexibleSpace, doneButton], animated: true)
        self.feedbackText.inputAccessoryView = keyboardToolBar
 
        
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
