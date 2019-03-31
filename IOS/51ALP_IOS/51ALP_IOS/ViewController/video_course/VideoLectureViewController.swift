//
//  VideoLectureViewController.swift
//  51ALP_IOS
//
//  Created by xiu on 1/30/19.
//  Copyright © 2019 wma. All rights reserved.
//

import UIKit
import Material
import SnapKit
struct VideoCatelog {
    let name:String?
    let desc:String?
}

struct ClassInfo{
    let title:String?
    let desc:String?
    let icon:String?
}

class VideoLectureViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate {
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videoCatelogs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath) as! ContactTableViewCell
        cell.myTextlebel.text = videoCatelogs[indexPath.row].name
        cell.setCurrentIndex(current:indexPath.row)
        cell.myViewController = self
        return cell
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 340
    }
    
    func prepareNavigationItem() {
        self.navigationController?.navigationBar.barStyle = UIBarStyle.blackTranslucent
        navigationItem.titleLabel.text = "视频课程"
        
    }
    
    
    
    
    let videoCatelogs = [
        VideoCatelog(name: "第一阶段", desc: "第一阶段描述"),
        VideoCatelog(name: "第二阶段", desc: "第二阶段描述"),
        VideoCatelog(name: "第三阶段", desc: "第三阶段描述"),
        VideoCatelog(name: "第四阶段", desc: "第四阶段描述"),
        
        ]
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
        prepareTabBarItem()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareNavigationItem()
        let contactsTableView = UITableView()
        contactsTableView.register(ContactTableViewCell.self, forCellReuseIdentifier: "contactCell")
        contactsTableView.dataSource = self
        contactsTableView.delegate = self
        view.addSubview(contactsTableView)
        contactsTableView.translatesAutoresizingMaskIntoConstraints = false
        contactsTableView.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
        contactsTableView.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        contactsTableView.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        contactsTableView.bottomAnchor.constraint(equalTo:view.bottomAnchor).isActive = true
        
        
    }
    
    
}


extension VideoLectureViewController {
    fileprivate func prepareTabBarItem() {
        let imageName = "class_white.png"
        let image = UIImage(named: imageName)
        tabBarItem.image = image?.scaleImage(scaleSize:0.2)
        let selectedImageName = "class_black.png"
        let selectedImage = UIImage(named: selectedImageName)
        tabBarItem.selectedImage = selectedImage?.scaleImage(scaleSize:0.2)
        tabBarItem.title = "视频课程"
    }
}



extension UIImage {
    
    func reSizeImage(reSize:CGSize)->UIImage {
        UIGraphicsBeginImageContextWithOptions(reSize,false,UIScreen.main.scale);
        self.draw(in: CGRect(x:0.0, y:0.0, width:reSize.width, height:reSize.height));
        let reSizeImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!;
        UIGraphicsEndImageContext();
        return reSizeImage;
    }
    
    
    func scaleImage(scaleSize:CGFloat)->UIImage {
        let reSize = CGSize(width:self.size.width * scaleSize, height:self.size.height * scaleSize)
        return reSizeImage(reSize:reSize)
    }
}




