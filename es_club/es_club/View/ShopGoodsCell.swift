//
//  ShopGoodsCell.swift
//  es_club
//
//  Created by lilinzhe on 2017/6/17.
//  Copyright © 2017年 岳业骑. All rights reserved.
//

import UIKit

class ShopGoodsCell: UITableViewCell {
    
    let CELL_HEIGHT: CGFloat = 120
    let COVER_WIDTH: CGFloat = 80
    
    var nameLabel = UILabel()
    var coverView = UIImageView()
    var monthSaleLabel = UILabel()
    var priceLabel = UILabel()
    var addButton = UIButton(type: .custom)
    var reduceButton = UIButton(type: .custom)
    var currentCountLabel = UILabel()
    var btnClickBlock: ((Int,Int)->())?
    
    var goodsInfoModel: GoodsModel?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        if !isEqual(nil){
            selectionStyle = .none
            contentView.addSubview(coverView)
            coverView.layer.cornerRadius = 3
            coverView.clipsToBounds = true
            coverView.snp.makeConstraints({ (make) in
                make.top.left.equalTo(contentView).offset(NORMAL_PADDING)
                make.width.height.equalTo(COVER_WIDTH)
                make.bottom.equalTo(contentView).offset(-(CELL_HEIGHT - COVER_WIDTH - NORMAL_PADDING))
            })
            
            contentView.addSubview(nameLabel)
            nameLabel.font = NORMAL_FONT
            nameLabel.snp.makeConstraints({ (make) in
                make.top.equalTo(contentView).offset(NORMAL_PADDING)
                make.left.equalTo(coverView.snp.right).offset(CGFloat(NORMAL_PADDING) * 0.5)
                make.right.equalTo(contentView).offset(-NORMAL_PADDING)
                make.height.equalTo(NORMAL_LABEL_HEIGHT)
                
            })
            
            //选择购买商品数量UI
            let countBgView = UIView()
            contentView.addSubview(countBgView)
//            countBgView.backgroundColor = UIColor.blue
            countBgView.snp.makeConstraints({ (make) in
                make.bottom.equalTo(contentView).offset(-NORMAL_PADDING)
                make.right.equalTo(contentView).offset( -NORMAL_PADDING)
                make.height.equalTo(3 * NORMAL_PADDING)
                make.width.equalTo(9 * NORMAL_PADDING)
            })
            
            countBgView.addSubview(reduceButton)
            reduceButton.tag = 1
            reduceButton.layer.cornerRadius = CGFloat(3 * NORMAL_PADDING) * 0.5
            reduceButton.layer.borderWidth = 1
            reduceButton.layer.borderColor = UIColor.lightGray.cgColor
            reduceButton.setTitle("-", for: .normal)
            reduceButton.setTitleColor(UIColor.gray, for: .normal)
            reduceButton.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
            reduceButton.snp.makeConstraints({ (make) in
                make.top.left.bottom.equalTo(countBgView)
                make.width.equalTo(3 * NORMAL_PADDING)
            })
            
            countBgView.addSubview(currentCountLabel)
            currentCountLabel.textAlignment = .center
            currentCountLabel.font = NORMAL_FONT
            currentCountLabel.snp.makeConstraints({ (make) in
                make.top.bottom.equalTo(countBgView)
                make.left.equalTo(reduceButton.snp.right)
                make.width.equalTo(reduceButton)
            })
            
            countBgView.addSubview(addButton)
            addButton.tag = 2
            addButton.layer.cornerRadius = CGFloat(3 * NORMAL_PADDING) * 0.5
            addButton.setTitle("+", for: .normal)
            addButton.backgroundColor = NORMAL_COLOR
            addButton.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
            addButton.snp.makeConstraints({ (make) in
                make.width.top.bottom.equalTo(currentCountLabel)
                make.left.equalTo(currentCountLabel.snp.right)
                make.right.equalTo(countBgView)
            })
            
            let lineView = UIView()
            lineView.backgroundColor = NORMAL_COLOR_GRAY
            contentView.addSubview(lineView)
            lineView.snp.makeConstraints({ (make) in
                make.left.right.bottom.equalTo(contentView)
                make.height.equalTo(0.5)
            })
            
            contentView.addSubview(priceLabel)
//            priceLabel.backgroundColor = UIColor.red
            priceLabel.font = UIFont.systemFont(ofSize: 17,weight:5)
            priceLabel.textColor = NORMAL_COLOR
            priceLabel.snp.makeConstraints({ (make) in
                make.bottom.equalTo(contentView).offset(-NORMAL_PADDING)
                make.left.height.equalTo(nameLabel)
                make.right.equalTo(countBgView.snp.left)
            })
            
            contentView.addSubview(monthSaleLabel)
            monthSaleLabel.textColor = UIColor.gray
            monthSaleLabel.font = NORMAL_SMALL_FONT
            monthSaleLabel.snp.makeConstraints({ (make) in
                make.left.right.equalTo(nameLabel)
                make.top.equalTo(nameLabel.snp.bottom).offset(NORMAL_PADDING * 0.5)
                make.bottom.equalTo(priceLabel.snp.top).offset(NORMAL_PADDING * 0.5)
            })
            

        }
    }
    
    func btnClick(btn: UIButton){
        if let m = goodsInfoModel {
            // type 1 减少  2 添加
            let type = btn.tag
            if btn.tag == 1  {
                if(!m.reduceGoods()){
                    reduceButton.isHidden = true
                    currentCountLabel.isHidden = true
                    print("没有选择此类商品！")
                }
            }else{
                if(!m.addGoods()){
                    print("已达商品购买上限！")
                }
                reduceButton.isHidden = false
                currentCountLabel.isHidden = false
            }
            currentCountLabel.text = "\(m.buyNum)"
            if let b = btnClickBlock {
                b(type,m.buyNum)
            }
        }
        
        
    }
    
    func updateData(model: GoodsModel){
        goodsInfoModel = model
        coverView.image = UIImage(named: goodsInfoModel!.cover)
        nameLabel.text = goodsInfoModel!.name
        monthSaleLabel.text = "月售\(goodsInfoModel!.monthSale)"
        priceLabel.text = "￥\(goodsInfoModel!.price)"
        currentCountLabel.text = "\(goodsInfoModel!.buyNum)"
        if goodsInfoModel!.buyNum == 0 {
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
