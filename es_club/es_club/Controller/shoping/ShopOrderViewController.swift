//
//  ShopOrderViewController.swift
//  es_club
//
//  Created by lilinzhe on 2017/6/27.
//  Copyright © 2017年 岳业骑. All rights reserved.
//

import UIKit

//订单信息 cell
class OrderCell: UITableViewCell {
    var iconView = UIImageView()
    var nameLabel = UILabel()
    var countLabel = UILabel()
    var moneyLabel = UILabel()
    var goodsModel: GoodsModel!
    
    let ICON_HEIGHT: CGFloat = 80
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        if !isEqual(nil) {
            selectionStyle = .none
            backgroundColor = UIColor().hexStringToColor(hexString: "#efefef")
            contentView.addSubview(iconView)
            iconView.layer.cornerRadius = 3.0
            iconView.clipsToBounds = true
            iconView.snp.makeConstraints({ (make) in
                make.top.equalTo(NORMAL_PADDING)
                make.left.equalTo(NORMAL_PADDING)
                make.height.width.equalTo(ICON_HEIGHT)
                make.bottom.equalTo(-NORMAL_PADDING * 2)
            })
            
            contentView.addSubview(nameLabel)
            nameLabel.font = UIFont.systemFont(ofSize: 15, weight: 3)
            nameLabel.snp.makeConstraints({ (make) in
                make.top.equalTo(iconView)
                make.left.equalTo(iconView.snp.right).offset(NORMAL_PADDING)
                make.height.equalTo(NORMAL_LABEL_HEIGHT)
            })
            
            contentView.addSubview(countLabel)
            countLabel.textColor = UIColor.gray
            countLabel.font = NORMAL_FONT
            countLabel.snp.makeConstraints({ (make) in
                make.top.equalTo(nameLabel.snp.bottom).offset(NORMAL_PADDING * 2)
                make.bottom.equalTo(iconView)
                make.left.equalTo(nameLabel)
            })
            
            contentView.addSubview(moneyLabel)
            moneyLabel.textColor = UIColor.red
            moneyLabel.font = UIFont.systemFont(ofSize: 17, weight: 3)
            moneyLabel.snp.makeConstraints({ (make) in
                make.centerY.equalTo(contentView)
                make.height.equalTo(NORMAL_LABEL_HEIGHT)
                make.right.equalTo(contentView).offset(-NORMAL_PADDING)
            })
            let lineView = UIView()
            lineView.backgroundColor = UIColor.white
            contentView.addSubview(lineView)
            lineView.snp.makeConstraints({ (make) in
                make.left.right.bottom.equalTo(contentView)
                make.height.equalTo(NORMAL_PADDING * 0.5)
            })
        }
    }
    
    func updateData(model: GoodsModel){
        goodsModel = model
        iconView.image = UIImage(named: model.cover)
        nameLabel.text = model.name
        countLabel.text = "X\(model.buyNum)"
        let m = Float(model.buyNum) * Float(model.price)!
        moneyLabel.text = "￥\(m)"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//支付方式 cell
class PayCell: UITableViewCell {
    var iconView = UIImageView()
    var nameLabel = UILabel()
    var selectBtn = UIButton(type: .custom)
    var selectBtnClickBlock: (()->())?
    var lineView = UIView()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        if !isEqual(nil) {
            selectionStyle = .none
            backgroundColor = UIColor().hexStringToColor(hexString: "#efefef")
            contentView.addSubview(iconView)
            iconView.layer.cornerRadius = 3.0
            iconView.clipsToBounds = true
            let h = NORMAL_PADDING * 3
            let p = (NORMAL_CELL_HEIGHT - h) * 0.5
            iconView.snp.makeConstraints({ (make) in
                make.top.equalTo(contentView).offset(p)
                make.bottom.equalTo(contentView).offset(-p)
                make.left.equalTo(NORMAL_PADDING)
                make.height.width.equalTo(h)
            })
            
            contentView.addSubview(nameLabel)
            nameLabel.font = NORMAL_FONT
            nameLabel.snp.makeConstraints({ (make) in
                make.centerY.equalTo(contentView)
                make.left.equalTo(iconView.snp.right).offset(NORMAL_PADDING)
            })
            
            selectBtn.addTarget(self, action: #selector(selectBtnClick), for: .touchUpInside)
            selectBtn.setImage(UIImage(named:"es1"), for: .normal)
            selectBtn.setImage(UIImage(named:"es2"), for: .selected)
            contentView.addSubview(selectBtn)
            selectBtn.snp.makeConstraints({ (make) in
                make.right.equalTo(contentView).offset(-NORMAL_PADDING)
                make.height.width.equalTo(NORMAL_PADDING * 2)
                make.centerY.equalTo(contentView)
            })
            
            lineView = UIView()
            lineView.backgroundColor = NORMAL_COLOR_GRAY
            contentView.addSubview(lineView)
            lineView.snp.makeConstraints({ (make) in
                make.left.right.bottom.equalTo(contentView)
                make.height.equalTo(0.5)
            })
        }
    }
    
    func isHideLine(isHide: Bool) {
        lineView.isHidden = isHide
    }
    
    func updateData(model: PayTypeModel){
        iconView.image = UIImage(named: model.icon)
        nameLabel.text = model.name
        selectBtn.isSelected = model.isSelect
    }
    
    func isSelected(select: Bool) {
        selectBtn.isSelected = select
    }

    func selectBtnClick(){
        selectBtn.isSelected = true
        if let b = selectBtnClickBlock {
            b()
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}





class ShopOrderViewController: UIViewController {
    
    var tableView = UITableView()
    var bottomView = UIView()
    var totalMoneyLabel = UILabel()
    var commitBtn = UIButton(type: .custom)
    var headerView = UIView()
    var payStatusLabel = UILabel()
    let ORDER_CELL_ID = "ordercell"
    let PAY_CELL_ID = "paycell"
    let BOTTOM_HEIGHT: CGFloat = 50
    var payTypeModels: [PayTypeModel]!
    
    var currentPayId = 1        //默认为支付宝
    
    var goodsModels = [GoodsModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "订单提交"
        view.backgroundColor = UIColor.white
        payTypeModels = [
            PayTypeModel(id: 1, icon: "es1" ,name: "支付宝支付"),
            PayTypeModel(id: 2, icon: "es3" ,name: "微信支付")
        ]
        
        configTableView()
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        headerView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: BOTTOM_HEIGHT)
        loadHeaderView()
        tableView.tableHeaderView = headerView
        loadBottomView()
        initData()
        
        // Do any additional setup after loading the view.
    }
    
    func initData() {
        payStatusLabel.text = "待支付"
        totalMoneyLabel.text = "￥\(calculateTotalMoney())"
        
    }
    
    func calculateTotalMoney() -> Float{
        var totalMoney:Float = 0
        for g in goodsModels {
            let p = g.price == "" ? 0 : Float(g.price)!
            totalMoney += p * Float(g.buyNum)
        }
        return totalMoney
    }
    func loadHeaderView(){
        let logoView = UIImageView()
        let LOGO_HEIGHT: CGFloat = 25
        logoView.image = UIImage(named: "es1")
        logoView.layer.cornerRadius = LOGO_HEIGHT * 0.5
        logoView.clipsToBounds = true
        headerView.addSubview(logoView)
        logoView.snp.makeConstraints { (make) in
            make.centerY.equalTo(headerView)
            make.height.width.equalTo(LOGO_HEIGHT)
            make.left.equalTo(NORMAL_PADDING)
        }
        
        let nameLabel = UILabel()
        nameLabel.font = NORMAL_FONT
        nameLabel.text = "e-sports"
        nameLabel.textColor = NORMAL_COLOR_GRAY
        nameLabel.textAlignment = .left
        headerView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(logoView.snp.right).offset(NORMAL_PADDING)
            make.centerY.equalTo(headerView)
        }
    }
    
    func loadBottomView(){
        view.addSubview(bottomView)
        bottomView.backgroundColor = UIColor().hexStringToColor(hexString: "#efefef")
        bottomView.layer.shadowRadius = 2
        bottomView.layer.shadowColor = UIColor.black.cgColor
        bottomView.layer.shadowOffset = CGSize(width: 1, height: 1)
        bottomView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(view)
            make.height.equalTo(BOTTOM_HEIGHT)
        }
        payStatusLabel.font = NORMAL_FONT
        bottomView.addSubview(payStatusLabel)
        payStatusLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(bottomView)
            make.height.equalTo(NORMAL_LABEL_HEIGHT)
            make.left.equalTo(view).offset(NORMAL_PADDING)
        }
        
        totalMoneyLabel.textColor = UIColor.red
        totalMoneyLabel.font = UIFont.systemFont(ofSize: 15, weight: 3)
        bottomView.addSubview(totalMoneyLabel)
        totalMoneyLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(bottomView)
            make.left.equalTo(payStatusLabel.snp.right).offset(NORMAL_PADDING)
        }
        
        bottomView.addSubview(commitBtn)
        commitBtn.addTarget(self, action: #selector(commitBtnClick), for: .touchUpInside)
        commitBtn.backgroundColor = NORMAL_COLOR
        commitBtn.setTitle("提交订单", for: .normal)
        commitBtn.titleLabel?.font = NORMAL_FONT
        commitBtn.snp.makeConstraints { (make) in
            make.top.right.bottom.equalTo(bottomView)
            make.width.equalTo(100)
        }
    }

    func configTableView() {
        tableView = UITableView(frame:.zero,style: .grouped)
        tableView.backgroundColor = UIColor.white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: BOTTOM_HEIGHT, right: 0)
        tableView.register(OrderCell.classForCoder(), forCellReuseIdentifier: ORDER_CELL_ID)
        tableView.register(PayCell.classForCoder(), forCellReuseIdentifier: PAY_CELL_ID)
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
    }

    func cancelPayTypeSelect(){
        for p in payTypeModels {
            p.isSelect = false
        }
    }
    
    func commitBtnClick(){
        print("提交订单")
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

extension ShopOrderViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return goodsModels.count
        }else{
            return payTypeModels.count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ORDER_CELL_ID, for: indexPath) as! OrderCell
            cell.updateData(model: goodsModels[indexPath.row])
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: PAY_CELL_ID, for: indexPath) as! PayCell
            cell.updateData(model: payTypeModels[indexPath.row])
            if indexPath.row == payTypeModels.count - 1 {
                cell.isHideLine(isHide: true)
            }else{
                cell.isHideLine(isHide: false)
            }
            cell.selectBtnClickBlock = { _ in
                self.currentPayId = self.payTypeModels[indexPath.row].id
                self.cancelPayTypeSelect()
                self.payTypeModels[indexPath.row].isSelect = true
                tableView.reloadSections(IndexSet(integer: 1), with: .none)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }else {
            return 30
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let view = UIView()
            view.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 30)
            let leftLabel = UILabel()
            leftLabel.font = UIFont.systemFont(ofSize: 14)
            leftLabel.text = "支付方式"
            leftLabel.textAlignment = .left
            view.addSubview(leftLabel)
            leftLabel.snp.makeConstraints({ (make) in
                make.centerY.equalTo(view)
                make.left.equalTo(view).offset(NORMAL_PADDING)
            })
            
            let rightLabel = UILabel()
            rightLabel.font = UIFont.systemFont(ofSize: 14)
            rightLabel.text = "在线支付"
            rightLabel.textAlignment = .right
            view.addSubview(rightLabel)
            rightLabel.snp.makeConstraints({ (make) in
                make.centerY.equalTo(view)
                make.right.equalTo(view).offset(-NORMAL_PADDING)
            })
            
            return view
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentPayId = payTypeModels[indexPath.row].id
        cancelPayTypeSelect()
        payTypeModels[indexPath.row].isSelect = true
        tableView.reloadSections(IndexSet(integer: 1), with: .none)
    }
}
