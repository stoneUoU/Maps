//
//  LoginV.swift
//  Centers
//
//  Created by test on 2017/9/29.
//  Copyright © 2017年 com.youlu. All rights reserved.
//

import UIKit
import SnapKit
protocol LoginVDelegate: class {
    //跳转到主页
    func toSuccess(loginV : LoginV)
}
class LoginV: UIView {
    weak var loginVDelegate : LoginVDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension LoginV:UITextFieldDelegate{
    func setupUI(){
        //短信验证码登录
        let btnSuccess = UILabel()
        btnSuccess.text = "登录成功"
        btnSuccess.textColor = UIColor.colorWithCustom(242,g:72,b:28)
        btnSuccess.font=UIFont.UiBoldFontSize(size: 18)
        btnSuccess.textAlignment = .center
        //将label用户交互设为true
        btnSuccess.isUserInteractionEnabled = true
        let smsGes = UITapGestureRecognizer(target: self, action: #selector(self.successDo(_:)))
        btnSuccess.addGestureRecognizer(smsGes)
        addSubview(btnSuccess);
        btnSuccess.snp_makeConstraints { (make) in
            make.top.equalTo((ScreenInfo.height - PublicFunc.setHeight(size: 30))/2)
            make.left.equalTo(0)
            make.width.equalTo(ScreenInfo.width)
            make.height.equalTo(PublicFunc.setHeight(size: 30))
        }
    }
}
extension LoginV{
    @objc func successDo(_ tapGes :UITapGestureRecognizer){
        loginVDelegate?.toSuccess(loginV : self)
    }
}
