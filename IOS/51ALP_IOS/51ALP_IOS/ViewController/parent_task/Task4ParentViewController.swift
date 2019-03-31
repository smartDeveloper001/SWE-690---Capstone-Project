//
//  ParentTaskViewController.swift
//  51ALP_IOS
//
//  Created by xiu on 2/17/19.
//  Copyright © 2019 wma. All rights reserved.
//

import UIKit
import ChameleonFramework
import BadgeSwift
import Material
import PopupDialog


class Task4ParentViewController: UITableViewController {
    
    var parentId:Int!
    let cellIdentifier = "MyCell"
  
    
    
    var sectionName = ""
    var cellsData  = [TaskRes]()
    var taskSummaryInfo:TaskSummaryInfo
    
    
    required override init(style: UITableView.Style){
        self.taskSummaryInfo = TaskSummaryInfo()
        super.init(style:style)
    }
    
    required init(coder aDecoder: NSCoder) {
        // Or call super implementation
        fatalError("NSCoding not supported")
    }
    
    
    
    
    convenience init(taskSummaryInfo:TaskSummaryInfo,style: UITableView.Style){
        self.init(style: style)
        self.taskSummaryInfo = taskSummaryInfo
        self.cellsData = taskSummaryInfo.breakToTask[taskSummaryInfo.selectedBreakId]!
        self.sectionName = taskSummaryInfo.selectedBreakName
        
        
        
    }
    
    
//    override func viewWillAppear(_ animated: Bool) {
//        if UserService.shared.localUserTypeId == 1 {
//            parentId = UserService.shared.localUserId!
//
//        }
//        super.viewWillAppear(animated)
//
//        TaskService.shared.getTasks(parentId:parentId).done{ taskResList  in
//           self.cellsData.removeAll()
//            for taskRes in taskResList{
//                if taskRes.taskStatus != 0 {
//                    self.cellsData.append(taskRes)
//                }
//
//            }
//
//            self.tableView.reloadData()
//
//        }
//
//    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareNavigationItem()
        self.tableView = UITableView(frame: CGRect.zero, style: .grouped)
        self.tableView.register(ParentTaskTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    }
    
    
    
    
    func prepareNavigationItem() {
        self.navigationController?.navigationBar.barStyle = UIBarStyle.blackTranslucent
        navigationItem.titleLabel.text = "任务"
    }
    


    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView{
        let headerView = UIView(frame: CGRect(x:0, y:0, width:tableView.frame.size.width, height:40))
        let label = UILabel()
        label.frame = CGRect.init(x: 20, y: 20, width: headerView.frame.width-10, height: headerView.frame.height-10)
        label.text = sectionName
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
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellsData.count
        
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("indexPath::",indexPath)
        
        
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath as IndexPath) as! ParentTaskTableViewCell
        cell.myTableViewController = self
        print(indexPath)
        var image = UIImage(named: "parent_task.png")
        image = image?.scaleImage(scaleSize:0.5)
        cell.myImageView.image = image
        cell.name.text = cellsData[indexPath.row].taskTitle
        cell.taskRes = cellsData[indexPath.row]
        let badgeValue = self.taskSummaryInfo.taskToBadge[cellsData[indexPath.row].id]!
        if badgeValue > 0 {
            cell.badge.text = String(badgeValue)
        }else{
            
             cell.badge.isHidden = true
        }
        cell.myTableViewController = self
        

        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
    func handleDetail(cell: ParentTaskTableViewCell) {
        let cdpop = TaskDetailPopup()
  
        cdpop.taskRes = cell.taskRes
       
        let popup = PopupDialog(viewController: cdpop,
                                buttonAlignment: .horizontal,
                                transitionStyle: .bounceDown,
                                tapGestureDismissal: true,
                                panGestureDismissal: false)
        
        let buttonOne = CancelButton(title: "关闭") {
            
        }
        popup.addButtons([buttonOne])
        self.present(popup, animated: true, completion: nil)
        
        
    }
    
    
    
    func replayTask(cell: UITableViewCell) {

        
        let vc = ReplayViewController()
        let mycell = cell as! ParentTaskTableViewCell
        vc.taskRes = mycell.taskRes
        self.navigationController?.pushViewController(vc, animated: false)
        print("done")
        
    }
    
    
    
    
    func addewTask(cell: UITableViewCell) {
        if let deletionIndexPath = tableView.indexPath(for: cell) {
            
            print(deletionIndexPath.row)
            //            items.removeAtIndex(deletionIndexPath.row)
            //            tableView.deleteRowsAtIndexPaths([deletionIndexPath], withRowAnimation: .Automatic)
            
            let vc = SelectCoursesViewController()
            self.navigationController?.pushViewController(vc, animated: true)
            print("done")
        }
    }
    
    
}



