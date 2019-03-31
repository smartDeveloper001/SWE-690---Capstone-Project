//
//  VideoReplayViewController.swift
//  51ALP_IOS
//
//  Created by xiu on 2/16/19.
//  Copyright © 2019 wma. All rights reserved.
//

import UIKit
import StepIndicator
import Material
import BMPlayer
import AVKit
import AVFoundation
import SnapKit

import PopupDialog
import SwiftMessages
import AVKit
import Alamofire
import JGProgressHUD


class VideoReplayViewController: UIViewController ,BackValueProtocol,UIScrollViewDelegate {
    
    let step1 = UIView()
    let step2 = UIView()
    let videoTextReplay = UITextView()
    var player:BMPlayer?
    var takeVidePath = ""
    let containerView = UIView()
    var videoName  = ""
    var videoPath = ""
    var taskId:Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareNavigationItem()
        self.hideKeyboardWhenTappedAround()
        
        self.view.backgroundColor = UIColor(white: 0.95, alpha: 1)
        
        let screensize: CGRect = UIScreen.main.bounds
        let screenWidth = screensize.width
        let scrollView = UIScrollView()
        let containerView = UIView()
        
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        scrollView.isScrollEnabled = true
        scrollView.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(view.snp.centerX)
            make.top.bottom.equalTo(view)
            make.width.equalTo(screenWidth)
        }
        
        
        containerView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(scrollView)
            make.width.equalTo(screenWidth-20)
        }
        
        //step1.backgroundColor =  UIColor.red
        step1.layer.cornerRadius = 12
        step1.backgroundColor = UIColor.white
        containerView.addSubview(step1)
        
        
        
        step1.snp.makeConstraints({ (make) -> Void in
            make.top.equalTo(containerView)
            make.width.equalTo(screenWidth)
            make.height.equalTo(350)
            make.top.equalTo(containerView).offset(20)
        })
        
        
        
        let step1Label = UILabel()
        step1Label.font = UIFont.systemFont(ofSize: 15)
        
        step1Label.text = "第一步：拍摄或者选择已拍摄好的视频"
        let takekVideo = RaisedButton(title: "拍摄视频")
        let selectVideo = RaisedButton(title: "选择视频")
        
        step1.addSubview(step1Label)
        
        step1Label.snp.makeConstraints({ (make) -> Void in
            make.width.equalTo(screenWidth)
            make.height.equalTo(20)
            make.top.equalTo(step1.snp.top).offset(20)
            make.left.equalTo(view.snp.left).offset(20)
        })
        
        takekVideo.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        takekVideo.pulseColor = .white
        takekVideo.titleColor = .white
        takekVideo.backgroundColor = Color.blue.base
        step1.addSubview(takekVideo)
        
        takekVideo.snp.makeConstraints({ (make) -> Void in
            make.width.equalTo(screenWidth/3)
            make.height.equalTo(30)
            make.top.equalTo(step1Label.snp.bottom).offset(20)
            make.left.equalTo(view.snp.left).offset(20)
        })
        
        selectVideo.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        selectVideo.pulseColor = .white
        selectVideo.titleColor = .white
        selectVideo.backgroundColor = Color.blue.base
        step1.addSubview(selectVideo)
        
        selectVideo.snp.makeConstraints({ (make) -> Void in
            make.width.equalTo(screenWidth/3)
            make.height.equalTo(30)
            make.top.equalTo(step1Label.snp.bottom).offset(20)
            make.left.equalTo(takekVideo.snp.right).offset(20)
        })
        
        
        takekVideo.addTarget(self, action: #selector(takeVideoAction(button:)), for: .touchUpInside)
        selectVideo.addTarget(self, action: #selector(selectVideoAction(button:)), for: .touchUpInside)
        
        var controller: BMPlayerControlView? = nil
        controller = BMPlayerCustomControlView()
        BMPlayerConf.shouldAutoPlay = false
        player = BMPlayer(customControlView: controller)
        player!.pause()
        
        step1.addSubview(player!)
        
        player!.snp.makeConstraints({ (make) -> Void in
            make.width.equalTo(UIScreen.main.bounds.width-60)
            make.height.equalTo(((UIScreen.main.bounds.width-60)*9.0)/16.0)
            make.top.equalTo(selectVideo.snp.bottom).offset(20)
            make.left.equalTo(view.snp.left).offset(20)
        })
        
        
        
        containerView.addSubview(step2)
        
        step2.layer.cornerRadius = 12
        step2.backgroundColor = UIColor.white
        
        step2.snp.makeConstraints({ (make) -> Void in
            make.width.equalTo(screenWidth)
            make.height.equalTo(400)
            make.top.equalTo(step1.snp.bottom).offset(20)
        })
        
        
        //
        let step2Label = UILabel()
        step1Label.font = UIFont.systemFont(ofSize: 15)
        
        step2Label.text = "第二步：视频分析："
        
        step2.addSubview(step2Label)
        
        
        step2Label.snp.makeConstraints({ (make) -> Void in
            make.width.equalTo(screenWidth)
            make.height.equalTo(20)
            make.top.equalTo(step2.snp.top).offset(10)
            make.left.equalTo(view.snp.left).offset(20)
        })
        
        
   
        videoTextReplay.isEditable = true
        videoTextReplay.textContainerInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        videoTextReplay.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        videoTextReplay.layer.borderWidth = 1.0
        videoTextReplay.layer.cornerRadius = 5
        videoTextReplay.returnKeyType = UIReturnKeyType.done
        
        step2.addSubview(videoTextReplay)
        
        
        videoTextReplay.snp.makeConstraints({ (make) -> Void in
            make.width.equalTo(screenWidth)
            make.height.equalTo(200)
            make.top.equalTo(step2Label.snp.bottom).offset(20)
        })
        
        
        
        let submitVideoReplay = RaisedButton(title: "提交")
        let cancelVideoReplsy = RaisedButton(title: "取消")
        
        
        submitVideoReplay.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        submitVideoReplay.pulseColor = .white
        submitVideoReplay.titleColor = .white
        submitVideoReplay.backgroundColor = Color.blue.base
        step2.addSubview(submitVideoReplay)
        
        
        cancelVideoReplsy.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        cancelVideoReplsy.pulseColor = .white
        cancelVideoReplsy.titleColor = .white
        cancelVideoReplsy.backgroundColor = Color.blue.base
        step2.addSubview(cancelVideoReplsy)
        
        submitVideoReplay.snp.makeConstraints({ (make) -> Void in
            make.width.equalTo(screenWidth/3)
            make.top.equalTo(videoTextReplay.snp.bottom).offset(20)
            make.height.equalTo(30)
            make.left.equalTo(view.snp.left).offset(20)
        })
        
        
        cancelVideoReplsy.snp.makeConstraints({ (make) -> Void in
            make.top.equalTo(videoTextReplay.snp.bottom).offset(20)
            make.width.equalTo(screenWidth/3)
            make.height.equalTo(30)
            make.left.equalTo(submitVideoReplay.snp.right).offset(20)
        })
        
        
        
        
        
        containerView.snp.makeConstraints({ (make) -> Void in
            
            make.bottom.equalTo(step2)
            
        })
        
        
        
        
        
        submitVideoReplay.addTarget(self, action: #selector(submitVideoReplayAction(button:)), for: .touchUpInside)
        cancelVideoReplsy.addTarget(self, action: #selector(cancelVideoAction(button:)), for: .touchUpInside)
        
        player?.isHidden = true
        step2.isHidden = true
        
        
        let keyboardToolBar = UIToolbar()
        keyboardToolBar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem:
            UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem:
            UIBarButtonItem.SystemItem.done, target: self, action: #selector(self.doneButtonAction) )
        keyboardToolBar.setItems([flexibleSpace, doneButton], animated: true)
        videoTextReplay.inputAccessoryView = keyboardToolBar
        
        
        
        
        
    }
    
    @objc func doneButtonAction()
    {
        self.view.endEditing(true)
    }
    
    
    
    
    
    @objc
    internal func submitVideoReplayAction(button: UIButton) {

        
        // upload video than submit replay
        
        let view = MessageView.viewFromNib(layout: .cardView)
        view.layoutMarginAdditions = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        view.button?.isHidden = true
        (view.backgroundView as? CornerRoundingView)?.cornerRadius = 10
        
        
        if self.videoTextReplay.text == nil || self.videoTextReplay.text == "" {
            view.configureTheme(.error)
            view.configureContent(title: "错误", body: "视频分析不能为空", iconText: "")
            SwiftMessages.show(view: view)
            return
            
        }
        
        
        
        
        if self.videoPath == "" || self.videoName == "" {
            
            view.configureTheme(.error)
            view.configureContent(title: "错误", body: "视频文件错误　稍后重试", iconText: "")
            SwiftMessages.show(view: view)
            return
            
        }else{
            
            let hud = JGProgressHUD(style: .dark)
            hud.textLabel.text = "上传中..."
            hud.detailTextLabel.text = "0% 完成"
            hud.indicatorView = JGProgressHUDPieIndicatorView()
            hud.vibrancyEnabled = true
            hud.show(in: self.view)
            
            
            let mp4PathURL = URL.init(fileURLWithPath: videoPath)
            
        
            let url = ENV.BACKENDURL.rawValue+"/api/upload"
            
            let token = UserService.shared.localUserToken!
            
            let headers: HTTPHeaders = [
                "token": token
            ]
            
            let request = try! URLRequest(url: url, method: .post, headers: headers)
            
            Alamofire.upload(
                multipartFormData: { multipartFormData in
                    multipartFormData.append(mp4PathURL, withName: "file", fileName: self.videoName, mimeType: "video/mp4")
            },with: request,encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    
                    upload.responseData { response in
                        
                        guard let result = response.result.value else { return }
                        print("json:\(result)")
                        do {
                            let decoder = JSONDecoder()
                            let uploadRes = try decoder.decode(UploadRes.self, from: result)
                            print("uploadRes:\(uploadRes)")
                            hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                            hud.detailTextLabel.text = nil
                            hud.textLabel.text = "上传成功"
                            
                            hud.dismiss(afterDelay: 1.0)
                            
                            // submit replay with video infromation
                            
                            // validation
                            
                            

                            
                            
                            let replayVideo = ReplayVideObj(videoName:self.videoName,videoPath:uploadRes.message)
                            var replayVides = [ReplayVideObj]()
                            replayVides.append(replayVideo)
                            
                    
                            let request = ReplayTaskReq(
                                userID:UserService.shared.localUserId!,
                                replayType:UserService.shared.localUserTypeId!,
                                replayTitle:"视频回复",
                                replayContent: self.videoTextReplay.text,
                                replayVides:replayVides
                            )
                            
                    
                            
                            TaskService.shared.replyTask(taskId: self.taskId!, replayTaskReq: request).done{
                                taskRes in
                                if taskRes != nil && taskRes.id != nil {
                                    
                                    view.configureTheme(.success)
                                    view.configureContent(title: "成功", body: "视频回复任务成功！", iconText: "")
                                    SwiftMessages.show(view: view)
                                    self.navigationController?.popViewController(animated: false)
                                    
                                    
                                }else{
                                    view.configureTheme(.error)
                                    view.configureContent(title: "视频回复失败！", body: "稍后重试", iconText: "")
                                    SwiftMessages.show(view: view)
                                   
                                    
                                    
                                }
                                
                                } .catch { error in
                                    view.configureTheme(.error)
                                    view.configureContent(title: "视频回复失败！", body: "网络故障请重试", iconText: "")
                                    SwiftMessages.show(view: view)
                                 
                                    
                            }
                            
      
                        }catch let error {
                            print("error:\(error)")
                            
                        }
                        
                    }
                    
                    upload.uploadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
                        print("---> upload process pecent: \(progress.fractionCompleted)")
                        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(400)) {
                            hud.progress = Float(progress.fractionCompleted)
                            let percent = String(Int(progress.fractionCompleted*100))
                            hud.detailTextLabel.text = percent+" % 完成"
                        }
                        
                        
                    }
                    
                case .failure(let encodingError):
                    print(encodingError)
                    
                }
            })
            
  
            
        }
        
        
        
        
        
        
        
      //  navigationController?.popViewController(animated: true)
    }
    
    
    @objc
    internal func cancelVideoAction(button: UIButton) {
        print("concel it ")
        navigationController?.popViewController(animated: true)
    }
    
    
    
    @objc
    internal func takeVideoAction(button: UIButton) {
        let vc = IWVideoRecordingController()
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc
    internal func selectVideoAction(button: UIButton) {
        let myvideo = VideoViewController()
        myvideo.delegate = self
        // self.present(myvideo, animated: true, completion: nil)
        self.navigationController?.pushViewController(myvideo, animated: false)
    }
    
    func backValue(videoName: String, videoPath: String){
        
        self.takeVidePath = videoPath
        print(takeVidePath)
        let videoInfoArray = videoPath.split(separator: "/")
        var fileName = String((videoInfoArray.last)!)
        self.videoName = fileName
        self.videoPath = videoPath
        if let url: URL = URL(fileURLWithPath: takeVidePath) {
            
            let asset = BMPlayerResource(name: fileName,
                                         definitions: [BMPlayerResourceDefinition(url: url, definition: "")],
                                         cover: nil,
                                         subtitles: nil)
            player!.setVideo(resource: asset)
            player?.isHidden = false
            step2.isHidden = false
            
    
            
        } else {
            print("error ")
        }
        
        
        
        
        
        
        
    }
    
    
    
    
    func prepareNavigationItem() {
        self.navigationController?.navigationBar.barStyle = UIBarStyle.blackTranslucent
        navigationItem.titleLabel.text = "视频回复"
    }
    
    
    
 
    
}


extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
