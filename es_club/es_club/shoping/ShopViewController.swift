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

class ShopViewController: UIViewController {
    
    let TYPE_ROW_HEIGHT = 44
    let TYPE_WIDTH = 100
    let TYPE_ICON_WIDTH = 15
    var topView  = UIView()
    var tableViews = [UITableView]()
//    var segmentCtr: HMSegmentedControl?
    var indexSelect: Int = 0
    var typeArray: [GoodsType]!
    var bottomView = UIView()
    override func viewDidLoad() {
        super.viewDidLoad()
        typeArray = [
            GoodsType(id: 0,img: "es1",name: "热销"),
            GoodsType(id: 1,img: "es2",name: "酒水"),
            GoodsType(id: 2,img: "es3",name: "水果"),
            GoodsType(id: 3,img: "es4",name: "人偶")
        ]
        
        loadTopView()

        view.addSubview(bottomView)
        bottomView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(view)
            make.top.equalTo(topView.snp.bottom)
        }
        
        loadLeftView()

        // Do any additional setup after loading the view.
    }
    
    func loadTopView(){
        topView.backgroundColor = UIColor.orange;
        view.addSubview(topView)
        topView.snp.makeConstraints({ (make) in
            make.top.left.right.equalTo(view)
            make.height.equalTo(44)
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
    
    func loadLeftView(){
        let leftView = UIView()
        leftView.backgroundColor = UIColor.purple;
        bottomView.addSubview(leftView)
        leftView.snp.makeConstraints { (make) in
            make.left.top.bottom.equalTo(bottomView)
            make.width.equalTo(TYPE_WIDTH)
        }
        var last_view: UIView?
        for (index,type) in typeArray.enumerated() {
            let sub_view = UIView()
            sub_view.backgroundColor = UIColor.blue
            leftView.addSubview(sub_view)
            sub_view.snp.makeConstraints({ (make) in
                if index == 0 {
                    make.top.equalTo(leftView)
                }else{
                   make.top.equalTo(last_view!.snp.bottom)
                }
                make.left.right.equalTo(leftView)
                make.height.equalTo(TYPE_ROW_HEIGHT)
            })
            last_view = sub_view
            
            let imgView = UIImageView()
            imgView.image = UIImage(named:type.img)
            sub_view.addSubview(imgView)
            imgView.snp.makeConstraints({ (make) in
                make.height.width.equalTo(TYPE_ICON_WIDTH)
                make.centerY.equalTo(sub_view)
                make.left.equalTo(sub_view).offset(TYPE_ICON_WIDTH)
            })
            
            let label = UILabel()
            label.textAlignment = .center
            label.text = type.name
            label.textColor = UIColor.black
            sub_view.addSubview(label)
            label.snp.makeConstraints({ (make) in
                make.left.equalTo(imgView.snp.right).offset(-TYPE_ICON_WIDTH)
                make.centerY.equalTo(imgView)
                make.right.equalTo(sub_view)
            })
            
            let sub_btn = UIButton(type:.custom)
            sub_btn.tag = index
            sub_btn.addTarget(self, action: #selector(typeBtnClick(btn:)), for: .touchUpInside)
            sub_view.addSubview(sub_btn)
            sub_btn.snp.makeConstraints({ (make) in
                make.edges.equalTo(sub_view.snp.edges)
            })
            
        }
        
        
    }
    
    func typeBtnClick(btn: UIButton) {
        switch btn.tag {
        case 0:
            print("你点击了\(typeArray[btn.tag].name)")
        case 1:
            print("你点击了\(typeArray[btn.tag].name)")
        case 2:
            print("你点击了\(typeArray[btn.tag].name)")
        case 3:
            print("你点击了\(typeArray[btn.tag].name)")
        default: break
        }
    }
  
    func segmentedControlChangedValue(segCtr: HMSegmentedControl){
        print("你点击了个Segment")
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

//extension ShopViewController: UITableViewDelegate,UITableViewDataSource {
//   
//}
