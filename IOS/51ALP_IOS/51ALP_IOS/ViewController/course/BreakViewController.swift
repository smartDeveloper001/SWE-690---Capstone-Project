//
//  BreakViewController.swift
//  51ALP_IOS
//
//  Created by xiu on 3/11/19.
//  Copyright © 2019 wma. All rights reserved.
//

import UIKit

class BreakViewController: UITableViewController {
    let cellIdentifier = "MyCell"
    var gogalName:String = ""
    var goalID:Int!
    var courseID:Int!
    var parentId:Int?
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         self.sectionName.removeAll()
         self.cellsData.removeAll()
        BreakService.shared.getBreaks(consultantId: UserService.shared.localUserId!).done{ breakResList  in
            
            var breakResArray = [BreakRes]()
            for breakres in breakResList{
                if let status = breakres.breakStatus {
                    if (status > 0 ) {
                        if breakres.goalID == self.goalID{
                            breakResArray.append(breakres)
                        }
                        
                    }
                }
              
            }
            self.cellsData.append(breakResArray)
            self.sectionName.append(self.gogalName)
            self.tableView.reloadData()
            
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareNavigationItem()
        self.tableView = UITableView(frame: CGRect.zero, style: .grouped)
        self.tableView.register(BreakCell.self, forCellReuseIdentifier: cellIdentifier)
        
        
    
        
        
    }
    
    func prepareNavigationItem() {
        self.navigationController?.navigationBar.barStyle = UIBarStyle.blackTranslucent
        navigationItem.titleLabel.text = "剖析列表"
        if UserService.shared.processStatus != 1 {
            let button = UIBarButtonItem(title: "添加新剖析     ", style: .plain, target: self, action: #selector(addAction))
            navigationItem.rightBarButtonItem = button
            
        }

    }
    
    
    @objc
    internal
    func addAction(){
        let ubvc = UpdateBreakViewController()
        ubvc.courseID = self.courseID
        ubvc.goalID = self.goalID
        ubvc.parentId = self.parentId
        self.navigationController?.pushViewController(ubvc, animated: false)
    }
    
    
    
    var sectionName = [String]()
    var cellsData = [[BreakRes]]()
    
    
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

            
            let ubvc = UpdateBreakViewController()
            ubvc.goalID = self.goalID
            ubvc.courseID = self.courseID
            ubvc.parentId = self.parentId
            ubvc.isUpdate = true
            ubvc.breakObj = cellsData[indexPath.section][indexPath.row]
            self.navigationController?.pushViewController(ubvc, animated: false)
      
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath as IndexPath) as! BreakCell
        
        print(indexPath)
        var image = UIImage(named: "kids_course.png")
        image = image?.scaleImage(scaleSize:0.5)
        cell.myImageView.image = image
        cell.name.text = cellsData[indexPath.section][indexPath.row].breakTitle
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
    
    
}


