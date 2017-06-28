//
//  ShopViewController.swift
//  es_club
//
//  Created by lilinzhe on 2017/6/15.
//  Copyright © 2017年 岳业骑. All rights reserved.
//

import UIKit

class ShopViewController: UIViewController {
    
    let LEFT_CELL_ID = "leftcell"
    let RIGHT_CELL_ID = "rightcell"
    let BOTTOM_HEIGHT: CGFloat = 50
    let TOP_HEIGHT: CGFloat = 44
    let SELECT_CELL_HEIGHT: CGFloat = 44
    let SELECT_HEADER_HEIGHT: CGFloat = 30
    let SELECT_FOOTER_HEIGHT: CGFloat = 20
    
    var topView  = UIView()
    var middleView = UIView()
    var bottomView = UIView()
    var goodsArray: [GoodsModel] = []
    var leftTableView: UITableView!
    var rigthTableView: UITableView!
    var selectView: ShopSelectView!
    
    //botomview -sub-views
    var bottomCarImgView = UIImageView()
    var bottomNumLabel = UILabel()
    var bottomTotalMoneyLabel = UILabel()
    var bottomCommitBtn = UIButton(type: .custom)
    var maskBtn = UIButton(type: .custom)
    
    var total_count = 0 //商品总份数
    var goodsTypes: [(id:String,name:String,icon:String)]!
    
    var currentSelectTypeIndex = 0
    var isAutoScroll = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        goodsTypes = [
            (id:"1",icon:"es1",name:"热销"),
            (id:"2",icon:"es2",name:"酒水"),
            (id:"3",icon:"es3",name:"水果"),
            (id:"4",icon:"es4",name:"人偶")
            ]
        var goodsid = 0
        for g in goodsTypes {
            for _ in 0 ..< 10 {
                let goods = GoodsModel(typeId: g.id, typeName: g.name, typeIcon: g.icon)
                goodsid += 1
                goods.id = "\(goodsid)"
                goods.cover = "es3"
                goods.name = "大西瓜"
                goods.monthSale = "22"
                goods.price = "122"
                goodsArray.append(goods)
            }
        }
        
        loadTopView()
        
        loadMiddleView()
        
        loadBottomView()
        
