//
//  SelectTargetViewController.swift
//  51ALP_IOS
//
//  Created by xiu on 2/11/19.
//  Copyright © 2019 wma. All rights reserved.
//

import UIKit
import PopupDialog

class TargetViewController: UITableViewController {
    let cellIdentifier = "MyCell"
    
    var courseId:Int = 0
    var parentId:Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareNavigationItem()
        self.tableView = UITableView(frame: CGRect.zero, style: .grouped)
        self.tableView.register(SelectTargetTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        CourseService.shared.getGogalsByCourseId(courseId: courseId).done{ gogalResList  in
            if gogalResList.count > 0{
                self.sectionName.append(gogalResList[0].courseName)
            }
            var gogalArray = [GogalRes]()
            for gogalRes in gogalResList{
                gogalArray.append(gogalRes)
            }
            self.cellsData.append(gogalArray)
            self.tableView.reloadData()
            
        }
        
    
        
        
        
        
        
        
    }
    
    func prepareNavigationItem() {
        self.navigationController?.navigationBar.barStyle = UIBarStyle.blackTranslucent
        navigationItem.titleLabel.text = "目标"
    }
    
    var sectionName = [String]()
    var cellsData = [[GogalRes]]()
    
    
    
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
        

      
  
        
    

        
        
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath as IndexPath) as! SelectTargetTableViewCell
        
        print(indexPath)
        var image = UIImage(named: "kids_course.png")
        image = image?.scaleImage(scaleSize:0.5)
        cell.myImageView.image = image
        cell.name.text = cellsData[indexPath.section][indexPath.row].goalName!
        cell.gogalId = cellsData[indexPath.section][indexPath.row].id
        cell.myTableViewController = self
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
    func handleDetail(cell: SelectTargetTableViewCell) {
        let cdpop = GogalDetailPopUp()
        cdpop.gogalres = CourseService.shared.gogalMap[cell.gogalId]!
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
    
    func handleNext(cell: SelectTargetTableViewCell) {

        let bvc = BreakViewController()
        bvc.parentId = self.parentId
        bvc.gogalName = cell.name.text!
        bvc.goalID = cell.gogalId
        bvc.courseID = self.courseId
        self.navigationController?.pushViewController(bvc, animated: true)
        
        
    }
    
    
    
    
}

class SelectTargetTableViewCell: UITableViewCell {
    var myTableViewController: TargetViewController?
    var questionView = UIImageView()
    var gogalId = 0
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
        name.widthAnchor.constraint(equalToConstant: 200).isActive = true
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
        myTableViewController?.handleDetail(cell: self)
    }
    
    @objc
    internal func handleNext(button: UIButton) {
        myTableViewController?.handleNext(cell: self)
    }
    
    
    
}

