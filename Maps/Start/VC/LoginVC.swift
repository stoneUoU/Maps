//
//  LoginVC.swift
//  Centers
//
//  Created by test on 2017/9/29.
//  Copyright © 2017年 com.youlu. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    lazy var loginV: LoginV = {[weak self] in
        let Frame = CGRect(x: 0, y: 0, width: ScreenInfo.width, height: ScreenInfo.height)
        let loginV = LoginV(frame: Frame)
        loginV.loginVDelegate = self
        return loginV
    }()
    var netUseVals:String!
    var noticeObser:Bool? {
        didSet {
            _ = SnailNotice.add(observer: self, selector: #selector(LoginVC.setNet(notification:)), notification: .netChange)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
        noticeObser = true //开启所有观察
        //监听是否有网
        netUseVals = keychain.get("ifnetUseful")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension LoginVC:LoginVDelegate{
    func setupUI(){
        self.view.addSubview(loginV)
    }
    @objc func setNet(notification:NSNotification) {
        netUseVals = notification.userInfo!["netUseful"] as! String
        //print(netUseVals,"网络变化")
    }
    func toSuccess(loginV: LoginV) {
        if netUseVals == "Useable"{
            keychain.set("520", forKey: "Developer")
            keychain.set("52😀", forKey: "Developer")
            HudTips.showHUD(ctrl: self)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1, execute: {
                let customTabBarV = CustomTabBarVC()
                customTabBarV.navigationItem.hidesBackButton=true
                self.navigationController?.navigationBar.isHidden = true
                //push方式
                self.navigationController?.pushViewController(customTabBarV , animated: true)
            })
        }else{
            StToast().showToast(text:"\(missNetTips)",type:Pos)
        }
    }
}
