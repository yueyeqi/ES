//
//  ShopViewController.swift
//  es_club
//
//  Created by lilinzhe on 2017/6/15.
//  Copyright © 2017年 岳业骑. All rights reserved.
//

import UIKit

class GoodsType: NSObject {
    var id = 0
    var img = ""
    var name = ""
    
    override init() {
        
    }
    
    init(id: NSInteger,img: String,name: String) {
        self.id = id
        self.img = img
        self.name = name
    }
}

class GoodsInfo: NSObject {
    var id = ""
    var name = ""
    var cover = ""
    var month_sale = 0
    var buy_num = 0
    var price: Float = 0
    var type_id = ""
    
    override init() {
        
    }
    
    init(type_id:String,id:String,name:String, cover:String,month_sale:NSInteger,price:Float){
        self.id = id
        self.type_id = type_id
        self.name = name
        self.cover = cover
        self.month_sale = month_sale
        self.price = price
    }
    
    init(type_id:String){
        self.type_id = type_id
    }
}

class ShopViewController: UIViewController {
    
    let LEFT_CELL_ID = "leftcell"
    let RIGHT_CELL_ID = "rightcell"
    let BOTTOM_HEIGHT: CGFloat = 50
    let CELL_PADDING: CGFloat = 10
    let TOP_HEIGHT: CGFloat = 44
    
    var topView  = UIView()
    var typeArray: [GoodsType]!
    var middleView = UIView()
    var bottomView = UIView()
    var goodsArray: [Array<GoodsInfo>]!
    var leftTableView: UITableView!
    var rigthTableView: UITableView!
    var selectGoodsArray = [GoodsInfo]()
    
    var currentSelectTypeIndex = 0
    var isAutoScroll = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        goodsArray = [Array<GoodsInfo>]()
        //初始化测试数据
        typeArray = [
            GoodsType(id: 0,img: "es1",name: "热销"),
            GoodsType(id: 1,img: "es2",name: "酒水"),
            GoodsType(id: 2,img: "es3",name: "水果"),
            GoodsType(id: 3,img: "es4",name: "人偶")
        ]
        
        for i in 0 ..< typeArray.count {
            let type_id = "\(typeArray[i].id)"
            var goods_arr = [GoodsInfo]()
            for _ in 0 ..< 20 {
                goods_arr.append(GoodsInfo(type_id:"\(type_id)",id:"10",name:"小西瓜",cover:"es1",month_sale:20,price:1000.00))
            }
            goodsArray.append(goods_arr)
        }
        
        loadTopView()
        
        loadMiddleView()
        
        loadBottomView()
        
        

       
    }
    
    func loadMiddleView(){
        view.addSubview(middleView)
        middleView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(view)
            make.top.equalTo(topView.snp.bottom)
        }
        configTableViews()
    }
    
    func configTableViews() {
        leftTableView = UITableView(frame:.zero,style: .plain)
        leftTableView.backgroundColor = UIColor().hexStringToColor(hexString: "#d9d9d9")
        leftTableView.delegate = self
        leftTableView.dataSource = self
        leftTableView.separatorStyle = .none
        leftTableView.estimatedRowHeight = 60
        leftTableView.rowHeight = UITableViewAutomaticDimension
        leftTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: BOTTOM_HEIGHT, right: 0)
        leftTableView.register(ShopTypeCell.classForCoder(), forCellReuseIdentifier: LEFT_CELL_ID)
        leftTableView.showsVerticalScrollIndicator = false
        leftTableView.showsHorizontalScrollIndicator = false
        middleView.addSubview(leftTableView)
        leftTableView.snp.makeConstraints { (make) in
            make.top.left.bottom.equalTo(middleView)
            make.width.equalTo(100)
        }
        
        rigthTableView = UITableView(frame:.zero,style:.plain)
        rigthTableView.backgroundColor = UIColor.groupTableViewBackground
        rigthTableView.delegate = self
        rigthTableView.dataSource = self
        rigthTableView.separatorStyle = .none
        rigthTableView.estimatedRowHeight = 120
        rigthTableView.rowHeight = UITableViewAutomaticDimension
        rigthTableView.showsHorizontalScrollIndicator = false
        rigthTableView.showsVerticalScrollIndicator = false
        rigthTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: BOTTOM_HEIGHT, right: 0)
        rigthTableView.register(ShopGoodsCell.classForCoder(), forCellReuseIdentifier: RIGHT_CELL_ID)
        middleView.addSubview(rigthTableView)
        rigthTableView.snp.makeConstraints { (make) in
            make.top.right.bottom.equalTo(middleView)
            make.left.equalTo(leftTableView.snp.right)
        }
        
        leftTableView.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .top)
    }
    
    func loadTopView(){
        topView.backgroundColor = UIColor.orange;
        view.addSubview(topView)
        topView.snp.makeConstraints({ (make) in
            make.top.left.right.equalTo(view)
            make.height.equalTo(TOP_HEIGHT)
        })
        
        let label = UILabel()
        label.text = "点菜"
        label.textColor = UIColor.white
        label.textAlignment = NSTextAlignment.center
        topView.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.edges.equalTo(topView.snp.edges)
        }
        
    }
    
    func loadBottomView(){
        bottomView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        view.addSubview(bottomView)
        bottomView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(view)
            make.height.equalTo(BOTTOM_HEIGHT)
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ShopViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == leftTableView {
            return typeArray.count
        }else {
            tableView.scrollsToTop = true
            return goodsArray[section].count
        }
    
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == leftTableView {
            return 1
        }else{
            return goodsArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == leftTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: LEFT_CELL_ID, for: indexPath) as! ShopTypeCell
            cell.updateData(model: typeArray[indexPath.row])
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: RIGHT_CELL_ID, for: indexPath) as! ShopGoodsCell
            cell.updateData(model: goodsArray[indexPath.section][indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView == rigthTableView {
           return typeArray[section].name
        }else{
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == leftTableView {
            return 0
        }else{
            return 26
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == leftTableView {
            
            isAutoScroll = true
            rigthTableView.scrollToRow(at: IndexPath(row: 0, section:indexPath.row), at: .top, animated: true)
            
            
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("\(decelerate)")
        isAutoScroll = false
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let s = rigthTableView.indexPathsForVisibleRows?[0].section {
            if currentSelectTypeIndex == s || isAutoScroll == true{
                return
            }
            currentSelectTypeIndex = s
            leftTableView.selectRow(at: IndexPath(row: s, section: 0), animated: true, scrollPosition: .top)
        }
    }
}
