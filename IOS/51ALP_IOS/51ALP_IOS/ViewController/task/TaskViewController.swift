//
//  TaskViewController.swift
//  51ALP_IOS
//
//  Created by xiu on 1/30/19.
//  Copyright © 2019 wma. All rights reserved.
//

import UIKit
import ChameleonFramework
import BadgeSwift
import Material
import SwiftMessages
import SDWebImage
import SnapKit

import PopupDialog
struct TaskViewObj{
    var type:Int // 1 means new parent request  2 means normal task 3 means old parents
    var icon:String?
    var userName:String
    var userId:Int
    var numberOfTask:Int
    
    
}

class TaskViewController: UITableViewController {
    let cellIdentifier = "MyCell"
    convenience init() {
        self.init(nibName: nil, bundle: nil)
        prepareTabBarItem()
    }
    
    
    func refreshTable(){
        
        
//        UserService.shared.getAssociatedUsers(consultantId: UserService.shared.localUserId!).done{
//            userArray in
//            for user in userArray {
//                self.userMap[user.id!] = user
//            }
//
        
            UserService.shared.getParentConsultantByConsultantId(consultantId: UserService.shared.localUserId!).done { requestConsulentResList in
                
                print("requestConsulentResList----->\(requestConsulentResList)")
                
                self.sectionName.removeAll()
                self.cellsData.removeAll()
                var newParents = [TaskViewObj]()
                var inprogressParent = [TaskViewObj]()
                for requestConsulentRes in requestConsulentResList{
                    
                    
                    if requestConsulentRes.status == 2 {
                        newParents.append(TaskViewObj(
                            type: 1,
                            icon:UserService.shared.usersMap[requestConsulentRes.parentID]!.userAvatarPath,
                            userName:UserService.shared.usersMap[requestConsulentRes.parentID]!.userName!,
                            userId:requestConsulentRes.parentID,
                            numberOfTask:1
                        ))
                    }
                    
                    
                    if requestConsulentRes.status == 1 {
                        inprogressParent.append(TaskViewObj(
                            type: 2,
                            icon:UserService.shared.usersMap[requestConsulentRes.parentID]?.userAvatarPath,
                            userName:UserService.shared.usersMap[requestConsulentRes.parentID]!.userName!,
                            userId:requestConsulentRes.parentID,
                            numberOfTask:requestConsulentRes.numTasksHandle
                        ))
                    }
                    
                    
                    
                    
                }
                if newParents.count > 0 {
                    self.sectionName.append("请求的个案家庭")
                    self.cellsData.append(newParents)
                }
                
                if inprogressParent.count > 0 {
                    self.sectionName.append("进行中的个案家庭")
                    self.cellsData.append(inprogressParent)
                }
                
                self.tableView.reloadData()
                
            }
            
            
            
            
            
            
            
    //    }
        
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        prepareTabBarItem()
        refreshTable()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView = UITableView(frame: CGRect.zero, style: .grouped)
        self.tableView.register(TaskTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        
        
        
        
        
        
    }
    func prepareNavigationItem() {
        self.navigationController?.navigationBar.barStyle = UIBarStyle.blackTranslucent
        navigationItem.titleLabel.text = "我的任务"
    }
    
    
    var sectionName = [String]()
    //"请求的个案家庭","进行中的个案家庭","已结束的个案家庭"
    var cellsData = [[TaskViewObj]]()
    
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView{
        let headerView = UIView(frame: CGRect(x:0, y:0, width:tableView.frame.size.width, height:40))
        let label = UILabel()
        label.frame = CGRect.init(x: 20, y: 20, width: headerView.frame.width-10, height: headerView.frame.height-10)
        label.text = sectionName[section]
        label.font=UIFont.systemFont(ofSize: 16)
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
        return sectionName.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellsData[section].count
        
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("indexPath::",indexPath)
        
        
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath as IndexPath) as! TaskTableViewCell
        
        cell.myTableViewController = self
        
        if cellsData[indexPath.section][indexPath.row].icon == nil {
            var image = UIImage(named: "parent")
            image = image!.scaleImage(scaleSize:0.5)
            cell.myImageView.image = image
        }else{
            cell.myImageView.sd_setImage(with: URL(string: ENV.BACKENDURL.rawValue+cellsData[indexPath.section][indexPath.row].icon!), placeholderImage: UIImage(named: "parent"))
            
        }
        
        
        cell.name.text = cellsData[indexPath.section][indexPath.row].userName
        cell.type = cellsData[indexPath.section][indexPath.row].type
        cell.parentId = cellsData[indexPath.section][indexPath.row].userId
        cell.parentEmail = cellsData[indexPath.section][indexPath.row].userName
        
        if cellsData[indexPath.section][indexPath.row].type == 1{
            cell.badge.isHidden = true;
            cell.naviButtion.isHidden = true
            cell.actionButton1.isHidden = true
            cell.actionButton2.setTitle("查看",  for: UIControl.State.normal)
            
            
            
        }
        
        if cellsData[indexPath.section][indexPath.row].type == 2{
            if cellsData[indexPath.section][indexPath.row].numberOfTask == 0 {
                cell.badge.isHidden = true;
            }else{
                cell.badge.text = String(cellsData[indexPath.section][indexPath.row].numberOfTask)
                cell.badge.isHidden = false
            }
            
            cell.naviButtion.isHidden = true
            cell.parentId = cellsData[indexPath.section][indexPath.row].userId
            cell.actionButton1.setTitle("新任务",  for: UIControl.State.normal)
            cell.actionButton2.setTitle("查看",  for: UIControl.State.normal)
            
        }
        
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func handleAction2(cell: UITableViewCell) {
        let cell = cell as! TaskTableViewCell
        
        
        
        if (cell.type == 2){
            UserService.shared.processStatus = 1
            let ptvc = Course4ParentViewController()
            
            ptvc.parentId = cell.parentId
            self.navigationController?.pushViewController(ptvc, animated: true)
        }
        
        
        
        
        if (cell.type == 1){
            
            
            let title = cell.parentEmail+"的请求"
            let message = "请求你成为他的顾问"
            
            
            // Create the dialog
            let requestPop = PopupDialog(title: title, message: message, image: nil)
            
            let view = MessageView.viewFromNib(layout: .cardView)
            view.layoutMarginAdditions = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
            view.button?.isHidden = true
            (view.backgroundView as? CornerRoundingView)?.cornerRadius = 10
            
            // This button will not the dismiss the dialog
            let apparove = DefaultButton(title: "同意", dismissOnTap: false) {
                
                UserService.shared.responseParentRequest(parentId: cell.parentId, statusId: 1).done({ (requestConsulentRes) in
                    
                    guard let status = requestConsulentRes.status , status == 1  else{
                        view.configureTheme(.error)
                        view.configureContent(title: "操作失败！", body: "网络故障请重试", iconText: "")
                        SwiftMessages.show(view: view)
                        requestPop.dismiss()
                        return
                        
                    }
                    
                    view.configureTheme(.success)
                    view.configureContent(title: "操作成功", body: "您现在可以给家长分配任务了", iconText: "")
                    SwiftMessages.show(view: view)
                    requestPop.dismiss()
                    self.refreshTable()
                    self.prepareTabBarItem()
                    
                })
                
            }
            
            let reject = DefaultButton(title: "拒绝", height: 60,dismissOnTap: false) {
                
                UserService.shared.responseParentRequest(parentId: cell.parentId, statusId: 0).done({ (requestConsulentRes) in
                    
                    guard let status = requestConsulentRes.status , status == 0  else{
                        view.configureTheme(.error)
                        view.configureContent(title: "操作失败！", body: "网络故障请重试", iconText: "")
                        SwiftMessages.show(view: view)
                        requestPop.dismiss()
                        
                        return
                        
                    }
                    
                    view.configureTheme(.success)
                    view.configureContent(title: "操作成功", body: "", iconText: "")
                    requestPop.dismiss()
                    self.tableView.reloadData()
                    SwiftMessages.show(view: view)
                    self.refreshTable()
                    
                })
                
                
            }
            
            requestPop.addButtons([apparove, reject])
            
            // Present dialog
            self.present(requestPop, animated: true, completion: nil)
            
        }
        
        
        
        
        
        
    }
    
    
    
    
    func handleAction(cell: UITableViewCell) {
        
        let cell = cell as! TaskTableViewCell
        //  for type 2
        if (cell.type == 2){
            UserService.shared.processStatus = 1
            let cv = CourseViewController()
            cv.parentId = cell.parentId
            self.navigationController?.pushViewController(cv, animated: true)
        }
        

    }
    
    
}



class TaskTableViewCell: UITableViewCell {
    var myTableViewController: TaskViewController?
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        setup()
        self.selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var type :Int!
    var parentId:Int!
    var parentEmail:String!
    let myImageView = UIImageView()
    let name = UILabel()
    let badge = BadgeSwift()
    let naviButtion = RaisedButton()
    
    
    
