//
//  VideoCell.swift
//  51ALP_IOS
//
//  Created by xiu on 3/16/19.
//  Copyright © 2019 wma. All rights reserved.
//

import UIKit
import PopupDialog
import Material
import SwiftMessages
import SnapKit
import AVKit
import Alamofire
import JGProgressHUD

class VideoCell: UITableViewCell {
    var myTableViewController: VideoViewController?
    var videoImageView :UIImageView?
    var videoNameLabel = UILabel()
    var videoPath:String!
    var playButton = RaisedButton()
    let deleteButton = RaisedButton()
    let chooseButton = RaisedButton()
    let upload = RaisedButton()

    
    @objc
    internal  func tapDetected() {
        let player = AVPlayer(url: URL(fileURLWithPath: videoPath))
        let playerController = AVPlayerViewController()
        playerController.player = player
        self.myTableViewController?.present(playerController, animated: true, completion: nil)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
       // backgroundColor = .clear

        videoImageView  =  UIImageView()
        
 
        
        
        self.contentView.addSubview(videoImageView!)
        videoImageView!.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(contentView.snp.top).offset(10)
            make.left.equalTo(contentView.snp.left).offset(10)
            make.width.equalTo(160)
            make.height.equalTo(120)
            
            
        }
        videoImageView?.isUserInteractionEnabled = true
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(tapDetected))
        videoImageView?.isUserInteractionEnabled = true
        videoImageView?.addGestureRecognizer(singleTap)
        
        
        self.contentView.addSubview(videoNameLabel)
        videoNameLabel.font=UIFont.systemFont(ofSize: 15)
        videoNameLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(contentView).offset(5)
            make.left.equalTo(videoImageView!.snp.right).offset(10)
            make.width.equalTo(200)
            make.height.equalTo(25)
           
            
            
        }

        
        
        self.contentView.addSubview(playButton)
        playButton.pulseColor = .white
        playButton.titleColor = .white
        playButton.backgroundColor = Color.blue.base
        playButton.setTitle("播放", for: UIControl.State.normal)
        playButton.translatesAutoresizingMaskIntoConstraints = false
        
        playButton.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(videoNameLabel.snp.bottom).offset(10)
            make.left.equalTo(videoImageView!.snp.right).offset(30)
            make.width.equalTo(60)
            make.height.equalTo(30)
            
            
            
        }
        
        
        self.contentView.addSubview(deleteButton)
        deleteButton.pulseColor = .white
        deleteButton.titleColor = .white
        deleteButton.backgroundColor = Color.blue.base
        deleteButton.setTitle("删除", for: UIControl.State.normal)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        
        deleteButton.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(videoNameLabel.snp.bottom).offset(10)
            make.left.equalTo(playButton.snp.right).offset(30)
            make.width.equalTo(60)
            make.height.equalTo(30)
            
            
            
        }
    
        self.contentView.addSubview(chooseButton)
        chooseButton.pulseColor = .white
        chooseButton.titleColor = .white
        chooseButton.backgroundColor = Color.blue.base
        chooseButton.setTitle("选择", for: UIControl.State.normal)
        chooseButton.translatesAutoresizingMaskIntoConstraints = false

        chooseButton.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(playButton.snp.bottom).offset(10)
            make.left.equalTo(videoImageView!.snp.right).offset(30)
            make.width.equalTo(60)
            make.height.equalTo(30)



        }
        
        
//        self.contentView.addSubview(upload)
//        upload.pulseColor = .white
//        upload.titleColor = .white
//        upload.backgroundColor = Color.blue.base
//        upload.setTitle("上传", for: UIControl.State.normal)
//        upload.translatesAutoresizingMaskIntoConstraints = false
//        
//        upload.snp.makeConstraints { (make) -> Void in
//            make.top.equalTo(playButton.snp.bottom).offset(10)
//            make.left.equalTo(chooseButton.snp.right).offset(30)
//            make.width.equalTo(60)
//            make.height.equalTo(30)
//            
//            
//            
//        }
        
        
        
        playButton.addTarget(self, action: #selector(play(button:)), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(delete(button:)), for: .touchUpInside)
        chooseButton.addTarget(self, action: #selector(choose(button:)), for: .touchUpInside)
        upload.addTarget(self, action: #selector(upload(button:)), for: .touchUpInside)
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    internal func play(button: UIButton) {
        
        let player = AVPlayer(url: URL(fileURLWithPath: videoPath))
        let playerController = AVPlayerViewController()
        playerController.player = player
        self.myTableViewController?.present(playerController, animated: true, completion: nil)
     
    }
    
    @objc
    internal func delete(button: UIButton) {
        
        
        let title = "你确定要删除该视频？"
        let message = ""
        
        
        // Create the dialog
        let popup = PopupDialog(title: title, message: message, image: nil)
        
        // Create buttons
        let sure = CancelButton(title: "确定",dismissOnTap: false) {
            
            
            let view = MessageView.viewFromNib(layout: .cardView)
            view.layoutMarginAdditions = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
            view.button?.isHidden = true
            (view.backgroundView as? CornerRoundingView)?.cornerRadius = 10
            
        
            do{
                try FileManager.default.removeItem(atPath: self.videoPath)
            }catch{
               print("文件夹删除失败")
        
            }
            print("文件夹删除成功")
            self.myTableViewController!.reloadVideoFiles()
            popup.dismiss()
            
       
            
        }
        
        // This button will not the dismiss the dialog
        let cancel = DefaultButton(title: "取消", dismissOnTap: true) {
            print("cancel request")
        }
        

        popup.addButtons([sure, cancel])
        
        // Present dialog
        self.myTableViewController!.present(popup, animated: true, completion: nil)
        
        
     
        
        
    }
    
    
    @objc
    internal func choose(button: UIButton) {
        //let pvc = PlayVideoViewController()
       // pvc.takeVidePath = videoPath
        //self.myTableViewController?.navigationController?.pushViewController(pvc, animated: false)
       // self.myTableViewController?.navigationController?.present(pvc, animated: false)
        self.myTableViewController?.delegate?.backValue(videoName: videoNameLabel.text!, videoPath: videoPath)
        print("choose")
        self.myTableViewController?.navigationController?.popViewController(animated: true)
        
    }
    
    
    @objc
    internal func upload(button: UIButton) {
        print("upload")
       
//        CommonService.shared.upload(mp4Path: videoPath).done{ ok in
//            print(ok)
//        }
        
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "上传中..."
        hud.detailTextLabel.text = "0% 完成"
        hud.indicatorView = JGProgressHUDPieIndicatorView()
        hud.vibrancyEnabled = true
        hud.show(in: self.myTableViewController!.view)
     
        
        let mp4PathURL = URL.init(fileURLWithPath: videoPath)
        
        let videoInfoArray = videoPath.split(separator: "/")
        let fileName = String((videoInfoArray.last)!)
        
        
        let url = ENV.BACKENDURL.rawValue+"/api/upload"
        
        let token = UserService.shared.localUserToken!
        
        let headers: HTTPHeaders = [
            "token": token
        ]
        
    let request = try! URLRequest(url: url, method: .post, headers: headers)

    Alamofire.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(mp4PathURL, withName: "file", fileName: fileName, mimeType: "video/mp4")
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
    
    
    
    
    
    
    
    
    
    
    
}