class ParentTaskTableViewCell: UITableViewCell {
    var myTableViewController: Task4ParentViewController?
    var questionView = UIImageView()
    var taskRes:TaskRes?
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        setup()
        self.selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let myImageView = UIImageView()
    let name = UILabel()
    let badge = BadgeSwift()
    let naviButtion = UIButton()
    
    
    let actionButton1: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("处理任务", for: UIControl.State.normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
//    let actionButton2: UIButton = {
//        let button = UIButton(type: .system)
//        button.setTitle("查看任务", for: UIControl.State.normal)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
    
    func setup(){
        
        let rightimage = UIImage(named:"right.png")
        naviButtion.setImage(rightimage, for: UIControl.State.normal)
        self.contentView.addSubview(myImageView)
        self.contentView.addSubview(badge)
        self.contentView.addSubview(name)
        self.contentView.addSubview(actionButton1)
//        self.contentView.addSubview(actionButton2)
        self.contentView.addSubview(naviButtion)
        
        myImageView.translatesAutoresizingMaskIntoConstraints = false
        myImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        myImageView.heightAnchor.constraint(equalToConstant: 30  ).isActive = true
        myImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        myImageView.leftAnchor.constraint(equalTo:contentView.leftAnchor,constant:5).isActive = true
        
        name.font=UIFont.systemFont(ofSize: 14)
        name.translatesAutoresizingMaskIntoConstraints = false
        name.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        name.widthAnchor.constraint(equalToConstant: 100).isActive = true
        name.leftAnchor.constraint(equalTo:myImageView.rightAnchor ,constant: 10).isActive = true
        
        let question = UIImage(named:"questions.png")
        questionView.image = question
        self.contentView.addSubview(questionView)
        questionView.translatesAutoresizingMaskIntoConstraints = false
        questionView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        questionView.heightAnchor.constraint(equalToConstant: 30  ).isActive = true
        questionView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        questionView.leftAnchor.constraint(equalTo:name.rightAnchor,constant:5).isActive = true
        
        
        naviButtion.translatesAutoresizingMaskIntoConstraints = false
        naviButtion.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        naviButtion.heightAnchor.constraint(equalToConstant: 20  ).isActive = true
        naviButtion.widthAnchor.constraint(equalToConstant: 20).isActive = true
        naviButtion.rightAnchor.constraint(equalTo:contentView.rightAnchor,constant: -30).isActive = true
        
        
        
//        
//        actionButton2.translatesAutoresizingMaskIntoConstraints = false
//        actionButton2.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
//        actionButton2.heightAnchor.constraint(equalToConstant: 20  ).isActive = true
//        actionButton2.widthAnchor.constraint(equalToConstant: 100).isActive = true
//        actionButton2.rightAnchor.constraint(equalTo:contentView.rightAnchor,constant: -160).isActive = true
        
        
        
        actionButton1.translatesAutoresizingMaskIntoConstraints = false
        actionButton1.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        actionButton1.heightAnchor.constraint(equalToConstant: 20  ).isActive = true
        actionButton1.widthAnchor.constraint(equalToConstant: 70).isActive = true
        actionButton1.rightAnchor.constraint(equalTo:contentView.rightAnchor,constant: -25).isActive = true
        
        badge.textColor = UIColor.white
        badge.translatesAutoresizingMaskIntoConstraints = false
        badge.centerYAnchor.constraint(equalTo: contentView.centerYAnchor,constant: -5).isActive = true
        badge.leftAnchor.constraint(equalTo:actionButton1.rightAnchor,constant: -5).isActive = true
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleDetail))
        questionView.addGestureRecognizer(tap)
        questionView.isUserInteractionEnabled = true
        
//
//        let tap2 = UITapGestureRecognizer(target: self, action: #selector(handleNext))
//        naviButtion.addGestureRecognizer(tap2)
//        naviButtion.isUserInteractionEnabled = true
        
        
        actionButton1.addTarget(self, action: #selector(handleAction1(button:)), for: .touchUpInside)
     //   actionButton2.addTarget(self, action: #selector(handleAction2(button:)), for: .touchUpInside)
    }
    
    @objc
    internal func handleAction1(button: UIButton) {
        myTableViewController?.replayTask(cell: self)
    }
    
    @objc
    internal func handleAction2(button: UIButton) {
        myTableViewController?.addewTask(cell: self)
    }
    
    @objc
    internal func handleDetail(button: UIButton) {
        myTableViewController?.handleDetail(cell: self)
    }
    
    
}
