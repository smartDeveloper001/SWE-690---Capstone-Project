//
//  CoursesViewController.swift
//  51ALP_IOS
//
//  Created by xiu on 3/22/19.
//  Copyright © 2019 wma. All rights reserved.
//

import UIKit
import ChameleonFramework
import BadgeSwift
import Material
import PopupDialog

struct TaskSummaryInfo{
    var courseToGogal:[Int:[GogalRes]]
    var gogalToBreak:[Int:[BreakRes]]
    var breakToTask:[Int:[TaskRes]]
    var courseToBadge:[Int:Int]
    var gogalToBadge:[Int:Int]
    var breakToBadge:[Int:Int]
    var taskToBadge:[Int:Int]
    var selectedCourseId:Int
    var selectedCourseName:String
    
    var selectedGogalId:Int
    var selectedGogalName:String
    
    var selectedBreakId:Int
    var selectedBreakName:String
    
    
    
    init(){

        courseToGogal = [Int:[GogalRes]]()
        gogalToBreak = [Int:[BreakRes]]()
        breakToTask = [Int:[TaskRes]]()
        courseToBadge = [Int:Int]()
        gogalToBadge = [Int:Int]()
        breakToBadge = [Int:Int]()
        taskToBadge = [Int:Int]()
        selectedCourseId = 0
        selectedCourseName = ""
        
        selectedGogalId = 0
        selectedGogalName = ""
        
        selectedBreakId = 0
        selectedBreakName = ""
        
        
        
    }
    
    
}


class Course4ParentViewController: UITableViewController {
    let cellIdentifier = "MyCell"
    var parentId:Int!
    var cellsData = [String:[CourseRs]]()
    var sectionName = [String]()
    var taskSummaryInfo = TaskSummaryInfo()
    var courseList = [CourseRs]()
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
        prepareTabBarItem()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView = UITableView(frame: CGRect.zero, style: .grouped)
        self.tableView.register(Course4ParentTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        prepareNavigationItem()
        print("-------Course4ParentViewController viewDidLoad self.tableView \(self.tableView )")
        
    }
  
