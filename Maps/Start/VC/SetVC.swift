//
//  SetVC.swift
//  Maps
//
//  Created by test on 2018/1/6.
//  Copyright © 2018年 com.youlu. All rights reserved.
//

import UIKit
import MethodSDK
class SetVC:UIViewController{
    var statusView = UIView()
    var navigationBar = UIView()
    var centerT = UILabel()
    internal let passwordLength = 4
    internal var setTime = 0
    internal var password: String? = nil
    //可以验证的最大次数
    var maxVerify:Int = 5;
    //你已经画了多少次
    var verifyCount:Int = 0;
    let touchView: CirclesView = CirclesView()
    let infoView: CircleInfoView = CircleInfoView()
    var tipsLabel: UILabel = UILabel()
    var type: PatterLockType

    let firstSetTipText = "验证解锁图案"
    let atLeast4PointTipText = "至少连接4个点，请重新输入"
    let successTipText = "验证成功"
    var verifyCountTips:String = ""

    var forgetW = UILabel()

    convenience init() {
        self.init(type: .verify)
    }

    init(type theType: PatterLockType) {
        type = theType
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        type = .verify
        super.init(coder: aDecoder)
    }
    //声明导航条
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
        self.view.backgroundColor = UIColor.white
        self.VerifyW()
    }
    override func viewWillAppear(_ animated: Bool){
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension SetVC{
    func setUpUI(){
        statusView.backgroundColor = .white
        self.view.addSubview(statusView)
        statusView.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.width.equalTo(ScreenInfo.width)
            make.height.equalTo(StatusBarH)
        }
        navigationBar.frame = CGRect(x: 0, y: 0, width: ScreenW, height: StatusBarAndNavigationBarH)
        navigationBar.backgroundColor = UIColor.white
        self.view.addSubview(navigationBar)
        //创建中间标题
        centerT.frame = CGRect(x:ScreenInfo.width/4, y:StatusBarH, width:ScreenInfo.width/2, height:NavigationBarH)
        centerT.text = "手势密码"
        centerT.textAlignment = .center
        centerT.textColor = UIColor.colorWithCustom(242, g: 71, b: 30,alpha: 1)
        navigationBar.addSubview(centerT)

        self.view.addSubview(infoView)
        infoView.snp.makeConstraints{
            (make) in
            make.top.equalTo(self.view.snp.top).offset(StatusBarAndNavigationBarH + PublicFunc.setHeight(size: 44))
            make.centerX.equalTo(self.view)
            make.width.equalTo(self.infoView.bounds.width)
            make.height.equalTo(self.infoView.bounds.height)
        }

        tipsLabel.textColor = Color.grayColor
        tipsLabel.font = UIFont.systemFont(ofSize: 15)
        tipsLabel.textAlignment = .center
        tipsLabel.text = type == .verify ? firstSetTipText : ""
        self.view.addSubview(tipsLabel)
        tipsLabel.snp.makeConstraints{
            (make) in
            make.top.equalTo(self.infoView.snp.bottom).offset(PublicFunc.setHeight(size: 24))
            make.left.equalTo(0)
            make.width.equalTo(ScreenInfo.width)
            make.height.equalTo(15)
        }

        self.view.addSubview(touchView)
        touchView.snp.makeConstraints{
            (make) in
            make.top.equalTo(self.tipsLabel.snp.bottom).offset( PublicFunc.setHeight(size: 24))
            make.centerX.equalTo(self.view)
            make.width.equalTo(self.touchView.bounds.width)
            make.height.equalTo(self.touchView.bounds.height)
        }
        //创建submit
        forgetW.text = "忘记手势密码"
        forgetW.font = UIFont.systemFont(ofSize: 16)
        forgetW.textAlignment = .center
        forgetW.textColor = UIColor.colorWithCustom(242, g: 71, b: 30,alpha: 1)
        forgetW.isUserInteractionEnabled = true
        let forgetWGes = UITapGestureRecognizer(target: self, action: #selector(self.toGusture(_:)))
        forgetW.addGestureRecognizer(forgetWGes)
        self.view.addSubview(forgetW)
        forgetW.snp.makeConstraints { (make) in
            make.top.equalTo(self.touchView.snp.bottom).offset(PublicFunc.setHeight(size: 24))
            make.centerX.equalTo(self.view)
            make.width.equalTo(self.touchView.bounds.width)
            make.height.equalTo(PublicFunc.setHeight(size: 24))
        }
    }
    func VerifyW(){
        touchView.getPasswordClosure = { [unowned self](password) in
            self.infoView.clean();
            if self.type == .verify {
                self.infoView.fillCircles(withNumber: password)
                if let gestureW = keychain.get("GestureWord"){
                    if gestureW == password{
                        self.showSucc(self.successTipText)
                        self.verifyCount = 0
                        StToastSDK().showToast(text:"验证成功",type:Pos)
                        PublicFunc.dismissCurrCtrl(selfCtrl: self)
                    }else{
                        self.verifyCount = self.verifyCount +  1
                        self.verifyCountTips = "很抱歉，密码错误，还有\(self.maxVerify - self.verifyCount)次机会"
                        if self.maxVerify - self.verifyCount == 0 {
                            self.verifyCountTips = "很抱歉，没有机会了"
                            StToastSDK().showToast(text:"很抱歉，没有机会了，直接跳转登录界面",type:Pos)
                        }
                        self.touchView.clean()
                        self.showError(self.verifyCountTips);
                    }
                }
            }
        }
    }
    func showError(_ text: String) {
        let center = tipsLabel.center
        tipsLabel.text = text
        tipsLabel.textColor = Color.destructiveColor
        UIView.animateKeyframes(withDuration: 1.0, delay: 0, options: [], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.1, animations: {
                self.tipsLabel.center = CGPoint(x: center.x - 10, y: center.y)
            })
            UIView.addKeyframe(withRelativeStartTime: 0.1, relativeDuration: 0.2, animations: {
                self.tipsLabel.center = CGPoint(x: center.x + 10, y: center.y)
            })
            UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.3, animations: {
                self.tipsLabel.center = CGPoint(x: center.x - 10, y: center.y)
            })
            UIView.addKeyframe(withRelativeStartTime: 0.3, relativeDuration: 0.4, animations: {
                self.tipsLabel.center = CGPoint(x: center.x + 10, y: center.y)
            })
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 1, animations: {
                self.tipsLabel.center = CGPoint(x: center.x, y: center.y)
            })
        }, completion: nil)
    }
    func showSucc(_ text: String) {
        tipsLabel.text = text
        tipsLabel.textColor = Color.grayColor
    }

    @objc func toGusture(_ tapGes :UITapGestureRecognizer){
        //STLog("等继承者来完成相应功能")
        //cuServiceViewDelegate?.toSubmit(cuServiceView : self)
        PublicFunc.pushToNextCtrl(selfCtrl: self, otherCtrl: LoginVC())
    }
}
