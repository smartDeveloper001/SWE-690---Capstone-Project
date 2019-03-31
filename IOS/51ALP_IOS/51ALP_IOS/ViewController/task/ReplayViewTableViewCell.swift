//
//  ReplayViewTableViewCell.swift
//  51ALP_IOS
//
//  Created by xiu on 2/13/19.
//  Copyright © 2019 wma. All rights reserved.
//

import UIKit
import PopupDialog
import Material
import SwiftMessages
import BMPlayer
import SnapKit

class ReplayViewTableViewCell: UITableViewCell {
    var myTableViewController: ReplayViewController?
    let myImageView = UIImageView()
    let name = UILabel()
    let naviButtion = UIButton()
    let time = UILabel()
    var taskId:Int!
    let taskName = TextField()
    let feedbackText = UITextView(frame:CGRect(x:0, y:0, width:300, height:200))
    let replay1 = RaisedButton(title: "文字回复")
    let replay2 = RaisedButton(title: "视频回复")
    let close = RaisedButton(title: "通过")
    
    var replay: Replay!{
        didSet {
            
            
            self.contentView.backgroundColor = replay.isIncoming ? .white : UIColor(red: 217/255, green: 215/255, blue: 224/255, alpha: 1.0)
            feedbackText.backgroundColor = replay.isIncoming ? .white :UIColor(red: 217/255, green: 215/255, blue: 224/255, alpha: 1.0)
            
            
            if replay.isIncoming {
                var image = UIImage(named:"incomming.png")
                image = image?.scaleImage(scaleSize:0.05)
                myImageView.image = image
                
            }else{
                var image = UIImage(named:"outcomming.png")
                image = image?.scaleImage(scaleSize:0.05)
                myImageView.image = image
                
                
                
                
            }
            
            name.text = replay.from
            time.text = replay.dateStr
            taskName.text = replay.task_title
            feedbackText.text = replay.taskConent
            
        
            
            self.contentView.addSubview(myImageView)
            self.contentView.addSubview(name)
            self.contentView.addSubview(time)
            self.contentView.addSubview(taskName)
            contentView.addSubview(feedbackText)
            contentView.addSubview(replay1)
            contentView.addSubview(replay2)
            contentView.addSubview(close)
            
            
            myImageView.snp.makeConstraints { (make) in
                make.top.equalTo(self.contentView.snp.top).offset(10)
                make.left.equalTo(self.contentView.snp.left).offset(10)
                
            }
            
            name.font=UIFont.systemFont(ofSize: 16)
            
            
            name.snp.makeConstraints { (make) in
                make.top.equalTo(self.contentView.snp.top).offset(20)
                make.left.equalTo(self.myImageView.snp.right).offset(10)
                make.height.equalTo(20)
                
            }
            
            
            time.font=UIFont.systemFont(ofSize: 14)
            
            time.snp.makeConstraints { (make) in
                make.top.equalTo(self.name.snp.top)
                make.left.equalTo(self.name.snp.right).offset(5)
                make.width.equalTo(200)
                make.height.equalTo(20)
                
            }
            
            taskName.isEnabled = false
            taskName.font = UIFont.systemFont(ofSize: 15)
            taskName.isClearIconButtonEnabled = true
            taskName.isPlaceholderUppercasedWhenEditing = true
            taskName.placeholderAnimation = .hidden
            taskName.dividerNormalColor = .gray
            
            
            taskName.snp.makeConstraints { (make) in
                make.top.equalTo(self.myImageView.snp.bottom).offset(10)
                make.left.equalTo(self.contentView.snp.left).offset(10)
                make.width.equalTo(200)
                make.height.equalTo(20)
                
            }
            
            feedbackText.isEditable = false
            feedbackText.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
            feedbackText.layer.borderWidth = 1.0
            feedbackText.layer.cornerRadius = 5
            
            
            
            feedbackText.snp.makeConstraints { (make) in
                make.top.equalTo(self.taskName.snp.bottom).offset(10)
                
                make.centerX.equalTo(self.contentView.snp.centerX)
                make.width.equalTo(UIScreen.main.bounds.width-50)
                make.height.equalTo(180)
            }
            
            
            replay1.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            replay1.pulseColor = .white
            replay1.titleColor = .white
            replay1.backgroundColor = Color.blue.base
            
            
            replay1.snp.makeConstraints { (make) in
                make.top.equalTo(self.feedbackText.snp.bottom).offset(10)
                make.left.equalTo(self.feedbackText.snp.left).offset(5)
                make.width.equalTo(80)
                make.height.equalTo(20)
            }
            
            
            replay2.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            
            replay2.pulseColor = .white
            replay2.titleColor = .white
            replay2.backgroundColor = Color.blue.base
            
            
            
            replay2.snp.makeConstraints { (make) in
                make.top.equalTo(self.feedbackText.snp.bottom).offset(10)
                make.left.equalTo(self.replay1.snp.right).offset(5)
                make.width.equalTo(80)
                make.height.equalTo(20)
            }
            
            
            
            close.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            close.pulseColor = .white
            close.titleColor = .white
            close.backgroundColor = Color.blue.base
            
            
            
            
            close.snp.makeConstraints { (make) in
                make.top.equalTo(self.feedbackText.snp.bottom).offset(10)
                make.left.equalTo(self.replay2.snp.right).offset(5)
                make.width.equalTo(80)
                make.height.equalTo(20)
                
            }
            
            
            
            replay1.addTarget(self, action: #selector(replayByText(button:)), for: .touchUpInside)
            replay2.addTarget(self, action: #selector(replayByVideo(button:)), for: .touchUpInside)
            close.addTarget(self, action: #selector(closeTask(button:)), for: .touchUpInside)
            
            if UserService.shared.localUserTypeId == 1 {
                close.isHidden = true
            }
            
            
            
            
            
            
        }
        
    }
    
    
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 15
        layer.masksToBounds = false
    }
    
    override open var frame: CGRect {
        get {
            return super.frame
        }
        set (newFrame) {
            var frame =  newFrame
            frame.origin.y += 10
            frame.origin.x += 10
            frame.size.height -= 15
            frame.size.width -= 2 * 10
            super.frame = frame
        }
    }
    
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        backgroundColor = .clear
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    internal func replayByText(button: UIButton) {
        myTableViewController?.replayByText(cell: self)
    }
    
    @objc
    internal func closeTask(button: UIButton) {
        
        
        let title = "你确定要通过该目标？"
        let message = ""
        
        
        // Create the dialog
        let popup = PopupDialog(title: title, message: message, image: nil)
        
        // Create buttons
        let sure = CancelButton(title: "确定",dismissOnTap: false) {
            
            
            let view = MessageView.viewFromNib(layout: .cardView)
            view.layoutMarginAdditions = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
            view.button?.isHidden = true
            (view.backgroundView as? CornerRoundingView)?.cornerRadius = 10
            
            
            TaskService.shared.passTask(taskId: self.taskId).done{ taskRes in
                
                if taskRes != nil && taskRes.id != nil {
                    
                    view.configureTheme(.success)
                    view.configureContent(title: "成功", body: "通过任务操作成功！", iconText: "")
                    SwiftMessages.show(view: view)
                    self.myTableViewController!.navigationController?.popToRootViewController(animated: true)
                    popup.dismiss()
                }else{
                    view.configureTheme(.error)
                    view.configureContent(title: "失败！", body: "稍后重试", iconText: "")
                    SwiftMessages.show(view: view)
                    popup.dismiss()
                    
                    
                }
                
                }.catch { error in
                    view.configureTheme(.error)
                    view.configureContent(title: "添加任务失败！", body: "网络故障请重试", iconText: "")
                    SwiftMessages.show(view: view)
                    popup.dismiss()
                    print(error)
            }
            
            
            
            
        }
        
        
        let cancel = DefaultButton(title: "取消", dismissOnTap: true) {
            print("cancel request")
        }
        
        
        
        popup.addButtons([sure, cancel])
        
        
        self.myTableViewController!.present(popup, animated: true, completion: nil)
        
        
        
    }
    
    
    @objc
    internal func replayByVideo(button: UIButton) {
        myTableViewController?.replayByVideo(cell: self)
    }
    
    
    
    
    
    
    
    
    
    
    
}
