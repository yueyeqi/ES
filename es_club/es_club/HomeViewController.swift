//
//  HomeViewController.swift
//  es_club
//
//  Created by 岳业骑 on 2017/5/31.
//  Copyright © 2017年 岳业骑. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    let tableScrollView: UIScrollView! = UIScrollView()
    var tableViews = [UITableView]()
    var segmentCtr: HMSegmentedControl?
    var indexSelect: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configSegment()
        createTableScrollView()
    }
    
    //设置分段
    func configSegment() {
        segmentCtr = HMSegmentedControl(sectionTitles: ["最新", "活动", "视频"])
        segmentCtr?.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 30)
        segmentCtr?.backgroundColor = UIColor.DefalutColor()

        segmentCtr?.titleTextAttributes = NSDictionary(objects: [UIColor.lightGray, UIFont.systemFont(ofSize: 14)], forKeys: [NSForegroundColorAttributeName as NSCopying, NSFontAttributeName as NSCopying]) as! [AnyHashable : Any]
        
        segmentCtr?.selectedTitleTextAttributes = NSDictionary(object: UIColor.white, forKey: NSForegroundColorAttributeName as NSCopying) as! [AnyHashable : Any]
        
        segmentCtr?.selectionStyle = .arrow
        segmentCtr?.segmentWidthStyle = .fixed
        segmentCtr?.selectionIndicatorLocation = .down
        segmentCtr?.selectionIndicatorColor = UIColor.white
        
        segmentCtr?.addTarget(self, action: #selector(segmentedControlChangedValue(segCtr:)), for: UIControlEvents.valueChanged)
        
        view.addSubview(segmentCtr!)
    }
    
    //设置tableview
    func createTableScrollView() {
        //设置tableScrollView
        self.tableScrollView.delegate = self
        self.tableScrollView.bounces = false
        self.tableScrollView.isPagingEnabled = true
        self.tableScrollView.showsHorizontalScrollIndicator = false
        self.tableScrollView.showsVerticalScrollIndicator = false
        self.view.addSubview(tableScrollView)
        self.tableScrollView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.view).offset(30)
            make.left.equalTo(self.view).offset(0)
            make.right.equalTo(self.view).offset(0)
            make.bottom.equalTo(self.view).offset(0)
        }
        
        self.tableViews.removeAll()
        var next_table: UITableView?
        
        for index in 0 ..< 3 {
            let table = UITableView(frame: CGRect(x:0, y:0, width:0, height:0), style: .grouped)
            table.delegate = self
            table.dataSource = self
            table.backgroundColor = UIColor.groupTableViewBackground
            table.separatorColor = table.backgroundColor
            
            //cell设置
            table.register(UINib(nibName: "homeCell", bundle: nil), forCellReuseIdentifier: "homeCell")
            
            //table header设置
            table.tableHeaderView = configXR()
            
            
            self.tableScrollView.addSubview(table)
            self.tableViews.append(table)
            table.snp.makeConstraints({ (make) -> Void in
                if let last = next_table {
                    make.leading.equalTo(last.snp.trailing)
                }else {
                    make.leading.equalTo(self.tableScrollView.snp.leading)
                }
                make.top.equalTo(self.tableScrollView.snp.top)
                make.bottom.equalTo(self.tableScrollView.snp.bottom)
                make.width.equalTo(self.view)
                make.height.equalTo(self.tableScrollView.snp.height)
                if index == 2 {
                    make.trailing.equalTo(self.tableScrollView.snp.trailing)
                }
            })
            next_table = table
        }
    }

    
    //设置广告滚动
    func configXR() -> UIView {
        let xrView = XRCarouselView(frame: CGRect(x: 0, y: 30, width: view.frame.width, height: 200))
        xrView.imageArray = [#imageLiteral(resourceName: "es1"), #imageLiteral(resourceName: "es2"), #imageLiteral(resourceName: "es3"), #imageLiteral(resourceName: "es4")]
        
        return xrView
    }
    
    //MARK: - segment改变值事件
    func segmentedControlChangedValue(segCtr: HMSegmentedControl) {
        tableScrollView.scrollRectToVisible(tableViews[segCtr.selectedSegmentIndex].frame, animated: true)
        indexSelect = (segmentCtr?.selectedSegmentIndex)! + 1
    }
    

}

//MARK: - ScrollView代理事件
extension HomeViewController: UIScrollViewDelegate {
    
    //ScrollView切换tableview刷新事件
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == tableScrollView {
            let contentOffsetX = scrollView.contentOffset.x
            let index = Int(contentOffsetX/UIScreen.main.bounds.width)
            segmentCtr?.setSelectedSegmentIndex(UInt(index), animated: true)
            indexSelect = (segmentCtr?.selectedSegmentIndex)! + 1
        }
    }
}

//MARK: - TableView代理事件
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell", for: indexPath) as! homeCell
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "newsID", sender: nil)
    }
    
}

