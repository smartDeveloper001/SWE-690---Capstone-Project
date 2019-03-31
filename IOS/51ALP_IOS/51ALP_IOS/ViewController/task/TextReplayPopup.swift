//
//  TextReplayPopup.swift
//  51ALP_IOS
//
//  Created by xiu on 2/14/19.
//  Copyright © 2019 wma. All rights reserved.
//

import UIKit
import Material
import SnapKit


class TextReplayPopup: UIViewController,UITextViewDelegate {
    var errorLebel:UILabel!
    let replayTitleField = TextField()
    var replayTextView:TextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let screensize: CGRect = UIScreen.main.bounds
        let screenWidth = screensize.width
        let screenHight = screensize.height
        self.view.frame=CGRect(x: 0,y: 0,width: screenWidth*0.8,height: screenHight*0.4)
        errorLebel = UILabel()
        errorLebel.text = ""
        errorLebel.isHidden = true
        errorLebel.textColor = UIColor.red
        errorLebel.font=UIFont.systemFont(ofSize: 15)
        errorLebel.textAlignment = NSTextAlignment.center
        view.addSubview(errorLebel)
        errorLebel.translatesAutoresizingMaskIntoConstraints = false
        errorLebel.topAnchor.constraint(equalTo:view.topAnchor,constant: 10).isActive = true
        errorLebel.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
        errorLebel.heightAnchor.constraint(equalToConstant: 25  ).isActive = true
        errorLebel.widthAnchor.constraint(equalToConstant: 150).isActive = true
        errorLebel.bottomAnchor.constraint(equalTo:view.bottomAnchor,constant: -screenHight*0.42).isActive = true

      
        replayTitleField.isEnabled = true
        replayTitleField.font = UIFont.systemFont(ofSize: 15)
        replayTitleField.placeholder="标题"
        replayTitleField.isClearIconButtonEnabled = true
        replayTitleField.isPlaceholderUppercasedWhenEditing = true
        replayTitleField.placeholderAnimation = .hidden
        replayTitleField.dividerNormalColor = .gray
        
        view.addSubview(replayTitleField)
        replayTitleField.translatesAutoresizingMaskIntoConstraints = false
        replayTitleField.topAnchor.constraint(equalTo:view.topAnchor,constant: 40).isActive = true
        replayTitleField.leftAnchor.constraint(equalTo:view.leftAnchor,constant:10).isActive = true
        replayTitleField.heightAnchor.constraint(equalToConstant: 25  ).isActive = true
        replayTitleField.widthAnchor.constraint(equalToConstant: 150).isActive = true
//        replayTitleField.bottomAnchor.constraint(equalTo:view.bottomAnchor,constant: -screenHight*0.4).isActive = true
        
        
        
        replayTextView = TextView()
        replayTextView.isEditable = true
        replayTextView.placeholder = "回复内容"

        replayTextView.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        replayTextView.layer.borderWidth = 1.0
        replayTextView.layer.cornerRadius = 5

        view.addSubview(replayTextView)
        replayTextView.translatesAutoresizingMaskIntoConstraints = false
        replayTextView.topAnchor.constraint(equalTo:replayTitleField.bottomAnchor,constant: 20).isActive = true
        replayTextView.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
        replayTextView.heightAnchor.constraint(equalToConstant:screenHight*0.3   ).isActive = true
        replayTextView.widthAnchor.constraint( equalToConstant: screenWidth*0.75).isActive = true

        
        let keyboardToolBar = UIToolbar()
        keyboardToolBar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem:
            UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem:
            UIBarButtonItem.SystemItem.done, target: self, action: #selector(self.doneButtonAction) )
        keyboardToolBar.setItems([flexibleSpace, doneButton], animated: true)
        replayTitleField.inputAccessoryView = keyboardToolBar
        replayTextView.inputAccessoryView = keyboardToolBar

        
        
        
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

