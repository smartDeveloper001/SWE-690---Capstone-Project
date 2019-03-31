//
//  BreakViewController.swift
//  51ALP_IOS
//
//  Created by xiu on 3/11/19.
//  Copyright © 2019 wma. All rights reserved.
//

import UIKit
import PopupDialog


class CourseViewController: UITableViewController {
    let cellIdentifier = "MyCell"
    var sectionName:[String]!
    var parentId:Int?
    var cellsData:[[CourseRs]]!
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
        prepareTabBarItem()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareNavigationItem()
        
        // load data
        sectionName  = Array<String>()
        cellsData = Array<Array<CourseRs>>()
        CourseService.shared.getCourses().done{  courseRsList in
            
            // parentMap
            print("SelectCoursesViewController:viewDidLoad courseRsList:\(courseRsList)")
            for courseRs in courseRsList{
                if courseRs.courseType! == "家长" {
                    let courseTitle =  courseRs.courseLevelName!
                    if(!self.sectionName.contains(courseTitle)){
                        self.sectionName.append(courseTitle)
                    }
                    
                }
                
            }
            
            for courseRs in courseRsList{
                if courseRs.courseType! == "孩子" {
                    let courseTitle = courseRs.courseLevelName!
                    if(!self.sectionName.contains(courseTitle)){
                        self.sectionName.append(courseTitle)
                    }
                    
                }
                
            }
            
            for i in 0..<self.sectionName.count {
                var courseRsArray = [CourseRs]()
                for courseRs in courseRsList{
                    if courseRs.courseLevelName == self.sectionName[i] {
                        courseRsArray.append(courseRs)
                    }
                    
                }
                
                self.cellsData.append(courseRsArray)
                
                
            }
             self.tableView.reloadData()
            
            
        }
        self.tableView = UITableView(frame: CGRect.zero, style: .grouped)
        self.tableView.register(SelectCoursesTableViewCell.self, forCellReuseIdentifier: self.cellIdentifier)
        
        
        
    }
    func prepareNavigationItem() {
        self.navigationController?.navigationBar.barStyle = UIBarStyle.blackTranslucent
        navigationItem.titleLabel.text = "选择课程"
    }
    
    
    
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView{
        let headerView = UIView(frame: CGRect(x:0, y:0, width:tableView.frame.size.width, height:30))
        let label = UILabel()
        label.frame = CGRect.init(x: 10, y: 0, width: headerView.frame.width-10, height: headerView.frame.height-10)
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
        return 30
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath as IndexPath) as! SelectCoursesTableViewCell
        
        var image = UIImage(named: "kids_course.png")
        image = image?.scaleImage(scaleSize:0.5)
        cell.myImageView.image = image
        cell.name.text = cellsData[indexPath.section][indexPath.row].courseName!
        cell.courseId = cellsData[indexPath.section][indexPath.row].id
        cell.myTableViewController = self
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
    func handleDetail(cell: SelectCoursesTableViewCell) {
        let cdpop = CourseDetailPopUp()
        cdpop.courseRs = CourseService.shared.courseMap[cell.courseId]
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
    
    func handleNext(cell: SelectCoursesTableViewCell) {
        let stc = TargetViewController()
        stc.parentId = self.parentId
        stc.courseId = cell.courseId
        self.navigationController?.pushViewController(stc, animated: true)
    }
    
    
    
    
    
}

extension CourseViewController {
    fileprivate func prepareTabBarItem() {
        let imageName = "task_white.png"
        let image = UIImage(named: imageName)
        tabBarItem.image = image?.scaleImage(scaleSize:0.2)
        let selectedImageName = "taks_black.png"
        let selectedImage = UIImage(named: selectedImageName)
        tabBarItem.selectedImage = selectedImage?.scaleImage(scaleSize:0.2)
        tabBarItem.title = "剖析管理"
        
    }
}
