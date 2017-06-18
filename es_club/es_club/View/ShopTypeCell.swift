//
//  ShopTypeCell.swift
//  es_club
//
//  Created by lilinzhe on 2017/6/17.
//  Copyright © 2017年 岳业骑. All rights reserved.
//

import UIKit

class ShopTypeCell: UITableViewCell {
    
    let TYPE_ROW_HEIGHT = 60
    let TYPE_WIDTH = 100
    let TYPE_ICON_WIDTH = 16
    let CELL_PADDING = 10
    var iconView = UIImageView()
    var nameLabel = UILabel()
    var goodsTypeModel: GoodsType?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        if !isEqual(nil) {
//            selectionStyle = .none
            backgroundColor = UIColor.clear
            selectedBackgroundView?.backgroundColor = UIColor.white
            contentView.addSubview(iconView)
            iconView.snp.makeConstraints({ (make) in
                make.left.equalTo(contentView).offset(CELL_PADDING)
                make.width.height.equalTo(TYPE_ICON_WIDTH)
                make.centerY.equalTo(contentView)
                make.top.equalTo(contentView).offset( Double(TYPE_ROW_HEIGHT - TYPE_ICON_WIDTH) * 0.5)
                make.bottom.equalTo(contentView).offset( -Double(TYPE_ROW_HEIGHT - TYPE_ICON_WIDTH) * 0.5)
            })
            
            contentView.addSubview(nameLabel)
            nameLabel.snp.makeConstraints({ (make) in
                make.left.equalTo(iconView.snp.right).offset(CELL_PADDING)
                make.centerY.equalTo(contentView)
            })
            
        }
    }
    
    func updateData(model: GoodsType){
        goodsTypeModel = model
        iconView.image = UIImage(named: goodsTypeModel!.img)
        nameLabel.text = goodsTypeModel!.name
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        if selected {
            contentView.backgroundColor = UIColor.white
        }else{
            contentView.backgroundColor = UIColor().hexStringToColor(hexString: "#d9d9d9")
        }
    }

}
