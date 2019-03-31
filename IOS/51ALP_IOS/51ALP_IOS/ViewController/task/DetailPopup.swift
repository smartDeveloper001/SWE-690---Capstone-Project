//
//  DetailPopup.swift
//  51ALP_IOS
//
//  Created by xiu on 2/12/19.
//  Copyright © 2019 wma. All rights reserved.
//

import UIKit

class DetailPopup: UIViewController      {
    
    let detailTitle = UILabel()
    let detailConent = UITextView(frame:CGRect(x:10, y:20, width:300, height:400))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailTitle.font=UIFont.systemFont(ofSize: 15)
        detailTitle.textAlignment = NSTextAlignment.center
        view.addSubview(detailTitle)
        detailTitle.translatesAutoresizingMaskIntoConstraints = false
        detailTitle.topAnchor.constraint(equalTo:view.topAnchor,constant: 80).isActive = true
        detailTitle.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
        detailTitle.heightAnchor.constraint(equalToConstant: 25  ).isActive = true
        detailTitle.widthAnchor.constraint(equalToConstant: 150).isActive = true
        detailTitle.bottomAnchor.constraint(equalTo:view.bottomAnchor,constant: -500).isActive = true
        
    
        
        detailConent.font=UIFont.systemFont(ofSize: 15)
        detailConent.textAlignment = NSTextAlignment.left
        view.addSubview(detailConent)
        detailConent.translatesAutoresizingMaskIntoConstraints = false
        detailConent.topAnchor.constraint(equalTo:detailTitle.topAnchor,constant: 30).isActive = true
        detailConent.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
        detailConent.heightAnchor.constraint(equalToConstant: 400  ).isActive = true
        detailConent.widthAnchor.constraint(equalToConstant: 300).isActive = true
        
        
    }
    
    
}
