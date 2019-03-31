//
//  CourseViewController.swift
//  51ALP_IOS
//
//  Created by xiu on 1/30/19.
//  Copyright © 2019 wma. All rights reserved.
//

import UIKit
import Material
import AVKit
import SnapKit




struct VideoInfo{
    var vidoName:String
    var videoPath:String
    var videoImage:UIImage
    var videoDate: Date?{
        get{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd-HH-mm-ss"
            let videoPathoArray = vidoName.split(separator: "/")
            let fileName = String((videoPathoArray.last)!)
            let time = fileName.replacingOccurrences(of: ".mp4", with: "")
            print("time \(time)")
            return  dateFormatter.date(from:time)
        }
    
    }
}

   
    
    
class VideoViewController:  UITableViewController {
    
    var delegate: BackValueProtocol?
    
    private var allVideosHolePaths: [String]?
    private var allImageArray = [UIImage]()
    private var allVideoInfo = [VideoInfo]()
    
    
    let cellIdentifier = "MyCell"
    var taskRes:TaskRes!

    func prepareNavigationItem() {
        self.navigationController?.navigationBar.barStyle = UIBarStyle.blackTranslucent
        navigationItem.titleLabel.text = "我的视频"
    }
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
        prepareTabBarItem()
    }
    
    func scanVideoFiles(){
        allVideosHolePaths = getAllVideoPaths()
        getVideoImages(videoUrls: allVideosHolePaths!)
        allVideoInfo.removeAll()
        if allVideosHolePaths != nil && allVideosHolePaths != nil  &&  allVideosHolePaths!.count == allVideosHolePaths!.count {
            
            for index in 0 ..< allVideosHolePaths!.count {
                allVideoInfo.append(VideoInfo(
                    vidoName:allVideosHolePaths![index], videoPath: allVideosHolePaths![index], videoImage: allImageArray[index]
                    
                ))
            }
        }
        allVideoInfo.sort(by: {$0.videoDate!.compare($1.videoDate!) == .orderedDescending })
        print("------allVideoInfo\(allVideoInfo)")
        
    }
    
    func  reloadVideoFiles(){
        
        scanVideoFiles()
        self.tableView.reloadData()
        
    }
    
    //  MARK: - Private Methods
    /**
     get all mp4 file paths
     
     - returns: path
     */
    private func getAllVideoPaths() -> [String] {
        var pathArray = [String]()
        
        let pathFolder = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        
        let pathString = pathFolder[0] as String
        
        if let lists = try? FileManager.default.contentsOfDirectory(atPath: pathString) {
            for item in lists {
                print("item\(item)")
                if item.hasSuffix("mp4"){
                    print(pathString + "/" + item)
                    pathArray.append(pathString + "/" + item)
                }
                
            }
        }
        return pathArray
    }
    
    
  
    
    @objc
    internal func takeVideo(button: UIButton) {
        // login and navigate to main page
        print("start video")
        let vc = IWVideoRecordingController()
        //        vc.navigationController?.isNavigationBarHidden = true
        //        vc.navigationController?.isToolbarHidden = true
        //        vc.tabItem.isHidden = true
        self.present(vc, animated: true, completion: nil)
    }
    
    

    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
          scanVideoFiles()
        self.tableView = UITableView(frame: CGRect.zero, style: .grouped)
//        self.tableView.estimatedRowHeight = 44
//        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.register(VideoCell.self, forCellReuseIdentifier: cellIdentifier)
//        tableView.separatorStyle = .none
//        tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
   
        

        
    }
    
    
    private func getVideoImages(videoUrls: [String]) {
        
        allImageArray.removeAll()
        for item in videoUrls {
            let videoAsset = AVURLAsset(url: URL(fileURLWithPath: item))
            let cmTime = CMTime(seconds: 1, preferredTimescale: 10)
            let imageGenerator = AVAssetImageGenerator(asset: videoAsset)
            if let cgImg = try? imageGenerator.copyCGImage(at: cmTime, actualTime: nil) {
                let img = UIImage(cgImage: cgImg)
                self.allImageArray.append(img)
            } else {
                print("faill to get video image")
            }
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareNavigationItem()
        
        let starButton = IconButton(image: Icon.videocam)
        starButton.title = "拍视频"
        starButton.addTarget(self, action: #selector(takeVideo(button:)), for: .touchUpInside)
        navigationItem.rightViews = [starButton]

        
    }
 
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView{
        let headerView = UIView(frame: CGRect(x:0, y:0, width:tableView.frame.size.width, height:30))
        let label = UILabel()
        label.frame = CGRect.init(x: 5, y: 5, width: headerView.frame.width, height: headerView.frame.height)
        label.text = "本地视频（请删除上传完毕视频，减少空间）"
        label.font=UIFont.systemFont(ofSize: 16)
        //label.textColor = UIColor.cyan
        headerView.addSubview(label)
        return headerView
    }
    
    
    
    override func tableView(_ tableView: UITableView,heightForFooterInSection section: Int) -> CGFloat{
        return 0.01
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allVideoInfo.count
        
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("indexPath::",indexPath)
        
        
        
    }
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath as IndexPath) as! VideoCell
        cell.myTableViewController = self
        let videoInfo = allVideoInfo[indexPath.row]
        

        cell.videoImageView?.image = videoInfo.videoImage
        let videoInfoArray = videoInfo.vidoName.split(separator: "/")
        var fileName = String((videoInfoArray.last)!)
        var time = fileName.replacingOccurrences(of: ".mp4", with: "")//.replacingOccurrences(of:"-",with:"/")
         cell.videoNameLabel.text = "时间:" + time
        cell.videoPath = videoInfo.videoPath
        return cell
        
    }

    
    
    

    
    
    
}



extension VideoViewController {
    fileprivate func prepareTabBarItem() {
        let imageName = "video_white.png"
        let image = UIImage(named: imageName)
        tabBarItem.image = image?.scaleImage(scaleSize:0.2)
        let selectedImageName = "video_black.png"
        let selectedImage = UIImage(named: selectedImageName)
        tabBarItem.selectedImage = selectedImage?.scaleImage(scaleSize:0.2)
        tabBarItem.title = "我的视频"
    }
}