        configSelectView()
    
    }
    
    func configSelectView(){
        
        maskBtn.addTarget(self, action: #selector(maskBtnClick), for: .touchUpInside)
        maskBtn.isHidden = true
        maskBtn.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        view.insertSubview(maskBtn, belowSubview: bottomView)
        maskBtn.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        selectView = ShopSelectView.init(frame: CGRect(x: 1, y: 1, width: 1, height: 1))
        selectView.goodsRemoveBlock = { _ in
            self.updateSelectViewUI()
        }
        selectView.clearBtnClickBlock = { _ in
            let gs = self.getSelectGoodsModels()
            for g in gs {
                g.buyNum = 0
            }
            self.total_count = 0
            self.updateTotalMoney()
            self.hideSeletView()
            self.rigthTableView.reloadData()
        }
        selectView.changeCountBlock = { (type,buyNum,goodsId) in
            for g in self.goodsArray {
                if g.id == goodsId {
                    g.buyNum = buyNum
                }
            }
            if type == 1 {
                self.total_count -= 1
            }else {
                self.total_count += 1
            }
            self.rigthTableView.reloadData()
            self.updateTotalMoney()
            
            if self.getSelectGoodsModels().count == 0 {
                self.hideSeletView()
            }
            
        }
        view.insertSubview(selectView, belowSubview: bottomView)
    }
    
    func updateSelectViewUI() {
        let goodsModels = getSelectGoodsModels()
        if goodsModels.count > 0 {
            showSelectView()
            selectView.updateUIBySelectModels(models: goodsModels)
            selectView.snp.updateConstraints({ (make) in
                make.bottom.equalTo(bottomView.snp.top)
                make.height.equalTo(SELECT_CELL_HEIGHT * CGFloat(goodsModels.count) + SELECT_HEADER_HEIGHT + SELECT_FOOTER_HEIGHT)
                make.left.right.equalTo(view)
            })
        }else {
            hideSeletView()
        }
    }
    
    func hideSeletView(){
        selectView.isHidden = true
        maskBtn.isHidden = true
    }
    
    func showSelectView(){
        maskBtn.isHidden = false
        selectView.isHidden = false
    }
    
    func maskBtnClick(){
        maskBtn.isHidden = true
        selectView.isHidden = true
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
        label.font = NORMAL_FONT
        label.text = "点菜"
        label.textColor = UIColor.white
        label.textAlignment = NSTextAlignment.center
        topView.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.edges.equalTo(topView.snp.edges)
        }
    }
    
    func loadBottomView(){
        view.addSubview(bottomView)
        bottomView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(view)
            make.height.equalTo(BOTTOM_HEIGHT)
        }
        //毛玻璃效果
        let effect = UIBlurEffect(style: .dark)
        let effectView = UIVisualEffectView.init(effect: effect)
        bottomView.addSubview(effectView)
        effectView.snp.makeConstraints { (make) in
            make.edges.equalTo(bottomView.snp.edges)
        }
        
        let gr = UITapGestureRecognizer.init(target: self, action: #selector(carClick))
        bottomCarImgView.addGestureRecognizer(gr)
        bottomCarImgView.image = UIImage(named: "es2")
        bottomCarImgView.layer.cornerRadius = BOTTOM_HEIGHT * 0.5
        bottomCarImgView.clipsToBounds = true
        bottomCarImgView.isUserInteractionEnabled = true
        bottomView.addSubview(bottomCarImgView)
        bottomCarImgView.snp.makeConstraints { (make) in
            make.left.equalTo(bottomView).offset(NORMAL_PADDING)
            make.bottom.equalTo(bottomView).offset(-NORMAL_PADDING * 0.5)
            make.width.height.equalTo(BOTTOM_HEIGHT)
        }
    
        
        bottomNumLabel.isHidden = true
        bottomNumLabel.textColor = UIColor.white
        bottomNumLabel.backgroundColor = UIColor.orange
        bottomNumLabel.font = UIFont.systemFont(ofSize: 8)
        bottomNumLabel.layer.cornerRadius = 15 * 0.5
        bottomNumLabel.clipsToBounds = true
        bottomNumLabel.textAlignment = NSTextAlignment.center
        bottomView.addSubview(bottomNumLabel)
        bottomNumLabel.snp.makeConstraints { (make) in
            make.top.right.equalTo(bottomCarImgView).offset(0)
            make.width.height.equalTo(15)
        }
        
        bottomTotalMoneyLabel.text = "￥0"
        bottomTotalMoneyLabel.font = UIFont.systemFont(ofSize: 17, weight: 3)
        bottomTotalMoneyLabel.textColor = UIColor.init(red: 6/255, green: 193/255, blue: 174/255, alpha: 1)
        bottomView.addSubview(bottomTotalMoneyLabel)
        bottomTotalMoneyLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(bottomView)
            make.left.equalTo(bottomCarImgView.snp.right).offset(NORMAL_PADDING)
        }
        bottomCommitBtn.addTarget(self, action: #selector(commitBtnClick), for: .touchUpInside)
        bottomCommitBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: 5)
        bottomCommitBtn.backgroundColor = UIColor.init(red: 6/255, green: 193/255, blue: 174/255, alpha: 1)
        bottomCommitBtn.setTitle("去结算", for: .normal)
        bottomCommitBtn.setTitleColor(UIColor.white, for: .normal)
        bottomView.addSubview(bottomCommitBtn)
        bottomCommitBtn.snp.makeConstraints { (make) in
            make.top.bottom.right.equalTo(bottomView)
            make.width.equalTo(100)
        }
    }
    
    func carClick(){
        print("点击购物车")
        updateSelectViewUI()
        
        
    }
    
    func commitBtnClick(){
        print("共点餐\(total_count)份")
        if total_count == 0 {
            print("请点餐！")
            return
        }
        let sovc = ShopOrderViewController()
        sovc.goodsModels = getSelectGoodsModels()
        navigationController?.pushViewController(sovc, animated: true)
    }
        
    func getGoodsArrayByTypeId(typeId: String) -> Array<GoodsModel>{
        
        var gArray = [GoodsModel]()
        for g in goodsArray {
            if g.typeId == typeId {
                gArray.append(g)
            }
        }
        return gArray
    }
    
    func calculateTotalMoney() -> Float{
        var totalMoney:Float = 0
        for g in goodsArray {
            let p = g.price == "" ? 0 : Float(g.price)!
            totalMoney += p * Float(g.buyNum)
        }
        return totalMoney
    }
    
    func updateTotalMoney(){
        
        let m = calculateTotalMoney()
        bottomTotalMoneyLabel.text = "￥\(m)"
        bottomNumLabel.text = "\(total_count)"
        if m == 0 {
            bottomNumLabel.isHidden = true
        }
    }
    
    func getSelectGoodsModels() -> [GoodsModel] {
        var goodsModels = [GoodsModel]()
        for g in goodsArray{
            if g.buyNum > 0 {
                goodsModels.append(g)
            }
        }
        return goodsModels
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
            return goodsTypes.count
        }else {
            tableView.scrollsToTop = true
            return getGoodsArrayByTypeId(typeId: goodsTypes[section].id).count
        }
    
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == leftTableView {
            return 1
        }else{
            return goodsTypes.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == leftTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: LEFT_CELL_ID, for: indexPath) as! ShopTypeCell
            cell.updateData(typeIcon: goodsTypes[indexPath.row].icon, typeName: goodsTypes[indexPath.row].name)
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: RIGHT_CELL_ID, for: indexPath) as! ShopGoodsCell

            let m = getGoodsArrayByTypeId(typeId: goodsTypes[indexPath.section].id)[indexPath.row]
                cell.updateData(model: m)
                cell.btnClickBlock = { (clickType,buyNum) in
                    m.buyNum = buyNum
                    if clickType == 2 {
                        //添加
                        self.total_count += 1
                    }else {
                        self.total_count -= 1
                    }
                    if self.total_count <= 0 {
                        self.bottomNumLabel.isHidden = true
                    }else{
                        self.bottomNumLabel.isHidden = false
                    }
                    self.updateTotalMoney()
                    UIView.animate(withDuration: 0.5, animations: {
                        self.bottomCarImgView.transform = CGAffineTransform.init(scaleX: 1.15, y: 1.15)
                    }, completion: { (finish) in
                        self.bottomCarImgView.transform = CGAffineTransform.identity
                    })
                }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView == rigthTableView {
           return goodsTypes[section].name
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
