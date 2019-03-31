//
//  Break4ParentViewController.swift
//  51ALP_IOS
//
//  Created by xiu on 3/23/19.
//  Copyright © 2019 wma. All rights reserved.
//

import UIKit
import ChameleonFramework
import BadgeSwift
import Material
import PopupDialog
class Break4ParentViewController: UITableViewController {
    let cellIdentifier = "MyCell"
    
    var courseId:Int = 0
    var parentId:Int?
    
    var sectionName = ""
    var cellsData  = [BreakRes]()
    var taskSummaryInfo:TaskSummaryInfo
    
    
    required override init(style: UITableView.Style){
        self.taskSummaryInfo = TaskSummaryInfo()
        super.init(style:style)
    }
    
    required init(coder aDecoder: NSCoder) {
        // Or call super implementation
        fatalError("NSCoding not supported")
    }
    
    
    
    
    convenience init(taskSummaryInfo:TaskSummaryInfo,style: UITableView.Style){
        self.init(style: style)
        self.taskSummaryInfo = taskSummaryInfo
        self.cellsData = taskSummaryInfo.gogalToBreak[taskSummaryInfo.selectedGogalId]!
        self.sectionName = taskSummaryInfo.selectedGogalName
        
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareNavigationItem()
        self.tableView = UITableView(frame: CGRect.zero, style: .grouped)
        self.tableView.register(Break4ParentTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        
        
        
    }
    func prepareNavigationItem() {
        self.navigationController?.navigationBar.barStyle = UIBarStyle.blackTranslucent
        navigationItem.titleLabel.text = "任务所在剖析"
    }
    
    
    
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView{
        let headerView = UIView(frame: CGRect(x:0, y:0, width:tableView.frame.size.width, height:40))
        let label = UILabel()
        label.frame = CGRect.init(x: 20, y: 20, width: headerView.frame.width-10, height: headerView.frame.height-10)
        label.text = sectionName
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
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellsData.count
        
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("indexPath::",indexPath)
        
        
  
    
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath as IndexPath) as! Break4ParentTableViewCell
        
        print(indexPath)
        var image = UIImage(named: "kids_course.png")
        image = image?.scaleImage(scaleSize:0.5)
        cell.myImageView.image = image
        cell.name.text = cellsData[indexPath.row].breakTitle!
        cell.breakId = cellsData[indexPath.row].id
        cell.myTableViewController = self
        let badgeValue = self.taskSummaryInfo.breakToBadge[cellsData[indexPath.row].id]!
        if badgeValue > 0 {
            cell.badge.text = String(badgeValue)
        }else{
              cell.badge.isHidden = true
            
        }
        
        
        
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func handleDetail(cell: Break4ParentTableViewCell) {
        let cdpop = BreakDetailPopup()
        cdpop.breakRes = BreakService.shared.breakMap[cell.breakId]!
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
    
    func handleNext(cell: Break4ParentTableViewCell) {
        

        self.taskSummaryInfo.selectedBreakId =  cell.breakId
        self.taskSummaryInfo.selectedGogalName = cell.name.text!
        let stc = Task4ParentViewController(taskSummaryInfo:self.taskSummaryInfo,style:.plain)
        stc.parentId = self.parentId
        self.navigationController?.pushViewController(stc, animated: true)
        
        
    }
    
    
    
    
    
}

class Break4ParentTableViewCell: UITableViewCell {
    var myTableViewController: Break4ParentViewController?
    var questionView = UIImageView()
    var breakId = 0
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