    let actionButton1: RaisedButton = {
        let button = RaisedButton(type: .system)
        button.pulseColor = .white
        button.titleColor = .white
        button.backgroundColor = Color.blue.base
        button.setTitle("处理任务", for: UIControl.State.normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    let actionButton2: RaisedButton = {
        let button = RaisedButton(type: .system)
        button.pulseColor = .white
        button.titleColor = .white
        button.backgroundColor = Color.blue.base
        button.setTitle("添加新任务", for: UIControl.State.normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    func setup(){
        
        let rightimage = UIImage(named:"right.png")
        naviButtion.setImage(rightimage, for: UIControl.State.normal)
        self.contentView.addSubview(myImageView)
        self.contentView.addSubview(badge)
        self.contentView.addSubview(name)
        self.contentView.addSubview(actionButton1)
        self.contentView.addSubview(actionButton2)
        self.contentView.addSubview(naviButtion)
        
        
        myImageView.layer.cornerRadius = 5.0;
        myImageView.layer.masksToBounds = true;
       
        myImageView.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(self.contentView)
            make.left.equalTo(self.contentView.snp.left).offset(5)
            make.height.equalTo(self.contentView.snp.height).multipliedBy(0.9)
            make.width.equalTo(self.contentView.snp.height)
            
        }
        

        name.font = UIFont.systemFont(ofSize: 14)
        name.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(self.contentView)
            make.left.equalTo(self.myImageView.snp.right).offset(10)
            make.width.equalTo(120)
            
        }

        actionButton1.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(self.contentView)
            make.left.equalTo(self.name.snp.right).offset(30)
            make.width.equalTo(70)
            make.height.equalTo(30)
            
        }
        
        
        
        actionButton2.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(self.contentView)
            make.left.equalTo(self.actionButton1.snp.right).offset(20)
            make.width.equalTo(70)
            make.height.equalTo(30)
            
        }
        badge.textColor = UIColor.white
        badge.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(self.contentView.snp.centerY).offset(-8)
            make.left.equalTo(self.actionButton2.snp.right).offset(-4)
   
            
        }
        
//
//
//        naviButtion.translatesAutoresizingMaskIntoConstraints = false
//        naviButtion.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
//        naviButtion.heightAnchor.constraint(equalToConstant: 20  ).isActive = true
//        naviButtion.widthAnchor.constraint(equalToConstant: 20).isActive = true
//        naviButtion.rightAnchor.constraint(equalTo:contentView.rightAnchor,constant: -30).isActive = true
        
        
        
