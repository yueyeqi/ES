//
//  UIKitEx.swift
//  es_club
//
//  Created by 岳业骑 on 2017/6/6.
//  Copyright © 2017年 岳业骑. All rights reserved.
//

import UIKit

extension UIColor {
    
    public func hexStringToColor(hexString: String) -> UIColor{
        
        var cString: String = hexString.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        
        if cString.characters.count < 6 {
            return UIColor.black
        }
        if cString.hasPrefix("0X") {
            cString = cString.substring(from: cString.index(cString.startIndex, offsetBy: 2))
        }
        if cString.hasPrefix("#") {
            cString = cString.substring(from: cString.index(cString.startIndex, offsetBy: 1))
        }
        if cString.characters.count != 6 {
            return UIColor.black
        }
        
        var range: NSRange = NSMakeRange(0, 2)
        let rString = (cString as NSString).substring(with: range)
        range.location = 2
        let gString = (cString as NSString).substring(with: range)
        range.location = 4
        let bString = (cString as NSString).substring(with: range)
        
        var r: UInt32 = 0x0
        var g: UInt32 = 0x0
        var b: UInt32 = 0x0
        Scanner.init(string: rString).scanHexInt32(&r)
        Scanner.init(string: gString).scanHexInt32(&g)
        Scanner.init(string: bString).scanHexInt32(&b)
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: 1)
        
    }
    
    class func DefalutColor() -> UIColor {return UIColor().hexStringToColor(hexString: "#14191d")}
}

extension UIView {
    static func initWithDashLine(frame: CGRect,color: UIColor,lenght: Int,space: Int) -> UIView {
        let lineView = UIView(frame: frame)
        let shapeLayer = CAShapeLayer()
        shapeLayer.bounds = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        shapeLayer.position = CGPoint(x:frame.width / 2, y:0)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = frame.height
        shapeLayer.lineJoin = kCALineJoinRound
        shapeLayer.lineDashPhase = 0
        shapeLayer.lineDashPattern = [NSNumber(value: lenght), NSNumber(value: space)]
        let path:CGMutablePath = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: frame.height))
        path.addLine(to: CGPoint(x:frame.width, y: frame.height))
        shapeLayer.path = path
        lineView.layer.addSublayer(shapeLayer)
        return lineView
        
    }
}

extension SVProgressHUD {
   static func showMsg(msg: String){
        SVProgressHUD.show(nil, status: msg)
        SVProgressHUD.setDefaultStyle(.dark)
        SVProgressHUD.dismiss(withDelay: 1)
        SVProgressHUD.setCornerRadius(5.0)
    }
}