class  ContactTableViewCell:UITableViewCell ,UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    var myViewController: VideoLectureViewController!
    var currentIndex = 0
    func setCurrentIndex(current:Int){
        self.currentIndex = current;
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(myTextlebel)
        
        
        myTextlebel.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top).offset(10)
            make.left.equalTo(self.snp.left).offset(20)
            make.width.equalTo(self.frame.width)
            make.height.equalTo(20)
        }
        

        
        newCollection.dataSource = self
        newCollection.delegate = self
        newCollection.register(CustomeCell.self, forCellWithReuseIdentifier: cellId)
        self.addSubview(newCollection)
        
        newCollection.snp.makeConstraints { (make) in
            make.top.equalTo(self.myTextlebel.snp.bottom).offset(10)
            make.width.equalTo(self.frame.width)
            make.height.equalTo(300)
        }
        
        
    }
    
    override var frame: CGRect {
        get {
            return super.frame
        }
        set (newFrame) {
            
            super.frame.size.width = super.frame.size.width+100
            super.frame = frame
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        
    }
    
    
    let cellId = "cellId"
    
    let newCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        layout.itemSize = CGSize(width:300, height:300)
        let collection = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        
        layout.scrollDirection = .horizontal
        collection.backgroundColor = UIColor.white
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.isScrollEnabled = true
        
        return collection
    }()
    
    func setupCollection(){
        
        
    }
    
    
    
    let myTextlebel: UILabel = {
        let myTextlebel = UILabel()
        return myTextlebel
    }()
    
    
    let classInfos = [
        [
            ClassInfo(title: "ALP 基础 ", desc: "什么是ALP？",icon:"9.jpg"),
            ClassInfo(title: "ALP 入门", desc: "ALP 基本概念" ,icon:"10.jpg"),
            ClassInfo(title: "ALP 概述", desc: "ALP 主要步骤",icon:"11.jpg"),
            ClassInfo(title: "ALP 理念", desc: "ALP 理论介绍",icon:"12.jpg")
            
        ],
        [
            ClassInfo(title: "ALP 基础2 ", desc: "什么是ALP？2",icon:"1.jpg"),
            ClassInfo(title: "ALP 入门2", desc: "ALP 基本概念2",icon:"2.jpg"),
            ClassInfo(title: "ALP 概述2", desc: "ALP 主要步骤2",icon:"3.jpg"),
            ClassInfo(title: "ALP 理念2", desc: "ALP 理论介绍2",icon:"4.jpg")
            
        ],
        
        [
            ClassInfo(title: "ALP 基础3 ", desc: "什么是ALP？2",icon:"5.jpg"),
            ClassInfo(title: "ALP 入门3", desc: "ALP 基本概念2",icon:"6.jpg"),
            ClassInfo(title: "ALP 概述3", desc: "ALP 主要步骤2",icon:"7.jpg"),
            ClassInfo(title: "ALP 理念3", desc: "ALP 理论介绍2",icon:"8.jpg")
            
        ],
        
        [
            ClassInfo(title: "ALP 基础4 ", desc: "什么是ALP？2",icon:"9.jpg"),
            ClassInfo(title: "ALP 入门4", desc: "ALP 基本概念2",icon:"10.jpg"),
            ClassInfo(title: "ALP 概述4", desc: "ALP 主要步骤2",icon:"11.jpg"),
            ClassInfo(title: "ALP 理念4", desc: "ALP 理论介绍2",icon:"12.jpg")
            
        ],
        
        
        
        
        
        
        
        ]
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return classInfos[currentIndex].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = newCollection.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CustomeCell
        cell.backgroundColor  = .white
        cell.titleUI.text = classInfos[currentIndex][indexPath.row].title
        cell.textUI.text = classInfos[currentIndex][indexPath.row].desc
        cell.imageView.image = UIImage(named:classInfos[currentIndex][indexPath.row].icon!)
        
        //cell.layer.shadowOpacity = 4
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1
        return cell
    }
    
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    //        return CGSize(width: 250, height: 280)
    //    }
    // 定义展示的Section的个数
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    // 设置cell和视图边的间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
    }
    
    // 设置每一个cell最小行间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 30
    }
    
    // 设置每一个cell的列间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    // 某个Cell被选择的事件处理
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("选中\(currentIndex)列 \(indexPath.row)行")
        
        let vc = VideoPlayViewController()
        myViewController.navigationController?.present(vc, animated: false)
    }
    
    
    
    
    
    
}





class CustomeCell: UICollectionViewCell {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    let imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 0
        image.backgroundColor = UIColor.lightGray
        return image
    }()
    
    let titleUI: UILabel = {
        let title = UILabel()
        title.backgroundColor = UIColor.white
        title.font=UIFont.boldSystemFont(ofSize: 15)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.textAlignment = .left
        title.textColor = .black
        return title
    }()
    
    
    
    let textUI: UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.textAlignment = .left
        text.textColor = .black
        return text
    }()
    
    
    func  setupView(){
        self.contentView.backgroundColor = UIColor.white
        addSubview(imageView)
        addSubview(titleUI)
        addSubview(textUI)
        

        
        imageView.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top).offset(10)
            make.width.equalTo(300)
            make.height.equalTo(200)
            make.centerX.equalTo(self.snp.centerX)
        }
        
        
   
        titleUI.snp.makeConstraints { (make) in
            make.top.equalTo(self.imageView.snp.bottom).offset(10)
            make.width.equalTo(100)
            make.height.equalTo(25)
            make.centerX.equalTo(self.snp.centerX)
        }
        
        
        textUI.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleUI.snp.bottom).offset(10)
            make.width.equalTo(200)
            make.height.equalTo(25)
            make.left.equalTo(self.imageView.snp.left).offset(10)
        }
        
    
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}


