//
//  MineV.swift
//  Centers
//
//  Created by test on 2017/9/30.
//  Copyright © 2017年 com.youlu. All rights reserved.
//
import UIKit

protocol MineVDelegate: class {
    //跳转Sub
    func toSub(mineV : MineV)
    //弹出各种层
    func toAlertView(mineV : MineV)
    //弹出提示框
    func toAlertTip(mineV : MineV)
}
class MineV: UIView {
    weak var mineVDelegate : MineVDelegate?
    var btnSub:UILabel!
    var btnA:UIButton!
    var btnB:UIButton!
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension MineV:UITextFieldDelegate{
    func setupUI(){
        //短信验证码登录
        btnSub = UILabel()
        btnSub.text = "跳入子页面"
        btnSub.textColor = UIColor.colorWithCustom(242,g:72,b:28)
        btnSub.font=UIFont.UiBoldFontSize(size: 18)
        btnSub.textAlignment = .center
        //将label用户交互设为true
        btnSub.isUserInteractionEnabled = true
        let subGes = UITapGestureRecognizer(target: self, action: #selector(self.subJump(_:)))
        btnSub.addGestureRecognizer(subGes)
        addSubview(btnSub);
        btnSub.snp_makeConstraints { (make) in
            make.top.equalTo((ScreenInfo.height - PublicFunc.setHeight(size: 30) - 108)/2)
            make.left.equalTo(0)
            make.width.equalTo(ScreenInfo.width)
            make.height.equalTo(PublicFunc.setHeight(size: 30))
        }
        
        //短信验证码登录
        btnB = UIButton.init(type: UIButtonType.custom)
        btnB.setTitle("取消分享", for: UIControlState.normal)
        btnB.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btnB.setTitleColor(UIColor.black, for: .normal) //普通状态下文字的颜色
        btnB.addTarget(self, action:#selector(alterView(btn:)),for: .touchUpInside)
        self.addSubview(btnB)
        btnB.snp_makeConstraints { (make) in
            make.top.equalTo(400)
            make.left.equalTo(0)
            make.width.equalTo(ScreenInfo.width)
            make.height.equalTo(PublicFunc.setHeight(size: 30))
        }
        
        //短信验证码登录
        btnA = UIButton.init(type: UIButtonType.custom)
        btnA.setTitle("弹出提示框", for: UIControlState.normal)
        btnA.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btnA.setTitleColor(UIColor.black, for: .normal) //普通状态下文字的颜色
        btnA.addTarget(self, action:#selector(alterTip(btn:)),for: .touchUpInside)
        self.addSubview(btnA)
        btnA.snp_makeConstraints { (make) in
            make.top.equalTo(320)
            make.left.equalTo(0)
            make.width.equalTo(ScreenInfo.width)
            make.height.equalTo(PublicFunc.setHeight(size: 30))
        }
    }
}
extension MineV{
    @objc func subJump(_ tapGes :UITapGestureRecognizer){
        mineVDelegate?.toSub(mineV : self)
    }
    @objc func alterView(btn:UIButton){
        mineVDelegate?.toAlertView(mineV : self)
    }
    @objc func alterTip(btn:UIButton){
        mineVDelegate?.toAlertTip(mineV : self)
    }
}
