//
//  LoginVC.swift
//  Centers
//
//  Created by test on 2017/9/29.
//  Copyright © 2017年 com.youlu. All rights reserved.
//

import UIKit
import MethodSDK
//个人信息
protocol JumpDel: class {
    func doJump()
}
class LoginVC: UIViewController {
    lazy var loginV: LoginV = {[weak self] in
        let Frame = CGRect(x: 0, y: 0, width: ScreenInfo.width, height: ScreenInfo.height)
        let loginV = LoginV(frame: Frame)
        loginV.loginVDelegate = self
        return loginV
    }()
    static var addCtrlBlock: (() -> ())?
    var netUseVals:String!
    var noticeObser:Bool? {
        didSet {
            _ = SnailNotice.add(observer: self, selector: #selector(LoginVC.setNet(notification:)), notification: .netChange)
        }
    }
    static weak var jumpDel: JumpDel?
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
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
    deinit {
        STLog("销毁，LoginVC")
        SnailNotice.remove(observer: self, notification: .netChange)
    }
}

extension LoginVC:LoginVDelegate{
    func setupUI(){
        self.view.addSubview(loginV)
    }
    @objc func setNet(notification:NSNotification) {
        netUseVals = notification.userInfo!["netUseful"] as! String
        if netUseVals == "Useable"{
            if let currCtrl = PublicFunc.getCurrCtrl(){
                if let keyCurrCtrl = keychain.get("currCtrl"){
                    STLog("\(keyCurrCtrl)")
                    STLog("\(currCtrl)")
                    if "\(keyCurrCtrl)" == "\(currCtrl)"{
                        STLog("\(currCtrl)，LoginVC")
                    }
                }
            }
        }
    }
    func toSuccess(loginV: LoginV) {
        if netUseVals == "Useable"{
            keychain.set("520", forKey: "Developer")
            keychain.set("52😀", forKey: "Developer")
            HudTips.showHUD(ctrl: self)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now(), execute: {
                self.dismiss(animated: false, completion: nil)
//                if LoginVC.addCtrlBlock != nil {
//                    LoginVC.addCtrlBlock!()
//                }
                //LoginVC.jumpDel?.doJump()
                TabBarItemsV.ifLogin = true;
                CustomTabBarVC.customTabBar.tabBarView.btns[0].isSelected = false
                CustomTabBarVC.customTabBar.tabBarView.btns[1].isSelected = false
                CustomTabBarVC.customTabBar.tabBarView.btns[2].isSelected = false
                CustomTabBarVC.customTabBar.tabBarView.btns[3].isSelected = false
                CustomTabBarVC.customTabBar.tabBarView.btns[4].isSelected = true
                CustomTabBarVC.customTabBar.tabBarView.tabBarItemClicked(sender: CustomTabBarVC.customTabBar.tabBarView.btns[4])
            })
        }else{
            StToastSDK().showToast(text:"\(missNetTips)",type: Pos )
        }
    }

    func toClose(loginV: LoginV) {
        DispatchQueue.main.async{
            self.dismiss(animated: false, completion: nil)
        }
    }
}