    func prepareNavigationItem() {
        self.navigationController?.navigationBar.barStyle = UIBarStyle.blackTranslucent
        navigationItem.titleLabel.text = "任务所在课程"
    }
    
    

    
    override func viewWillAppear(_ animated: Bool) {
        if UserService.shared.localUserTypeId == 1 {
            parentId = UserService.shared.localUserId!
            
        }
        super.viewWillAppear(animated)
        print("parentId:\(parentId)")
        
        TaskService.shared.getTasks(parentId:parentId).done{ taskResList  in
            print("taskResList\(taskResList)")
            self.cellsData.removeAll()
            for taskRes in taskResList{
                if taskRes.taskStatus != 0 {

                    self.taskSummaryInfo.courseToGogal.removeAll()
                    self.taskSummaryInfo.gogalToBreak.removeAll()
                    self.taskSummaryInfo.breakToTask.removeAll()

                   let courseRs = CourseService.shared.courseMap[taskRes.courseID]
                   print("courseRs!.courseLevelName \(courseRs!.courseLevelName)")

                    if !self.sectionName.contains(courseRs!.courseLevelName!){
                         self.sectionName.append(courseRs!.courseLevelName!)
                    }

                    var courseArray = self.cellsData[courseRs!.courseLevelName!]
                    if courseArray == nil {
                        courseArray = [CourseRs]()
                    }
                    
                    let found = courseArray!.filter{ $0.id == courseRs!.id}.count > 0
                    if !found{
                         courseArray!.append(courseRs!)
                    }
                    
                    
                    self.cellsData[courseRs!.courseLevelName!] = courseArray
                     let gogalRes = CourseService.shared.gogalMap[taskRes.goalID]

                    var gogalResArray =  self.taskSummaryInfo.courseToGogal[taskRes.courseID]
                    if gogalResArray == nil {
                        gogalResArray = [GogalRes]()
                    }
                    gogalResArray!.append(gogalRes!)
                     self.taskSummaryInfo.courseToGogal[taskRes.courseID] = gogalResArray!

                    let breakRes = BreakService.shared.breakMap[taskRes.goalBreakID]

                     var gogalBreakArray =  self.taskSummaryInfo.gogalToBreak[taskRes.goalID]
                    if gogalBreakArray == nil {
                        gogalBreakArray = [BreakRes]()

                    }
                    gogalBreakArray?.append(breakRes!)
                    self.taskSummaryInfo.gogalToBreak[taskRes.goalID] = gogalBreakArray!

                    var taskArray =  self.taskSummaryInfo.breakToTask[taskRes.goalBreakID]
                    if taskArray == nil {
                        taskArray = [TaskRes]()

                    }
                    taskArray!.append(taskRes)
                     self.taskSummaryInfo.breakToTask[taskRes.goalBreakID] = taskArray!

                    var numberOfRelay = 0
                    var index = -1
                    if taskRes.replays != nil  && (taskRes.replays!.count > 0) {
                         index = taskRes.replays!.count-1
                        
                    }else{
                        
                        if UserService.shared.localUserTypeId == 1{
                            numberOfRelay += 1
                            
                        }
                        
                    }
                    
                    while index >= 0 {
                        let type = taskRes.replays![index].replayType
                        
                        if UserService.shared.localUserTypeId == 1{ // if user is parent we count type is 2 means consultant replay
                            if type == 2 {
                                numberOfRelay += 1
                            }else{
                                break
                            }
                        }
                        
                        
                        if UserService.shared.localUserTypeId == 2{ // if user is consutant we count type is 1 means parent replay
                            if type == 1 {
                                numberOfRelay += 1
                            }else{
                                break
                            }
                        }
                        
                        
                        
                        
                        

                        index -= 1

                    }
                    self.taskSummaryInfo.taskToBadge[taskRes.id] = numberOfRelay

                    }


                }




            var numberOfBudgeForBreak = 0
            for (breakId, taskArray) in  self.taskSummaryInfo.breakToTask {
                for taskRes in taskArray{
                    numberOfBudgeForBreak = numberOfBudgeForBreak + self.taskSummaryInfo.taskToBadge[taskRes.id]!
                }
                self.taskSummaryInfo.breakToBadge[breakId] = numberOfBudgeForBreak

            }

            var numberOfBudgeForGogal = 0

            for (gogalId, breakList) in  self.taskSummaryInfo.gogalToBreak {
                for breakRes in breakList{
                    numberOfBudgeForGogal = numberOfBudgeForGogal + self.taskSummaryInfo.breakToBadge[breakRes.id]!
                }
                self.taskSummaryInfo.gogalToBadge[gogalId] = numberOfBudgeForGogal

            }


            var numberOfBudgeForCorse = 0

            for (gogalId, gogalArray) in  self.taskSummaryInfo.courseToGogal {
                for gogalRes in gogalArray{
                    numberOfBudgeForCorse = numberOfBudgeForCorse + self.taskSummaryInfo.gogalToBadge[gogalRes.id]!
                }
                self.taskSummaryInfo.courseToBadge[gogalId] = numberOfBudgeForCorse

            }
            print("self.taskSummaryInfo.courseToBadge \(self.taskSummaryInfo)")
            print("self.cellsData \(self.cellsData)")
             print("self.sectionName \(self.sectionName)")
            self.prepareTabBarItem()
             self.tableView.reloadData()
            }


        
    
            
        
            
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
        return cellsData[sectionName[section]]!.count
        
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("indexPath::",indexPath)

        
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath as IndexPath) as! Course4ParentTableViewCell
        
