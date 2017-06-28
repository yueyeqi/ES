//
//  ShopSelectCell.swift
//  es_club
//
//  Created by lilinzhe on 2017/6/24.
//  Copyright © 2017年 岳业骑. All rights reserved.
//

import UIKit

class ShopSelectCell: UITableViewCell {
    
    var nameLabel = UILabel()
    var moneyLabel = UILabel()
    var addBtn = UIButton(type: .custom)
    var reduceBtn = UIButton(type: .custom)
    var countLabel = UILabel()    
    var opretionBtnClickBlock: ((Int,Int)->())?     //添加/减少商品数量
    var opretionRemoveGoodsBlock: ((String)->())?  //移除商品
    var goodsModel: GoodsModel?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        if !isEqual(nil) {
            //            selectionStyle = .none
            backgroundColor = UIColor.clear
            self.selectionStyle = .none
            contentView.addSubview(nameLabel)
            nameLabel.font = NORMAL_FONT
            nameLabel.snp.makeConstraints({ (make) in
                make.height.equalTo(NORMAL_LABEL_HEIGHT)
                make.top.equalTo(contentView).offset((NORMAL_CELL_HEIGHT - NORMAL_LABEL_HEIGHT) * 0.5)
                make.bottom.equalTo(contentView).offset(-((NORMAL_CELL_HEIGHT - NORMAL_LABEL_HEIGHT) * 0.5))
                make.left.equalTo(contentView).offset(NORMAL_PADDING)
            })
            
            let opretionBgView = UIView()
            contentView.addSubview(opretionBgView)
            opretionBgView.snp.makeConstraints({ (make) in
                make.right.equalTo(contentView).offset(-NORMAL_PADDING)
                make.height.equalTo(NORMAL_PADDING * 3)
                make.width.equalTo(NORMAL_PADDING * 3 * 3)
                make.centerY.equalTo(contentView)
            })
            
            contentView.addSubview(reduceBtn)
            reduceBtn.setTitle("-", for: .normal)
            reduceBtn.tag = 1
            reduceBtn.setTitleColor(UIColor.gray, for: .normal)
            reduceBtn.layer.cornerRadius = 3 * NORMAL_PADDING * 0.5
            reduceBtn.layer.borderWidth = 1
            reduceBtn.layer.borderColor = UIColor.lightGray.cgColor
            reduceBtn.addTarget(self, action: #selector(opretionBtnClick(btn:)), for: .touchUpInside)
            reduceBtn.snp.makeConstraints({ (make) in
                make.top.left.bottom.equalTo(opretionBgView)
                make.width.equalTo(NORMAL_PADDING * 3)
            })
            
            contentView.addSubview(countLabel)
            countLabel.font = NORMAL_FONT
            countLabel.textAlignment = .center
            countLabel.textColor = UIColor.black
            countLabel.snp.makeConstraints({ (make) in
                make.left.equalTo(reduceBtn.snp.right)
                make.top.bottom.width.equalTo(reduceBtn)
            })
            
            contentView.addSubview(addBtn)
            addBtn.tag = 2
            addBtn.layer.cornerRadius = 3 * NORMAL_PADDING * 0.5
            addBtn.clipsToBounds = true
            addBtn.backgroundColor = UIColor.init(red: 6/255, green: 193/255, blue: 174/255, alpha: 1)
            addBtn.addTarget(self, action: #selector(opretionBtnClick(btn:)), for: .touchUpInside)
            addBtn.setTitle("+", for: .normal)
            addBtn.snp.makeConstraints({ (make) in
                make.top.bottom.equalTo(opretionBgView)
                make.left.equalTo(countLabel.snp.right)
                make.right.equalTo(opretionBgView)
            })
            
            
            contentView.addSubview(moneyLabel)
            moneyLabel.font = NORMAL_FONT
            moneyLabel.textAlignment = .right
            moneyLabel.snp.makeConstraints({ (make) in
                make.height.equalTo(NORMAL_LABEL_HEIGHT)
                make.right.equalTo(opretionBgView.snp.left).offset(-NORMAL_PADDING * 0.5)
                make.width.equalTo(NORMAL_LABEL_HEIGHT * 5)
                make.centerY.equalTo(contentView)
            })
            
            let lineView = UIView()
            lineView.backgroundColor = UIColor.lightGray
            contentView.addSubview(lineView)
            lineView.snp.makeConstraints({ (make) in
                make.left.bottom.right.equalTo(contentView)
                make.height.equalTo(0.5)
            })
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func opretionBtnClick(btn: UIButton){
        if let m = goodsModel {
            // type 1 减少  2 添加
            let type = btn.tag
            if btn.tag == 1  {
                if(!m.reduceGoods()){
                    reduceBtn.isHidden = true
                    countLabel.isHidden = true
                    if let b = opretionRemoveGoodsBlock {
                        b(m.id)
                    }
                    print("没有选择此类商品！")
                }
            }else{
                if(!m.addGoods()){
                    print("已达商品购买上限！")
                }
                reduceBtn.isHidden = false
                countLabel.isHidden = false
            }
            countLabel.text = "\(m.buyNum)"
            let money = Float(m.price)! * Float(m.buyNum)
            moneyLabel.text = "￥\(money)"
            if let b = opretionBtnClickBlock {
                b(type,m.buyNum)
            }
        }
    }
    
    func updateData(model: GoodsModel){
        goodsModel = model
        nameLabel.text = model.name
        countLabel.text = "\(model.buyNum)"
        let money = Float(model.price)! * Float(model.buyNum)
        moneyLabel.text = "￥\(money)"
        if model.buyNum > 0 {
            reduceBtn.isHidden = false
            countLabel.isHidden = false
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
