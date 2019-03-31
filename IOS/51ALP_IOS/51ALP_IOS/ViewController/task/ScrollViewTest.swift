//
//  TaskViewController.swift
//  51ALP_IOS
//
//  Created by xiu on 3/16/19.
//  Copyright © 2019 wma. All rights reserved.
//

//import UIKit
//import SnapKit
//
//
//
//
//let ScreenWidth = UIScreen.main.bounds.width
//let ScreenHeight = UIScreen.main.bounds.height
//let topScrollHeight: CGFloat = UIScreen.main.bounds.height /// 3
//let boxWidth: CGFloat = ScreenWidth * 2 / 3
//let boxHight: CGFloat = ScreenWidth * 2 / 3
//let boxGap: CGFloat = 20
//
//
//class TaskViewController:UIViewController {
//
//
//
//    let scrollView = UIScrollView()
//    let containerView = UIView()
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        /**
//         使用Container进行布局
//         Use container in scrollview to layout subviews
//         */
//
//        /**
//         使用外部视图进行布局
//         Use views outside to locate subviews in scrollview
//         */
//        layoutWithContainer()
//        //        layoutWithAbsoluteView()
//        //        layoutWithCustomePageSize()
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//
//    override func viewDidLayoutSubviews() {
//        //        scrollView.contentSize = CGSizeMake(1000, topScrollHeight)
//        //        scrollView.contentSize.width = 1000
//        print(scrollView.contentSize.width)
//    }
//}
//
//// MARK: - 用Container实现自动布局
//extension TaskViewController {
//    func layoutWithContainer() {
//        scrollView.bounces = false
//        view.addSubview(scrollView)
//        scrollView.backgroundColor = UIColor.yellow
//        scrollView.addSubview(containerView)
//
//        containerView.backgroundColor = scrollView.backgroundColor
//
//        /**
//         *  对scrollView添加约束
//         *  Add constraints to scrollView
//         */
//        scrollView.snp.makeConstraints { (make) -> Void in
//            make.centerX.equalTo(view.snp.centerX)
//            make.top.bottom.equalTo(view)
//            make.width.equalTo(ScreenWidth)
//        }
//
//        /**
//         *  对containerView添加约束，接下来只要确定containerView的宽度即可
//         *  Add constraints to containerView, the only thing we will do
//         *  is to define the width of containerView
//         */
//        containerView.snp.makeConstraints { (make) -> Void in
//            make.edges.equalTo(scrollView)
//            make.width.equalTo(ScreenWidth)
//        }
//
//        for i in 0...5 {
//            let box = UIView()
//            box.backgroundColor = UIColor.red
//            containerView.addSubview(box)
//
//            box.snp.makeConstraints({ (make) -> Void in
//                make.left.width.equalTo(containerView)  // 确定top和height之后，box在竖直方向上完全确定
//                make.height.equalTo(boxHight)
//                if i == 0 {
//                    make.top.equalTo(containerView).offset(boxGap / 2)
//                }
//                else if let previousBox = containerView.subviews[i - 1] as? UIView{
//                    make.top.equalTo(previousBox.snp.bottom).offset(boxGap)
//                }
//                if i == 5 {
//                    containerView.snp.makeConstraints({ (make) -> Void in
//                        // 这一步是关键，它确定了container的宽度，也就确定了contentSize
//                        // This step is very important, it set the width of container, so the
//                        // contentSize is available now
//                        make.bottom.equalTo(box)
//                    })
//                }
//            })
//        }
//    }
//}
//
//extension TaskViewController {
//    func layoutWithAbsoluteView() {
//        scrollView.bounces = false
//        view.addSubview(scrollView)
//        scrollView.backgroundColor = UIColor.yellow
//
//        scrollView.snp_makeConstraints { (make) -> Void in
//            make.centerY.equalTo(view.snp_centerY)
//            make.left.right.equalTo(view)
//            make.height.equalTo(topScrollHeight)
//        }
//
//        for i in 0...5 {
//            let box = UIView()
//            box.backgroundColor = UIColor.red
//            scrollView.addSubview(box)
//
//            // box依赖于外部视图布局，不能依赖scrollView
//            // The position of box rely on self.view instead of scrollView
//            box.snp_makeConstraints({ (make) -> Void in
//                make.top.equalTo(0)
//                // This bottom can be incorret when device is rotated
//                make.bottom.equalTo(view).offset(-(ScreenHeight - topScrollHeight) / 2)
//                make.height.equalTo(topScrollHeight)
//
//                make.width.equalTo(boxWidth)
//                if i == 0 {
//                    make.left.equalTo(boxGap / 2)
//                }
//                else if let previousBox = scrollView.subviews[i - 1] as? UIView{
//                    make.left.equalTo(previousBox.snp_right).offset(boxGap)
//                }
//
//                if i == 5 {
//                    // 这里设定最右侧的box，距离contentSize的右边界距离
//                    // The the distance from the box on the right side
//                    // to the right side of contentSize
//                    make.right.equalTo(scrollView)
//                }
//            })
//        }
//    }
//}
//
//// MARK: - 用Container实现自动布局
//extension TaskViewController {
//    /**
//     The key is to set clipsToBounds to false and make the width of frame of scrollview less than the width of screen.
//     Usually the width now is padding + subviewWidth
//     关键在于clipsToBounds设置为no，scrollview自身的width小于屏幕宽度，一般设置为padding + 子视图width
//     */
//    func layoutWithCustomePageSize() {
//        scrollView.bounces = false
//        view.addSubview(scrollView)
//        scrollView.isPagingEnabled = true
//        scrollView.clipsToBounds = false   // *important!* //
//        scrollView.backgroundColor = UIColor.yellow
//        scrollView.addSubview(containerView)
//
//        containerView.backgroundColor = scrollView.backgroundColor
//
//        /**
//         *  对scrollView添加约束
//         *  Add constraints to scrollView
//         */
//        scrollView.snp_makeConstraints { (make) -> Void in
//            make.center.equalTo(view.snp_center)
//            make.width.equalTo(boxWidth + boxGap)   // *important!* //
//            make.height.equalTo(topScrollHeight)
//        }
//
//        /**
//         *  对containerView添加约束，接下来只要确定containerView的宽度即可
//         *  Add constraints to containerView, the only thing we will do
//         *  is to define the width of containerView
//         */
//        containerView.snp_makeConstraints { (make) -> Void in
//            make.edges.equalTo(scrollView)
//            make.height.equalTo(topScrollHeight)
//        }
//
//        for i in 0...40 {
//            let box = UIView()
//            box.backgroundColor = UIColor.red
//            containerView.addSubview(box)
//
//            box.snp_makeConstraints({ (make) -> Void in
//                make.top.height.equalTo(containerView)  // 确定top和height之后，box在竖直方向上完全确定
//                make.width.equalTo(boxWidth)
//                if i == 0 {
//                    make.left.equalTo(containerView).offset(boxGap / 2)
//                }
//                else if let previousBox = containerView.subviews[i - 1] as? UIView{
//                    make.left.equalTo(previousBox.snp_right).offset(boxGap)
//                }
//                if i == 40 {
//                    containerView.snp_makeConstraints({ (make) -> Void in
//                        // 这一步是关键，它确定了container的宽度，也就确定了contentSize
//                        // This step is very important, it set the width of container, so the
//                        // contentSize is available now
//                        make.right.equalTo(box).offset(boxGap / 2)
//                    })
//                }
//            })
//        }
//    }
//}
//