        print(indexPath)
        var image = UIImage(named: "kids_course.png")
        image = image?.scaleImage(scaleSize:0.5)
        cell.myImageView.image = image
        let badgeValue = self.taskSummaryInfo.courseToBadge[cellsData[sectionName[indexPath.section]]![indexPath.row].id]!
        if badgeValue > 0 {
          cell.badge.text = String(badgeValue)
        }else{
            cell.badge.isHidden = true
        }
        cell.courseId = cellsData[sectionName[indexPath.section]]![indexPath.row].id
        cell.name.text = cellsData[sectionName[indexPath.section]]![indexPath.row].courseName!
        cell.myTableViewController = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
    func handleDetail(cell: Course4ParentTableViewCell) {
        
        let cdpop = CourseDetailPopUp()
        cdpop.courseRs = CourseService.shared.courseMap[cell.courseId]
        print(cell.courseId)
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
    
    func handleNext(cell: Course4ParentTableViewCell) {
        
        
        self.taskSummaryInfo.selectedCourseId =  cell.courseId
        self.taskSummaryInfo.selectedCourseName = cell.name.text!
        let stc = Gogal4ParentViewController(taskSummaryInfo:self.taskSummaryInfo,style:.plain)
        stc.parentId = self.parentId
        
        self.navigationController?.pushViewController(stc, animated: true)
        
    }
    
    
    
    
    
    
    
}
   

class Course4ParentTableViewCell: UITableViewCell {
    var myTableViewController:Course4ParentViewController?
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
    let badge = BadgeSwift()
    
    
    
    
    func setup(){
        
        let rightimage = UIImage(named:"right.png")
        naviButtion.setImage(rightimage, for: UIControl.State.normal)
        self.contentView.addSubview(myImageView)
        self.contentView.addSubview(name)
        self.contentView.addSubview(naviButtion)
        self.contentView.addSubview(badge)
        badge.textColor = UIColor.white
        badge.borderWidth = 5.0
        badge.translatesAutoresizingMaskIntoConstraints = false
        badge.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        badge.rightAnchor.constraint(equalTo:contentView.rightAnchor,constant: -50).isActive = true
        
        
        
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
        
        let questionView = UIImageView()
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
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleDetail))
        questionView.addGestureRecognizer(tap)
        questionView.isUserInteractionEnabled = true
        
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(handleNext))
        naviButtion.addGestureRecognizer(tap2)
        naviButtion.isUserInteractionEnabled = true
        
        
    }
    @objc
    internal func handleDetail(button: UIButton) {
        print("handleDetail")
        myTableViewController?.handleDetail(cell: self)
    }
    
    @objc
    internal func handleNext(button: UIButton) {
        myTableViewController?.handleNext(cell: self)
    }
    
    
    
}

extension Course4ParentViewController {
    fileprivate func prepareTabBarItem() {
        let imageName = "study_white.png"
        let image = UIImage(named: imageName)
        tabBarItem.image = image?.scaleImage(scaleSize:0.2)
        let selectedImageName = "study_black.png"
        let selectedImage = UIImage(named: selectedImageName)
        tabBarItem.selectedImage = selectedImage?.scaleImage(scaleSize:0.2)
        tabBarItem.title = "学习任务"
        if UserService.shared.localUserTypeId == 1{
            var totalBadge = 0
            for (key,value) in self.taskSummaryInfo.courseToBadge{
                totalBadge = totalBadge + value
            }
            if totalBadge > 0 {
                 self.tabBarItem.badgeValue = String(totalBadge)
            }
            
//            UserService.shared.getParentConsultantByParentId(parentId:UserService.shared.localUserId!).done { requestConsulentRes in
//                if requestConsulentRes.id != nil {
//                    if requestConsulentRes.numTasksReplay > 0 {
//                        print("there are \(requestConsulentRes.numTasksReplay) tasks need you to replay")
//                        self.tabBarItem.badgeValue = String(requestConsulentRes.numTasksReplay)
//                    }else{
//                        print("there is not any tasks need you to replay")
//                    }
//
//
//                }else{
//
//                }
//
//
//            }
            
        }
        
        
        
    }
}



