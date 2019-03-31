//
//  AccountViewController.swift
//  51ALP_IOS
//
//  Created by xiu on 1/30/19.
//  Copyright © 2019 wma. All rights reserved.
//

import UIKit
import SCLAlertView
import PopupDialog
import JGProgressHUD
import FaceAware
import SwiftMessages
import SDWebImage
import SwiftValidators

class AccountViewController: UITableViewController {
    
    var imgProfile: UIImageView!
    var btnChooseImage: UIButton!
    var userName: UILabel!
    var accountTableView:UITableView!
    
    var sectionName:[String]!
    var cellImages:[[String]]!
    var cellsData:[[String]]!
    var cellsDetail:[[String]]!
    
    
    
    var imagePicker = UIImagePickerController()
    
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
        prepareTabBarItem()
    }
    
    let cellIdentifier = "MyCell"
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
     
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sectionName = ["个人信息","其他"]
        cellImages = [["lock_secure_security_password-512.png","finish_course.png"],["help.png","version.png"]]
        cellsData = [["密码：", "我的详情："],["寻求协助：","版本信息："]]
        cellsDetail = [["修改", "修改"],["给客服反馈","v1"]]
        
        
        
        if UserService.shared.localUserTypeId == 1 {
            
            
            UserService.shared.getParentConsultantByParentId(parentId: UserService.shared.localUserId!).done { (requestConsulentRes) in
                print("look for consultent information")
                print(requestConsulentRes)
                
                if  (self.cellImages[0].count==2) {
                    self.cellImages[0].append("people-icon.png")
                    self.cellsData[0].append("你的顾问：")
                }
                if let consutantId = requestConsulentRes.consultantID{
                    UserService.shared.getUserByUserId(userId: consutantId).done{
                        result in
                        if let user  = result.user{
                            
                            if let username = user.userName{
                                if  (self.cellsDetail[0].count == 2){
                                    self.cellsDetail[0].append(username)
                                }else{
                                    self.cellsDetail[0][2] = username
                                }
                                
                                self.tableView.reloadData()
                            }
                            
                        }
                        
                        }.catch {
                            error in
                            print("AccountViewController.viewWillAppear:\(error)")
                            if  (self.cellsDetail[0].count == 2){
                                self.cellsDetail[0].append("unknow")
                            }else{
                                self.cellsDetail[0][2] = "unknow"
                            }
                            self.tableView.reloadData()
                    }
                    
                    
                }else{
                    
                    if  (self.cellsDetail[0].count == 2){
                        self.cellsDetail[0].append("请选择顾问")
                    }else{
                        self.cellsDetail[0].append("请选择顾问")
                    }
                    
                    self.tableView.reloadData()
                }
                
                
                
                } .catch {
                    (error )in
                    
                    if  (self.cellsDetail[0].count == 2){
                        self.cellsDetail[0].append("请选择顾问")
                    }else{
                        self.cellsDetail[0].append("请选择顾问")
                    }
                    
                    self.tableView.reloadData()
                    
            }
            
            
            
            
            
        }
        
        
        prepareNavigationItem()
        self.tableView = UITableView(frame: CGRect.zero, style: .grouped)
        self.tableView.register(SubtitleTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        
        let headerView = UIView(frame: CGRect(x:0, y:0, width:tableView.frame.size.width, height:160))
        headerView.backgroundColor = UIColor.white
        
        prepareProfileView(headerView: headerView)
        tableView.tableHeaderView = headerView
        
        tableView.backgroundColor = .white
        
        //tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
    }
    
    
    @objc
    internal
    func logoutAction(){
        self.navigationController?.popToRootViewController(animated: true)
        UserService.shared.logout().done{ status -> Void in
            UserService.shared.removeLocalUserInfo()
            //            if status {
            let loginVC = LoginViewController()
            self.present(loginVC, animated: false) {
            }
            //            }
            
            }.catch { error in
                print(error)
        }
        
        
        
        
    }
    
    
    func prepareNavigationItem() {
        self.navigationController?.navigationBar.barStyle = UIBarStyle.blackTranslucent
        navigationItem.titleLabel.text = "个人信息"
        
        let button = UIBarButtonItem(title: "登出     ", style: .plain, target: self, action: #selector(logoutAction))
        navigationItem.rightBarButtonItem = button
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
    
    
    //    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView{
    //        let footerView = UIView(frame: CGRect(x:0, y:0, width:tableView.frame.size.width, height:40))
    //        footerView.backgroundColor = UIColor.red
    //
    //        return footerView
    //    }
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView{
        let headerView = UIView(frame: CGRect(x:0, y:0, width:tableView.frame.size.width, height:40))
        let label = UILabel()
        label.frame = CGRect.init(x: 20, y: 20, width: headerView.frame.width-10, height: headerView.frame.height-10)
        label.text = sectionName[section]
        //label.textColor = UIColor.cyan
        headerView.addSubview(label)
        return headerView
    }
    
    struct Info {
        var image: String?
        var title: String?
    }
    
    
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("indexPath::",indexPath)
        
        
        if (indexPath.section == 0 && indexPath.row == 0){
            let changePassView = ChangePassViewController()
            let popup = PopupDialog(viewController: changePassView,
                                    buttonAlignment: .horizontal,
                                    transitionStyle: .bounceDown,
                                    tapGestureDismissal: false,
                                    panGestureDismissal: false)
            
            let changePw = DefaultButton(title: "修改", dismissOnTap: false) {
                popup.dismiss()
                let view = MessageView.viewFromNib(layout: .cardView)
                view.layoutMarginAdditions = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
                view.button?.isHidden = true
                (view.backgroundView as? CornerRoundingView)?.cornerRadius = 10
                
                
                if(Validator.isEmpty().apply(changePassView.old_passwordField.text)){
                    view.configureTheme(.error)
                    view.configureContent(title: "错误", body: "原密码不能为空", iconText: "")
                    SwiftMessages.show(view: view)
                    return
                }
              
                
                if(!Validator.minLength(8).apply(changePassView.new_passwordField.text) || !Validator.minLength(8).apply(changePassView.new2_passwordField.text)){
                    view.configureTheme(.error)
                    view.configureContent(title: "错误", body: "密码至少８位", iconText: "")
                    SwiftMessages.show(view: view)
                    return
                }
                if(changePassView.new_passwordField.text != changePassView.new2_passwordField.text){
                    view.configureTheme(.error)
                    view.configureContent(title: "错误", body: "两次密码不匹配", iconText: "")
                    SwiftMessages.show(view: view)
                    return
                }
               
             
                UserService.shared.changePassword(userId: UserService.shared.localUserId!, oldPs: changePassView.old_passwordField.text!, newPs: changePassView.new_passwordField.text!).done{ changePsRes in
                    print(changePsRes)
         
                    if changePsRes.success{
                        view.configureTheme(.success)
                            view.configureContent(title: "成功", body: "密码修改成功！", iconText: "")
                       
                        
                        SwiftMessages.show(view: view)
                        self.dismiss(animated: true) {}
                        
                    }else{
                        view.configureTheme(.error)
                        view.configureContent(title: "失败！", body: "网络故障请重试", iconText: "")
                        SwiftMessages.show(view: view)
                        
                    }

                    }
                    .catch { error in
                        view.configureTheme(.error)
                        view.configureContent(title: "失败！", body: "网络故障请重试", iconText: "")
                        SwiftMessages.show(view: view)
                        print(error)
                    }
                    
                
                
                
                
                
                
               
            };
            let buttonOne = CancelButton(title: "取消") {
                print("You canceled the car dialog.")
            }
            popup.addButtons([changePw,buttonOne])
            self.present(popup, animated: true, completion: nil)
            
            
            
            
        }
        
        
        if (indexPath.section == 0 && indexPath.row == 1){
   
            let hud = JGProgressHUD(style: .dark)
            hud.textLabel.text = "加载中..."
            hud.show(in: self.view)
            
            CommonService.shared.getCities().done{ result -> Void in
                //print(result)
                CommonService.shared.citiesArray = result
                UserService.shared.getUserByUserId(userId: UserService.shared.localUserId!).done({ (userRes) in
                    
                    hud.dismiss(afterDelay: 3.0)
                    let uvc = UserDetailViewController()
                    if let user = userRes.user{
                        if let city = user.userCity{
                            uvc.cityTextField.text = city
                        }
                        if let state = user.userState{
                            uvc.stateTextField.text = state
                        }
                        if let userSelfIntroduce = user.userSelfIntroduce{
                            uvc.selfTextView.text = userSelfIntroduce
                        }
                    }
                    
                    self.navigationController?.pushViewController(uvc, animated: false)
                })
                
                
                }.catch { error in
                    print(error)
            }
            
        }
        
        if (indexPath.section == 0 && indexPath.row == 2){
            
            let hud = JGProgressHUD(style: .dark)
            hud.textLabel.text = "加载中..."
            hud.show(in: self.view)
            
            
            UserService.shared.getConsultants().done { (result ) in
                print(result)
                hud.dismiss(afterDelay: 3.0)
                let cvc = ConsultantsListViewController()
                cvc.consultantList = result
                self.navigationController?.pushViewController(cvc, animated: true)
            }
            
            
            
            
        }
        
        
        
        if (indexPath.section == 1 && indexPath.row == 0){
            let fvc = FeedbackViewController()
            let popup = PopupDialog(viewController: fvc,
                                    buttonAlignment: .horizontal,
                                    transitionStyle: .bounceDown,
                                    tapGestureDismissal: true,
                                    panGestureDismissal: false)
            
            let changePw = DefaultButton(title: "发送", dismissOnTap: false) {
                let view = MessageView.viewFromNib(layout: .cardView)
                view.layoutMarginAdditions = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
                view.button?.isHidden = true
                (view.backgroundView as? CornerRoundingView)?.cornerRadius = 10
                 popup.dismiss()
                if(Validator.isEmpty().apply(fvc.feedbackText.text)){
                    view.configureTheme(.error)
                    view.configureContent(title: "错误", body: "回馈信息不能为空", iconText: "")
                    SwiftMessages.show(view: view)
                    return
                }
                
                var feedbackRq = FeedbackRq(userID:UserService.shared.localUserId!,feedback:fvc.feedbackText.text!)
                CommonService.shared.addFeedback(feedbackRq: feedbackRq).done{ (feedbackRs) in
                    if feedbackRs != nil {
                         view.configureTheme(.success)
                        view.configureContent(title: "成功", body: "我们将在最短时间通过邮件回馈你的问题", iconText: "")
                         SwiftMessages.show(view: view)
                    }else{
                         view.configureTheme(.error)
                          view.configureContent(title: "失败！", body: "网络故障请重试", iconText: "")
                         SwiftMessages.show(view: view)
                    }
                    }.catch { error in
                        view.configureTheme(.error)
                        view.configureContent(title: "失败！", body: "网络故障请重试", iconText: "")
                        SwiftMessages.show(view: view)
                        print(error)
                }
                
               
            };
            let buttonOne = CancelButton(title: "取消") {
                print("You canceled the car dialog.")
            }
            popup.addButtons([changePw,buttonOne])
            self.present(popup, animated: true, completion: nil)
            
        }
        
        
        
        if (indexPath.section == 1 && indexPath.row == 1){
            let title = "V1"
            let message = "这个是我们的第一个版本，完成于2019年4月10日"
            let popup = PopupDialog(title: title, message: message, image: nil)
            
            let buttonOne = CancelButton(title: "关闭") {
               
            }
            popup.addButtons([buttonOne])

            self.present(popup, animated: true, completion: nil)
            
            
        }

        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath as IndexPath) as! SubtitleTableViewCell

        
        //        if (indexPath.section == 0){
        var image = UIImage(named: cellImages[indexPath.section][indexPath.row])
        image = image?.scaleImage(scaleSize:0.05)
        cell.myImageView.image = image
        cell.title.text = cellsData[indexPath.section][indexPath.row]
        
        cell.detail.text = cellsDetail[indexPath.section][indexPath.row]
        //            cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator;
        
        
        //        }
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
    func prepareProfileView(headerView:UIView){
        let containerView = UIView()
        headerView.addSubview(containerView)
        
        containerView.backgroundColor  = UIColor(red:0.16, green:0.71, blue:0.96, alpha:1.0)
        containerView.borderColor = UIColor.gray
        containerView.layer.cornerRadius = 10
        
        containerView.layer.shadowColor = UIColor.flatBlue.cgColor
        containerView.layer.shadowOpacity = 1.0
        containerView.layer.shadowOffset = CGSize(width: 0, height: 0)
        containerView.layer.shadowRadius = 4
        
        
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.topAnchor.constraint(equalTo:headerView.topAnchor,constant: 10).isActive = true
        containerView.centerXAnchor.constraint(equalTo:headerView.centerXAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 150  ).isActive = true
        containerView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        
        imgProfile = UIImageView()
        print("------> UserService.shared.localUserAvataImage\(UserService.shared.localUserAvataImage)")
        if UserService.shared.localUserAvataImage != nil {
            SDImageCache.shared().clearMemory()
            SDImageCache.shared().clearDisk()
                  imgProfile.sd_setImage(with: URL(string: ENV.BACKENDURL.rawValue+UserService.shared.localUserAvataImage!), placeholderImage: UIImage(named: "placeholder-profile.jpg"))
            
        }else{
          imgProfile.image = UIImage(named: "placeholder-profile.jpg")
        }
        imgProfile.focusOnFaces = true

        containerView.addSubview(imgProfile)
        
        

        
        
        imgProfile.translatesAutoresizingMaskIntoConstraints = false
        imgProfile.topAnchor.constraint(equalTo: containerView.topAnchor ,constant: 10).isActive = true
        imgProfile.centerXAnchor.constraint(equalTo:containerView.centerXAnchor).isActive = true
        imgProfile.heightAnchor.constraint(equalToConstant: 100  ).isActive = true
        imgProfile.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        userName = UILabel()
        userName.text = UserService.shared.localUserEmail!
        userName.textColor = UIColor.white
        userName.textAlignment = NSTextAlignment.center
        
        
        
        containerView.addSubview(userName)
        userName.translatesAutoresizingMaskIntoConstraints = false
        userName.topAnchor.constraint(equalTo: imgProfile.bottomAnchor ,constant: 10).isActive = true
        userName.heightAnchor.constraint(equalToConstant: 20  ).isActive = true
        userName.widthAnchor.constraint(equalToConstant: 200).isActive = true
        userName.centerXAnchor.constraint(equalTo:containerView.centerXAnchor).isActive = true
        
        
        
        
        
        btnChooseImage = UIButton()
        //btnChooseImage.backgroundColor = UIColor.blue
        //btnChooseImage.setTitle("change",for: UIControl.State.normal)
        
        let panImage = UIImage(named: "pen.png")
        btnChooseImage.setImage(panImage, for: UIControl.State.normal)
        containerView.addSubview(btnChooseImage)
        btnChooseImage.translatesAutoresizingMaskIntoConstraints = false
        btnChooseImage.centerYAnchor.constraint(equalTo: imgProfile.centerYAnchor).isActive = true
        btnChooseImage.leftAnchor.constraint(equalTo:imgProfile.rightAnchor,constant:10).isActive = true
        btnChooseImage.heightAnchor.constraint(equalToConstant: 30  ).isActive = true
        btnChooseImage.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        btnChooseImage.addTarget(self, action: #selector(btnChooseImageOnClick(button:)), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.imgProfile.layer.cornerRadius = imgProfile.bounds.width/2
        self.imgProfile.layer.borderWidth = 1
        self.imgProfile.layer.borderColor = UIColor.lightGray.cgColor
        self.imgProfile.clipsToBounds = true
        
        
        
        self.btnChooseImage.layer.cornerRadius = 5
    }
    
    
    func openCamera(){
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            //If you dont want to edit the photo then you can set allowsEditing to false
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
        else{
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

    
    func openGallary(){
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        //If you dont want to edit the photo then you can set allowsEditing to false
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    
    
    
    
    @objc
    internal func btnChooseImageOnClick(button: UIButton) {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "拍照", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "选择照片", style: .default, handler: { _ in
            self.openGallary()
        }))
        
        alert.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
}

extension AccountViewController {
    fileprivate func prepareTabBarItem() {
        let imageName = "account_white.png"
        let image = UIImage(named: imageName)
        tabBarItem.image = image?.scaleImage(scaleSize:0.2)
        let selectedImageName = "account_black.png"
        let selectedImage = UIImage(named: selectedImageName)
        tabBarItem.selectedImage = selectedImage?.scaleImage(scaleSize:0.2)
        tabBarItem.title = "我的信息"
    }
}


extension AccountViewController:  UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        self.imgProfile.image = selectedImage
        print("selectedImage\(selectedImage)")
        
        
        

        let data = selectedImage.jpegData(compressionQuality: 0.5)
        let homeDirectory = NSHomeDirectory()
        let documentPath = homeDirectory + "/Documents"
  
        let fileManager: FileManager = FileManager.default
        do {
            try fileManager.createDirectory(atPath: documentPath, withIntermediateDirectories: true, attributes: nil)
        }
        catch let error {
            print(error)
        }
        fileManager.createFile(atPath: documentPath.appendingFormat("/myavata.jpg"), contents: data, attributes: nil)
        let filePath: String = String(format: "%@%@", documentPath, "/myavata.jpg")
        print("filePath:" + filePath)
        self.imgProfile.image = selectedImage
        self.imgProfile.focusOnFaces = true
         dismiss(animated: true, completion: nil)
        
        
        let view = MessageView.viewFromNib(layout: .cardView)
        view.layoutMarginAdditions = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        view.button?.isHidden = true
        (view.backgroundView as? CornerRoundingView)?.cornerRadius = 10

        CommonService.shared.uploadImage(imagePath: filePath).done { (uploadRes) in
            print(uploadRes)
            if uploadRes.success {
                view.configureTheme(.success)
                view.configureContent(title: "成功", body: "你的头像保存成功", iconText: "")
                SwiftMessages.show(view: view)
            }else{

                view.configureTheme(.error)
                view.configureContent(title: "保存失败！", body: "网络故障请重试", iconText: "")
                SwiftMessages.show(view: view)
            }

            }.catch { error in
                view.configureTheme(.error)
                view.configureContent(title: "保存失败！", body: "网络故障请重试", iconText: "")
                SwiftMessages.show(view: view)
                print(error)
        }

       
       
       
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.isNavigationBarHidden = false
        self.dismiss(animated: true, completion: nil)
    }
}

class SubtitleTableViewCell: UITableViewCell {
    
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
    let detail  = UILabel()
    let naviButtion = UIButton()
    
    func setup(){
        title.font=UIFont.systemFont(ofSize: 14)
        detail.font=UIFont.systemFont(ofSize: 14)
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
        
        
        detail.textAlignment=NSTextAlignment.right
        detail.translatesAutoresizingMaskIntoConstraints = false
        detail.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        detail.heightAnchor.constraint(equalToConstant: 50  ).isActive = true
        detail.widthAnchor.constraint(equalToConstant: 200).isActive = true
        detail.rightAnchor.constraint(equalTo:naviButtion.leftAnchor,constant:-5).isActive = true
        
        
    }
    
    
    
    
}