        actionButton1.addTarget(self, action: #selector(handleAction1(button:)), for: .touchUpInside)
        actionButton2.addTarget(self, action: #selector(handleAction2(button:)), for: .touchUpInside)
    }
    
    @objc
    internal func handleAction1(button: UIButton) {
        myTableViewController?.handleAction(cell: self)
    }
    
    @objc
    internal func handleAction2(button: UIButton) {
        myTableViewController?.handleAction2(cell: self)
    }
    
    
}

extension TaskViewController {
    fileprivate func prepareTabBarItem() {
        let imageName = "task_white.png"
        let image = UIImage(named: imageName)
        tabBarItem.image = image?.scaleImage(scaleSize:0.2)
        let selectedImageName = "taks_black.png"
        let selectedImage = UIImage(named: selectedImageName)
        tabBarItem.selectedImage = selectedImage?.scaleImage(scaleSize:0.2)
        tabBarItem.title = "处理任务"
        
        
        UserService.shared.getParentConsultantByConsultantId(consultantId: UserService.shared.localUserId!).done { (requestConsulentResList) in
            print("there are \(requestConsulentResList.count) parents associated to you")
            var totalTaskNumber = 0;
            for requestConsulentRes in requestConsulentResList {
                if let taskNumber = requestConsulentRes.numTasksHandle{
                    totalTaskNumber = totalTaskNumber + taskNumber
                    
                }
                
            }
            if totalTaskNumber > 0 {
                self.tabBarItem.badgeValue = String(totalTaskNumber)
            }
            
            
        }
        
    }
}

