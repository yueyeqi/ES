//
//  ShopSelectView.swift
//  es_club
//
//  Created by lilinzhe on 2017/6/15.
//  Copyright © 2017年 岳业骑. All rights reserved.
//

import UIKit

class ShopSelectView: UIView {
    
    var tableView = UITableView()
    var clearBtn = UIButton(type: .custom)
    let HEADER_HEIGHT: CGFloat = 30
    let FOOTER_HEIGHT: CGFloat = 20
    let CELL_ID = "selectcell"
    var selectGoodsModels = [GoodsModel]()
    var clearBtnClickBlock: (()->())?
    var goodsRemoveBlock: (()->())?
    var changeCountBlock: ((Int,Int,String) -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadViews(){
        let headerView = UIView()
        
        headerView.backgroundColor = UIColor.white
        self.addSubview(headerView)
        headerView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self)
            make.height.equalTo(HEADER_HEIGHT)
        }
        
        headerView.addSubview(clearBtn)
        clearBtn.backgroundColor = NORMAL_COLOR
        clearBtn.layer.cornerRadius = 3.0
        clearBtn.clipsToBounds = true
        clearBtn.titleLabel?.font = NORMAL_SMALL_FONT
        clearBtn.setTitle("清空购物车", for: .normal)
        clearBtn.addTarget(self, action: #selector(clearBtnClick), for: .touchUpInside)
        clearBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(headerView)
            make.width.equalTo(FOOTER_HEIGHT * 4)
            make.height.equalTo(HEADER_HEIGHT - 5)
            make.right.equalTo(headerView).offset(-10)
        }
        
        configTableView()
        self.addSubview(tableView)
        tableView.snp.updateConstraints { (make) in
            make.top.equalTo(headerView.snp.bottom)
            let h = selectGoodsModels.count <= 5 ? (CGFloat(selectGoodsModels.count) * NORMAL_CELL_HEIGHT) : (5 * NORMAL_CELL_HEIGHT)
            make.height.equalTo(h)
            make.left.right.equalTo(headerView)
        }
        
        let lineView = UIView()
        lineView.backgroundColor = UIColor.lightGray
        self.addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.right.left.top.equalTo(tableView)
            make.height.equalTo(0.5)
        }
        
        let footerView = UIView()
        footerView.backgroundColor = UIColor.white
        self.addSubview(footerView)
        footerView.snp.makeConstraints { (make) in
            make.top.equalTo(tableView.snp.bottom)
            make.height.equalTo(FOOTER_HEIGHT)
            make.left.right.bottom.equalTo(self)
        }
    }
    
    func configTableView(){
        tableView = UITableView(frame:.zero,style: .plain)
        tableView.backgroundColor = UIColor.white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(ShopSelectCell.classForCoder(), forCellReuseIdentifier: CELL_ID)
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
    }

    func clearBtnClick(){
        if let b = clearBtnClickBlock {
            b()
        }
    }
    
    func updateUIBySelectModels(models: [GoodsModel]){
        selectGoodsModels = models
        tableView.reloadData()
    }
    
    func updateTableViewHeight(){
        tableView.snp.updateConstraints { (make) in
            let h = selectGoodsModels.count <= 5 ? (CGFloat(selectGoodsModels.count) * NORMAL_CELL_HEIGHT) : (5 * NORMAL_CELL_HEIGHT)
            print("更新selectTableView的高度，高度为: \(h)")
            make.height.equalTo(h)
        }
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
extension ShopSelectView: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        updateTableViewHeight()
        return selectGoodsModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath) as! ShopSelectCell
        let goodsModel = selectGoodsModels[indexPath.row]
        cell.updateData(model: selectGoodsModels[indexPath.row])
        cell.opretionBtnClickBlock = { (type,buyNum) in
            if let b = self.changeCountBlock {
                b(type,buyNum,goodsModel.id)
            }
        }
        cell.opretionRemoveGoodsBlock = { goodsId in
            var index = 0
            for (i,goods) in self.selectGoodsModels.enumerated() {
                if goods.id == goodsId {
                    index = i
                    break
                }
            }
            self.selectGoodsModels.remove(at: index)
            self.tableView.reloadData()
            if let m = self.goodsRemoveBlock {
                m()
            }
        }
        return cell
        
    }
}
