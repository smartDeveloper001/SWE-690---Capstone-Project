//
//  MsgViewController.swift
//  51ALP_IOS
//
//  Created by xiu on 2/12/19.
//  Copyright © 2019 wma. All rights reserved.
//

import UIKit

class MsgViewController: UIViewController {
    
    let consultantAva = UIImageView()
    let consultantTitle = UILabel()
    let consultantDetail = UITextView(frame:CGRect(x:10, y:20, width:300, height:400))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.addSubview(consultantAva)
        consultantAva.translatesAutoresizingMaskIntoConstraints = false
        consultantAva.topAnchor.constraint(equalTo:view.topAnchor,constant: 10).isActive = true
        consultantAva.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
        consultantAva.heightAnchor.constraint(equalToConstant: 50  ).isActive = true
        consultantAva.widthAnchor.constraint(equalToConstant: 50).isActive = true
        consultantAva.bottomAnchor.constraint(equalTo:view.bottomAnchor,constant: -500).isActive = true
        
        
        consultantTitle.font=UIFont.systemFont(ofSize: 15)
        consultantTitle.textAlignment = NSTextAlignment.center
        view.addSubview(consultantTitle)
        consultantTitle.translatesAutoresizingMaskIntoConstraints = false
        consultantTitle.topAnchor.constraint(equalTo:consultantAva.topAnchor,constant: 80).isActive = true
        consultantTitle.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
        consultantTitle.heightAnchor.constraint(equalToConstant: 25  ).isActive = true
        consultantTitle.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
        
        consultantDetail.font=UIFont.systemFont(ofSize: 15)
        consultantDetail.textAlignment = NSTextAlignment.left
        view.addSubview(consultantDetail)
        consultantDetail.translatesAutoresizingMaskIntoConstraints = false
        consultantDetail.topAnchor.constraint(equalTo:consultantAva.topAnchor,constant: 30).isActive = true
        consultantDetail.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
        consultantDetail.heightAnchor.constraint(equalToConstant: 400  ).isActive = true
        consultantDetail.widthAnchor.constraint(equalToConstant: 300).isActive = true
        
        
}
}

