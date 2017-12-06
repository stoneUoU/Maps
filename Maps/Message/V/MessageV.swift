//
//  messageV.swift
//  Maps
//
//  Created by test on 2017/10/9.
//  Copyright © 2017年 com.youlu. All rights reserved.
//

import UIKit
import SnapKit
protocol MessageVDelegate: class {
    //去打印
    func toPrints(messageV : MessageV)
    //去弹出卡片
    func toAlter(messageV : MessageV)
}
class MessageV: UIView {
    var fuVals:UILabel = UILabel()
    var cardVals:UILabel = UILabel()
    var amountVals:UILabel = UILabel()
    var telField:UITextField = UITextField()
    var countVals:UILabel = UILabel()
    weak var messageVDelegate : MessageVDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MessageV:UITextFieldDelegate{
    // 外面的大盒子
    func setupUI(){
        fuVals = UILabel()
        fuVals.textAlignment = .center
        fuVals.font = UIFont.UiFontSize(size: 14)
        fuVals.textAlignment = .center
        fuVals.text = "去扫描二维码"
        fuVals.textColor = UIColor.colorWithCustom(0, g: 0, b: 0,alpha: 0.87)
        fuVals.isUserInteractionEnabled = true
        let infoGes = UITapGestureRecognizer(target: self, action: #selector(self.prints(_:)))
        fuVals.addGestureRecognizer(infoGes)
        addSubview(fuVals);
        fuVals.snp_makeConstraints { (make) in
            make.top.equalTo(PublicFunc.setHeight(size: 120))
            make.left.equalTo(0)
            make.width.equalTo(ScreenInfo.width)
            make.height.equalTo(PublicFunc.setHeight(size: 20))
        }
        
        
        cardVals = UILabel()
        cardVals.textAlignment = .center
        cardVals.font = UIFont.UiFontSize(size: 14)
        cardVals.textAlignment = .center
        cardVals.text = "弹出卡片"
        cardVals.textColor = UIColor.colorWithCustom(0, g: 0, b: 0,alpha: 0.87)
        cardVals.isUserInteractionEnabled = true
        let cardGes = UITapGestureRecognizer(target: self, action: #selector(self.alter(_:)))
        cardVals.addGestureRecognizer(cardGes)
        addSubview(cardVals);
        cardVals.snp_makeConstraints { (make) in
            make.top.equalTo(fuVals.snp.bottom).offset(PublicFunc.setHeight(size:60))
            make.left.equalTo(0)
            make.width.equalTo(ScreenInfo.width)
            make.height.equalTo(PublicFunc.setHeight(size: 20))
        }
        //手机号输入框
        telField = UITextField()
        //设置边框样式为圆角矩形
        telField.borderStyle = UITextBorderStyle.none
        telField.returnKeyType = UIReturnKeyType.done
        telField.placeholder="请输入手机号码"
        telField.font=UIFont.UiFontSize(size: 14)
        telField.adjustsFontSizeToFitWidth=true  //当文字超出文本框宽度时，自动调整文字大小
        telField.minimumFontSize=14  //最小可缩小的字号
        telField.keyboardType = UIKeyboardType.phonePad
        //设置光标颜色
        telField.tintColor = UIColor.colorWithCustom(242,g:72,b:28)
        telField.delegate=self
        addSubview(telField)
        telField.snp.makeConstraints { (make) in
            //make.centerY.equalTo(topPic)
            make.top.equalTo(cardVals.snp.bottom).offset(0)
            make.left.equalTo(0)
            make.width.equalTo(ScreenInfo.width)
            make.height.equalTo(PublicFunc.setHeight(size: 36))
        }
        amountVals = UILabel()
        amountVals.textAlignment = .center
        amountVals.font = UIFont.UiFontSize(size: 18)
        amountVals.textAlignment = .center
        amountVals.textColor = UIColor.colorWithCustom(0, g: 0, b: 0,alpha: 0.87)
        addSubview(amountVals);
        amountVals.snp_makeConstraints { (make) in
            make.top.equalTo(telField.snp.bottom).offset(24)
            make.left.equalTo(0)
            make.width.equalTo(ScreenInfo.width)
            make.height.equalTo(PublicFunc.setHeight(size: 20))
        }
        
        
        countVals = UILabel()
        countVals.textAlignment = .center
        countVals.font = UIFont.UiFontSize(size: 18)
        countVals.textAlignment = .center
        countVals.textColor = UIColor.colorWithCustom(0, g: 0, b: 0,alpha: 0.87)
        addSubview(countVals);
        countVals.snp_makeConstraints { (make) in
            make.top.equalTo(amountVals.snp.bottom).offset(PublicFunc.setHeight(size:120))
            make.left.equalTo(0)
            make.width.equalTo(ScreenInfo.width)
            make.height.equalTo(PublicFunc.setHeight(size: 20))
        }
    }
}

extension MessageV{
    @objc func prints(_ tapGes :UITapGestureRecognizer){
        messageVDelegate?.toPrints(messageV : self)
    }
    @objc func alter(_ tapGes :UITapGestureRecognizer){
        messageVDelegate?.toAlter(messageV: self)
    }
}

