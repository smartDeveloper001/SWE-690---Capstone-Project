//
//  SelectCoursesViewController.swift
//  51ALP_IOS
//
//  Created by xiu on 2/11/19.
//  Copyright © 2019 wma. All rights reserved.
//

import UIKit

class SelectCoursesViewController: UITableViewController {
    let cellIdentifier = "MyCell"
    var sectionName:[String]!
    var cellsData:[[CourseRs]]!
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
                    self.sectionName.append(courseTitle)
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
         
            
        }
        self.tableView = UITableView(frame: CGRect.zero, style: .grouped)
        self.tableView.register(SelectCoursesTableViewCell.self, forCellReuseIdentifier: self.cellIdentifier)
        
        
      
    }
    func prepareNavigationItem() {
        self.navigationController?.navigationBar.barStyle = UIBarStyle.blackTranslucent
        navigationItem.titleLabel.text = "选择课程"
    }
    

    
    
    
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
        let stc = TargetViewController()
        self.navigationController?.pushViewController(stc, animated: true)
        
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath as IndexPath) as! SelectCoursesTableViewCell
     
        print(indexPath)
        var image = UIImage(named: "kids_course.png")
        image = image?.scaleImage(scaleSize:0.5)
        cell.myImageView.image = image
        cell.name.text = cellsData[indexPath.section][indexPath.row].courseLevelName!

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
    

}

class SelectCoursesTableViewCell: UITableViewCell {
    var myTableViewController: CourseViewController?
    var courseId = 0
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
    let naviButtion = UIButton()
    let questionView = UIImageView()
    
    

    
    
    func setup(){
        
        let rightimage = UIImage(named:"right.png")
        
        naviButtion.setImage(rightimage, for: UIControl.State.normal)
        self.contentView.addSubview(myImageView)
        self.contentView.addSubview(name)
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
        naviButtion.widthAnchor.constraint(equalToConstant: 40).isActive = true
        naviButtion.rightAnchor.constraint(equalTo:contentView.rightAnchor,constant: -30).isActive = true
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleDetail))
        questionView.addGestureRecognizer(tap)
        questionView.isUserInteractionEnabled = true
        
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(handleNext))
        naviButtion.addGestureRecognizer(tap2)
        naviButtion.isUserInteractionEnabled = true
        


    }
    
    @objc
    internal func handleDetail(button: UIButton) {
        myTableViewController?.handleDetail(cell: self)
    }
    
    @objc
    internal func handleNext(button: UIButton) {
        myTableViewController?.handleNext(cell: self)
    }
    
    

    
    
}


