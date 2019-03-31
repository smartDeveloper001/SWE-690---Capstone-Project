//
//  ReplayViewController.swift
//  51ALP_IOS
//
//  Created by xiu on 2/12/19.
//  Copyright © 2019 wma. All rights reserved.
//

import UIKit
import Material
import PopupDialog
import SwiftMessages
import SwiftValidators


struct Replay{
    let seq:Int
    let avataImage:String
    let from:String
    let dateStr:String
    let task_title: String
    let taskConent: String
    let isIncoming: Bool
    let isVideoReplay:Bool
    let videoName:String
    let videoPath:String
    
}


extension Date {
    static func dateFromCustomString(customString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-mm-ddTHH:MM:ss"
        return dateFormatter.date(from: customString) ?? Date()
    }
}


class ReplayViewController: UITableViewController {
    let cellIdentifier = "MyCell"
    let videocellIdentifier = "videoCell"
    var taskRes:TaskRes!
    var replays = [Replay]()
    func prepareNavigationItem() {
        self.navigationController?.navigationBar.barStyle = UIBarStyle.blackTranslucent
        navigationItem.titleLabel.text = "回复"
    }
    
    func reloadData(){
        var seq = 1
        TaskService.shared.getTaskByTaskId(taskId:taskRes.id).done{ taskRes in
            print("taskRes:\(taskRes)")
            self.replays.removeAll()
            let taskInfo = Replay(seq:seq,avataImage: "consulant.png", from:UserService.shared.usersMap[taskRes.consultantID]!.userName! ,dateStr:
               String(taskRes.createdAt.prefix(19)).replacingOccurrences(of: "T", with: " "),
                                  task_title:taskRes.taskTitle,taskConent:taskRes.taskContent,isIncoming: true,isVideoReplay:false,videoName:"",videoPath:"")
            self.replays.append(taskInfo)
            seq = seq + 1
            
            if taskRes.replays != nil {
                
                for replay in taskRes.replays!{
                    var from  = ""
                    var avataImage = ""
                    var isIncoming = true;
                    if replay.replayType == 1 {
                        if (UserService.shared.usersMap[replay.userID] != nil && UserService.shared.usersMap[replay.userID]!.userName != nil ){
                            from = UserService.shared.usersMap[replay.userID]!.userName!
                        }else{
                            from = "家长"
                        }
                        
                        isIncoming = false
                        avataImage = "parent.png"
                        
                    }else{
                       
                        
                        if (UserService.shared.usersMap[replay.userID] != nil && UserService.shared.usersMap[replay.userID]!.userName != nil ){
                            from = UserService.shared.usersMap[replay.userID]!.userName!
                        }else{
                            from = "顾问"
                        }
    
                        isIncoming = true
                        avataImage = "consulant.png"
                        
                    }
                    if replay.replayVides.count > 0 {
                        let replay = Replay(seq:seq,avataImage: avataImage, from:from, dateStr:String(taskRes.createdAt.prefix(19)).replacingOccurrences(of: "T", with: " "),task_title:replay.replayTitle,taskConent:replay.replayContent,isIncoming: isIncoming,isVideoReplay:true,videoName:replay.replayVides[0].videoName,videoPath:replay.replayVides[0].videoPath)
                        self.replays.append(replay)
                        seq = seq + 1
                        
                    }else{
                        let replay = Replay(seq:seq,avataImage: avataImage, from:from, dateStr:String(taskRes.createdAt.prefix(19)).replacingOccurrences(of: "T", with: " "),task_title:replay.replayTitle,taskConent:replay.replayContent,isIncoming: isIncoming,isVideoReplay:false,videoName:"",videoPath:"")
                        self.replays.append(replay)
                        seq = seq + 1
                    }
                 
                    seq = seq + 1
                    
                }
                
            }
            self.tableView.reloadData()
            
        }

        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.reloadData()
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareNavigationItem()

        
        self.tableView = UITableView(frame: CGRect.zero, style: .grouped)
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.register(ReplayViewTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        self.tableView.register(ReplayViewVideoCell.self, forCellReuseIdentifier: videocellIdentifier)
//        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let replay = replays[indexPath.row]
        if replay.isVideoReplay {
             return 520
        }
        return 310
    }
    
    override func tableView(_ tableView: UITableView,heightForFooterInSection section: Int) -> CGFloat{
        return 0.01
    }
    
  
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return replays.count
        
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("indexPath::",indexPath)
     
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
    let replay = replays[indexPath.row]
        if replay.isVideoReplay {
            
             let cell = tableView.dequeueReusableCell(withIdentifier: videocellIdentifier, for: indexPath as IndexPath) as! ReplayViewVideoCell
            cell.myTableViewController = self

            cell.taskId = taskRes.id
         
            cell.replay = replay
            
            return cell
            
        }else{
            
             let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath as IndexPath) as! ReplayViewTableViewCell
            
             cell.myTableViewController = self
            cell.taskId = taskRes.id
            cell.replay = replay
            return cell
        }
        
    
    }
    
    func replayByText(cell: UITableViewCell) {
        if let deletionIndexPath = tableView.indexPath(for: cell) {
            
            print(deletionIndexPath.row)
            
            let tp = TextReplayPopup()
            let popup2 = PopupDialog(viewController: tp,
                                     buttonAlignment: .horizontal,
                                     transitionStyle: .bounceDown,
                                     tapGestureDismissal: false,
                                     panGestureDismissal: false)
            
            
            let changePw = DefaultButton(title: "回复", dismissOnTap: false) {
                
                if let title = tp.replayTitleField.text {
                    if title == "" {
                        tp.errorLebel.isHidden = false
                        tp.errorLebel.text = "错误 请输入回复标题"
                        return
                        
                    }else{
                        tp.errorLebel.isHidden = true
                        tp.errorLebel.text = ""
                    }
                    
                }
                
                
                if let content = tp.replayTextView.text {
                    if content == "" {
                        tp.errorLebel.isHidden = false
                        tp.errorLebel.text = "错误 请输入回复内容"
                        return
                        
                    }else{
                        tp.errorLebel.isHidden = true
                        tp.errorLebel.text = ""
                    }
                    
                }
                
                let request = ReplayTaskReq(
                    userID:UserService.shared.localUserId!,
                    replayType:UserService.shared.localUserTypeId!,
                    replayTitle:tp.replayTitleField.text!,
                    replayContent:tp.replayTextView.text,
                    replayVides:[]
                )
                
                let view = MessageView.viewFromNib(layout: .cardView)
                view.layoutMarginAdditions = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
                view.button?.isHidden = true
                (view.backgroundView as? CornerRoundingView)?.cornerRadius = 10
                
                TaskService.shared.replyTask(taskId: self.taskRes.id, replayTaskReq: request).done{
                    taskRes in
                    if taskRes != nil && taskRes.id != nil {
                        
                        view.configureTheme(.success)
                        view.configureContent(title: "成功", body: "回复任务成功！", iconText: "")
                        SwiftMessages.show(view: view)
                        self.reloadData()
                        popup2.dismiss()
                    }else{
                        view.configureTheme(.error)
                        view.configureContent(title: "失败！", body: "稍后重试", iconText: "")
                        SwiftMessages.show(view: view)
                        popup2.dismiss()
                        
                        
                    }
                    
                    } .catch { error in
                        view.configureTheme(.error)
                        view.configureContent(title: "添加任务失败！", body: "网络故障请重试", iconText: "")
                        SwiftMessages.show(view: view)
                        popup2.dismiss()
                        print(error)
                }

                popup2.dismiss()
            };
            
            let buttonOne = CancelButton(title: "关闭") {
                print("You canceled the car dialog.")
            }
            popup2.addButtons([changePw,buttonOne])
            self.present(popup2, animated: true, completion: nil)
            
            
            
        }
    }
    
    
    func replayByVideo(cell: UITableViewCell) {
        if let chooseTaskCell = tableView.indexPath(for: cell) {
            
            let replay = replays[chooseTaskCell.row]
            let stc = VideoReplayViewController()
            stc.taskId = taskRes.id
            self.navigationController?.pushViewController(stc, animated: true)
            
            
            
        }
    }
    

}

