//
//  ConsultantsListViewController.swift
//  51ALP_IOS
//
//  Created by xiu on 2/10/19.
//  Copyright © 2019 wma. All rights reserved.
//

import UIKit
import Cosmos
import PopupDialog
import SwiftMessages
class ConsultantsListViewController:  UITableViewController {
    let cellIdentifier = "MyCell"
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView = UITableView(frame: CGRect.zero, style: .grouped)
        self.tableView.register(SubConsultantTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
       
        
    
    }
    
    let sectionName = ["全国"]
//    let cellImages = [["consulant.png","consulant.png","consulant.png"]]
//    let cellsData = [["张三","王凯", "李四"]]
//    let cellsDetail = [[５,５,５]]
    var consultantList:Array<User>!
    
   
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView{
        let headerView = UIView(frame: CGRect(x:0, y:0, width:tableView.frame.size.width, height:40))
        let label = UILabel()
        label.frame = CGRect.init(x: 20, y: 20, width: headerView.frame.width-10, height: headerView.frame.height-10)
        label.text = sectionName[section]
        //label.textColor = UIColor.cyan
        headerView.addSubview(label)
        return headerView
    }
    
    
    override func tableView(_ tableView: UITableView,heightForFooterInSection section: Int) -> CGFloat{
        return 0.01
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return consultantList.count
        
    }
    
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("indexPath::",indexPath)
        var title = ""
        if let username = consultantList[indexPath.row].userName{
            title = username
        }
      
        let image = UIImage(named: "consulant.png")

        var message = ""
        if let introduce = consultantList[indexPath.row].userSelfIntroduce{
            message = introduce
        }
      

        let cvc = ConsultantDetailViewController()
        cvc.consultantAva.image = image
        cvc.cosmosView.rating = 5
        cvc.consultantTitle.text = title
        cvc.consultantDetail.text = message
        let popup = PopupDialog(viewController: cvc,
                                buttonAlignment: .horizontal,
                                transitionStyle: .bounceDown,
                                tapGestureDismissal: true,
                                panGestureDismissal: false)
        

        
     
        
        let changePw = DefaultButton(title: "发送请求", dismissOnTap: false) {
            // link to constant
            let request = RequestConsulentReq(
                parentID:UserService.shared.localUserId!,
                numTasksReplay:0,
                parentName:UserService.shared.localUserName!,
                parentEmail:UserService.shared.localUserEmail!,
                status:2,
                consultantID:self.consultantList[indexPath.row].id!,
                numTasksHandle:1
                
            )
            let view = MessageView.viewFromNib(layout: .cardView)
            view.layoutMarginAdditions = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
            view.button?.isHidden = true
            (view.backgroundView as? CornerRoundingView)?.cornerRadius = 10
            
            UserService.shared.requestConsulent(requestConsulentReq: request)
                .done{ result  in
                    print("requestConsulent:\(result)")
                    view.configureTheme(.success)
                     view.configureContent(title: "成功", body: "请等待顾问通过！", iconText: "")
                     SwiftMessages.show(view: view)
                     popup.dismiss()
                  
                }.catch{error in
                     view.configureTheme(.error)
                      view.configureContent(title: "成功", body: "内部系统错误稍后重试", iconText: "")
                     SwiftMessages.show(view: view)
                    print(error)
                     popup.dismiss()
                    
                    }
            
            
        };
        let buttonOne = CancelButton(title: "关闭") {
            print("You canceled the car dialog.")
        }
        popup.addButtons([changePw,buttonOne])
        
        // Present dialog
        self.present(popup, animated: true, completion: nil)
        
        
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath as IndexPath) as! SubConsultantTableViewCell
    
    
        cell.detail.rating = 5 // FIX LATER
        cell.title.text = "unknow"
        if let username = consultantList[indexPath.row].userName{
             cell.title.text = username
        }
    
        var image = UIImage(named: "consulant.png")
        image = image?.scaleImage(scaleSize:0.5)
        cell.myImageView.image = image
   
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    

    
}

class SubConsultantTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        setup()
        self.selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let myImageView = UIImageView()
    let title = UILabel()
    let detail  = CosmosView()
    let naviButtion = UIButton()
    
    func setup(){
        title.font=UIFont.systemFont(ofSize: 14)
        let rightimage = UIImage(named:"right.png")
        naviButtion.setImage(rightimage, for: UIControl.State.normal)
        self.contentView.addSubview(myImageView)
        self.contentView.addSubview(title)
        self.contentView.addSubview(detail)
        self.contentView.addSubview(naviButtion)
        
        myImageView.translatesAutoresizingMaskIntoConstraints = false
        myImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        myImageView.heightAnchor.constraint(equalToConstant: 30  ).isActive = true
        myImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        myImageView.leftAnchor.constraint(equalTo:contentView.leftAnchor,constant:5).isActive = true
        
        
        title.translatesAutoresizingMaskIntoConstraints = false
        title.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        title.heightAnchor.constraint(equalToConstant: 50  ).isActive = true
        title.widthAnchor.constraint(equalToConstant: 150).isActive = true
        title.leftAnchor.constraint(equalTo:myImageView.rightAnchor ,constant: 10).isActive = true
        
        
        
        naviButtion.translatesAutoresizingMaskIntoConstraints = false
        naviButtion.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        naviButtion.heightAnchor.constraint(equalToConstant: 20  ).isActive = true
        naviButtion.widthAnchor.constraint(equalToConstant: 20).isActive = true
        naviButtion.rightAnchor.constraint(equalTo:contentView.rightAnchor,constant: -30).isActive = true
        
        detail.translatesAutoresizingMaskIntoConstraints = false
        detail.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
//        detail.heightAnchor.constraint(equalToConstant: 50  ).isActive = true
//        detail.widthAnchor.constraint(equalToConstant: 200).isActive = true
        detail.rightAnchor.constraint(equalTo:naviButtion.leftAnchor,constant:-5).isActive = true
        
        
    }
    
    
    
    
}







