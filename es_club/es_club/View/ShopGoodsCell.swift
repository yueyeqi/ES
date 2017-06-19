//
//  ShopGoodsCell.swift
//  es_club
//
//  Created by lilinzhe on 2017/6/17.
//  Copyright © 2017年 岳业骑. All rights reserved.
//

import UIKit

class ShopGoodsCell: UITableViewCell {
    
    let CELL_HEIGHT = 120
    let COVER_WIDTH = 80
    let CELL_PADDING = 10
    let CELL_NORMAL_LABEL_HEIGHT = 25
    
    var nameLabel = UILabel()
    var coverView = UIImageView()
    var monthSaleLabel = UILabel()
    var priceLabel = UILabel()
    var addButton = UIButton(type: .custom)
    var reduceButton = UIButton(type: .custom)
    var currentCountLabel = UILabel()
    var btnClickBlock: ((Int,Int)->())?
    
    var goodsInfoModel: GoodsInfo?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        if !isEqual(nil){
            selectionStyle = .none
            contentView.addSubview(coverView)
            coverView.layer.cornerRadius = 3
            coverView.snp.makeConstraints({ (make) in
                make.top.left.equalTo(contentView).offset(CELL_PADDING)
                make.width.height.equalTo(COVER_WIDTH)
                make.bottom.equalTo(contentView).offset(-(CELL_HEIGHT - COVER_WIDTH - CELL_PADDING))
            })
            
            contentView.addSubview(nameLabel)
            nameLabel.snp.makeConstraints({ (make) in
                make.top.equalTo(contentView).offset(CELL_PADDING)
                make.left.equalTo(coverView.snp.right).offset(CGFloat(CELL_PADDING) * 0.5)
                make.right.equalTo(contentView).offset(-CELL_PADDING)
                make.height.equalTo(CELL_NORMAL_LABEL_HEIGHT)
                
            })
            
            //选择购买商品数量UI
            let countBgView = UIView()
            contentView.addSubview(countBgView)
//            countBgView.backgroundColor = UIColor.blue
            countBgView.snp.makeConstraints({ (make) in
                make.bottom.equalTo(contentView).offset(-CELL_PADDING)
                make.right.equalTo(contentView).offset( -CELL_PADDING)
                make.height.equalTo(3 * CELL_PADDING)
                make.width.equalTo(9 * CELL_PADDING)
            })
            
            countBgView.addSubview(reduceButton)
            reduceButton.tag = 1
            reduceButton.layer.cornerRadius = CGFloat(3 * CELL_PADDING) * 0.5
            reduceButton.layer.borderWidth = 1
            reduceButton.layer.borderColor = UIColor.lightGray.cgColor
            reduceButton.setTitle("-", for: .normal)
            reduceButton.setTitleColor(UIColor.gray, for: .normal)
            reduceButton.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
            reduceButton.snp.makeConstraints({ (make) in
                make.top.left.bottom.equalTo(countBgView)
                make.width.equalTo(3 * CELL_PADDING)
            })
            
            countBgView.addSubview(currentCountLabel)
            currentCountLabel.textAlignment = .center
            currentCountLabel.snp.makeConstraints({ (make) in
                make.top.bottom.equalTo(countBgView)
                make.left.equalTo(reduceButton.snp.right)
                make.width.equalTo(reduceButton)
            })
            
            countBgView.addSubview(addButton)
            addButton.tag = 2
            addButton.layer.cornerRadius = CGFloat(3 * CELL_PADDING) * 0.5
            addButton.setTitle("+", for: .normal)
            addButton.backgroundColor = UIColor.init(red: 6/255, green: 193/255, blue: 174/255, alpha: 1)
            addButton.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
            addButton.snp.makeConstraints({ (make) in
                make.width.top.bottom.equalTo(currentCountLabel)
                make.left.equalTo(currentCountLabel.snp.right)
                make.right.equalTo(countBgView)
            })
            
            let lineView = UIView()
            lineView.backgroundColor = UIColor.init(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
            contentView.addSubview(lineView)
            lineView.snp.makeConstraints({ (make) in
                make.left.right.bottom.equalTo(contentView)
                make.height.equalTo(1)
            })
            
            contentView.addSubview(priceLabel)
//            priceLabel.backgroundColor = UIColor.red
            priceLabel.font = UIFont.systemFont(ofSize: 17,weight:5)
            priceLabel.textColor = UIColor.init(red: 6/255, green: 193/255, blue: 174/255, alpha: 1)
            priceLabel.snp.makeConstraints({ (make) in
                make.bottom.equalTo(contentView).offset(-CELL_PADDING)
                make.left.height.equalTo(nameLabel)
                make.right.equalTo(countBgView.snp.left)
            })
            
            contentView.addSubview(monthSaleLabel)
            monthSaleLabel.textColor = UIColor.init(red: 171/255, green: 171/255, blue: 171/255, alpha: 1)
            monthSaleLabel.snp.makeConstraints({ (make) in
                make.left.right.equalTo(nameLabel)
                make.top.equalTo(nameLabel.snp.bottom).offset(Float(CELL_PADDING) * 0.5)
                make.bottom.equalTo(priceLabel.snp.top).offset(Float(CELL_PADDING) * 0.5)
            })
            

        }
    }
    
    func btnClick(btn: UIButton){
        if let m = goodsInfoModel {
            
            // type 0 减少  1 添加
            var type = 0
            if btn.tag == 1  {
                type = 0
                //减少商品
                m.buy_num -= 1
                if m.buy_num <= 0 {
                    m.buy_num = 0
                    reduceButton.isHidden = true
                    currentCountLabel.isHidden = true
                    if let b = btnClickBlock {
                        b(m.buy_num,type)
                    }
                    return
                }
            }else{
                type = 1
                //添加商品
                if m.buy_num == 99 {
                    print("已达商品购买上限！")
                    return
                }
                m.buy_num += 1
                reduceButton.isHidden = false
                currentCountLabel.isHidden = false
            }
            currentCountLabel.text = "\(m.buy_num)"
            if let b = btnClickBlock {
                b(m.buy_num,type)
            }
        }
        
        
    }
    
    func updateData(model: GoodsInfo){
        goodsInfoModel = model
        coverView.image = UIImage(named: goodsInfoModel!.cover)
        nameLabel.text = goodsInfoModel!.name
        monthSaleLabel.text = "月售\(goodsInfoModel!.month_sale)"
        priceLabel.text = "￥\(goodsInfoModel!.price)"
        currentCountLabel.text = "\(goodsInfoModel!.buy_num)"
        if goodsInfoModel?.buy_num == 0 {
            reduceButton.isHidden = true
            currentCountLabel.isHidden = true
        }else{
            reduceButton.isHidden = false
            currentCountLabel.isHidden = false
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
