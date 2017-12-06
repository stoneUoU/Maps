//
//  CardView.swift
//  Maps
//
//  Created by test on 2017/10/11.
//  Copyright © 2017年 com.youlu. All rights reserved.
//

import UIKit
class CardView: UIView {
    typealias sendValueClosure = (_ string:String)->Void
    /// 声明一个Closure(闭包)
    var myClosure:sendValueClosure?
    /// 下面这个方法需要传入上个界面的someFunctionThatTakesAClosure函数指针
    func initWithClosure(closure:sendValueClosure?){
        myClosure = closure
    }
    ///
    var imagesView: UIImageView?
    var textLabel : UILabel?
    var btn: UIButton?
    ///
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setView(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// setView
    func setView(frame: CGRect){
        // Shadow
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOpacity = 0.33
        self.layer.shadowOffset = CGSize(width:0, height:1.5)
        self.layer.shadowRadius = 4.0
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
        
        // Corner Radius
        self.layer.cornerRadius = 10.0
        
        // Custom view
        imagesView = UIImageView.init(frame: CGRect(x:5, y:5, width:self.frame.size.width - 10, height:self.frame.size.height / 2))
        imagesView!.backgroundColor = UIColor.white
        self.addSubview(imagesView!)
        
        
        textLabel = UILabel.init(frame: CGRect(x:20, y:imagesView!.frame.size.height + 10, width:120, height:20))
        textLabel!.backgroundColor = UIColor.lightGray
        self.addSubview(textLabel!)
        
        btn = UIButton.init(type: UIButtonType.custom)
        btn?.setTitle("BUTTON", for: UIControlState.normal)
        btn?.frame = CGRect(x:20, y:(textLabel?.frame.origin.y)! + 20 + 10, width:100, height:50)
        self.addSubview(btn!)
        btn?.addTarget(self, action: "btnClick", for: UIControlEvents.touchUpInside)
        
    }
    /// 这里实现了btn点击方法的回调, 回到控制器(VC),可实现跳转
    func btnClick()
    {
        if myClosure != nil{
            self.myClosure!("hello World")
        }
    }
}
