//
//  AssignTaskViewController.swift
//  51ALP_IOS
//
//  Created by xiu on 2/12/19.
//  Copyright © 2019 wma. All rights reserved.
//

import UIKit
import PopupDialog
class AssignTaskViewController: UITableViewController {
    let cellIdentifier = "MyCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.viewDidLoad()
        prepareNavigationItem()
        self.tableView = UITableView(frame: CGRect.zero, style: .grouped)
        self.tableView.register(AssignTaskTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    }
    
    func prepareNavigationItem() {
        self.navigationController?.navigationBar.barStyle = UIBarStyle.blackTranslucent
        navigationItem.titleLabel.text = "添加任务"
    }
    
    let sectionName = ["剖析一"]
    let cellsData = [["任务一"]]
    
  
    
    @objc
    internal func addTaskPopup(button: UIButton){
        
        let atp = AddNewTaskPopup()
        let popup1 = PopupDialog(viewController: atp,
                                buttonAlignment: .horizontal,
                                transitionStyle: .bounceDown,
                                tapGestureDismissal: true,
                                panGestureDismissal: false)
        
        
        
        let changePw = DefaultButton(title: "添加", dismissOnTap: false) {
            
        };
        let buttonOne = CancelButton(title: "关闭") {
            print("You canceled the car dialog.")
        }
        popup1.addButtons([changePw,buttonOne])
        self.present(popup1, animated: true, completion: nil)
        
    }
    
    
    @objc
    internal func taskInfoPopup(button: UIButton){
        
        let dp = DetailPopup()
        dp.detailTitle.text = "剖析一"
        dp.detailConent.text = "剖析一的具体描述"
        let popup2 = PopupDialog(viewController: dp,
                                buttonAlignment: .horizontal,
                                transitionStyle: .bounceDown,
                                tapGestureDismissal: true,
                                panGestureDismissal: false)
        
        
        
    
        let buttonOne = CancelButton(title: "关闭") {
            print("You canceled the car dialog.")
        }
        popup2.addButtons([buttonOne])
        self.present(popup2, animated: true, completion: nil)
        
    }
    
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView{
        let headerView = UIView(frame: CGRect(x:0, y:0, width:tableView.frame.size.width, height:40))
        let label = UILabel()
        label.frame = CGRect.init(x: 20, y: 20, width: headerView.frame.width-10, height: headerView.frame.height-10)
        label.text = sectionName[section]
        label.font=UIFont.systemFont(ofSize: 16)
        //label.textColor = UIColor.cyan
        
        
        let button1 = UIButton(type: .system)
        button1.setTitle("查看详情", for: UIControl.State.normal)
        button1.frame = CGRect.init(x: 10, y: 20, width: 100, height: headerView.frame.height-10)
        button1.addTarget(self, action: #selector(taskInfoPopup(button:)), for: .touchUpInside)
        headerView.addSubview(button1)
        
        
        
        let button2 = UIButton(type: .system)
        button2.setTitle("添加新任务", for: UIControl.State.normal)
        button2.frame = CGRect.init(x: 250, y: 20, width: 100, height: headerView.frame.height-10)
        button2.addTarget(self, action: #selector(addTaskPopup(button:)), for: .touchUpInside)
        headerView.addSubview(button2)
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath as IndexPath) as! AssignTaskTableViewCell
        
        print(indexPath)
        var image = UIImage(named: "kids_course.png")
        image = image?.scaleImage(scaleSize:0.5)
        cell.myImageView.image = image
        cell.name.text = cellsData[indexPath.section][indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
    
    
}

class AssignTaskTableViewCell: UITableViewCell {
    
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
        name.widthAnchor.constraint(equalToConstant: 100).isActive = true
        name.leftAnchor.constraint(equalTo:myImageView.rightAnchor ,constant: 10).isActive = true
        
        
        
        naviButtion.translatesAutoresizingMaskIntoConstraints = false
        naviButtion.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        naviButtion.heightAnchor.constraint(equalToConstant: 20  ).isActive = true
        naviButtion.widthAnchor.constraint(equalToConstant: 20).isActive = true
        naviButtion.rightAnchor.constraint(equalTo:contentView.rightAnchor,constant: -30).isActive = true
        
        
        
    }
}

