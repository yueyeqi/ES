//
//  GoodsModel.swift
//  es_club
//
//  Created by lilinzhe on 2017/6/20.
//  Copyright © 2017年 岳业骑. All rights reserved.
//

import UIKit

class GoodsModel: NSObject {
    
    var typeId = ""
    var typeName = ""
    var typeIcon = ""
    var id = ""
    var name = ""
    var cover = ""
    var price = ""
    var monthSale = ""
    var buyNum = 0
    var hasBuy = false
    var maxBuyNum = 99
    
    override init() {
        
    }
    
    init(data: JSON){
        if let _id = data["id"].string {
            id = _id
        }
        if let _name = data["name"].string {
            name = _name
        }
        if let _cover = data["cover"].string{
            cover = _cover
        }
        if let _price = data["price"].string {
            price = _price
        }
        if let _monthSale = data["month_sale"].string{
            monthSale = _monthSale
        }
    }
    
    init(typeId:String,typeName:String,typeIcon:String){
        self.typeId = typeId
        self.typeName = typeName
        self.typeIcon = typeIcon
    }
    
    init(id:String,name:String,cover:String,price:String,monthSale:String){
        self.id = id
        self.name = name
        self.cover = cover
        self.price = price
        self.monthSale = monthSale
    }
    
    func isHasBuy() -> Bool {
        return hasBuy
    }
    
    func addGoods() -> Bool{
           buyNum += 1
        if buyNum >= maxBuyNum {
            buyNum = maxBuyNum
            return false
        }
        return true
    }
    
    func reduceGoods() -> Bool {
           buyNum -= 1
        if buyNum <= 0 {
            buyNum = 0
            return false
        }
        return true
    }
}
