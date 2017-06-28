//
//  PayTypeModel.swift
//  es_club
//
//  Created by lilinzhe on 2017/6/27.
//  Copyright © 2017年 岳业骑. All rights reserved.
//

import Foundation

class PayTypeModel: NSObject {
    
    var id = 0
    var name = ""
    var icon = ""
    var isSelect = false
    
    override init() {
        
    }
    
    init(id:Int,icon:String,name:String){
        self.id = id
        self.name = name
        self.icon = icon
    }
}
