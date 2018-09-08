//
//  StepBot1VC.swift
//  Maps
//
//  Created by test on 2017/12/7.
//  Copyright © 2017年 com.youlu. All rights reserved.
//

import UIKit

class StepBot1VC: UIViewController {
    var btn1 = UIButton()
    var test1V = UIView()
    var test2V = UIView()
    var ifHide = Bool()
    // MARK: 回调属性  主页性别refresh闭包
    static var changeCtrlOne: (() -> ())?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
        self.view.backgroundColor = .white
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: {
            self.ifHide = false
            self.test1V.isHidden = false
            self.setCon(vals:self.test1V.isHidden)
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
extension StepBot1VC{
    func setCon(vals:Bool){
        switch vals {
        case true:
            self.test2V.snp.remakeConstraints{
                (make) in
                make.width.equalTo(ScreenInfo.width)
                make.height.equalTo(100)
                make.top.equalTo(self.btn1.snp.bottom).offset(StatusBarAndNavigationBarH)
            }
        default:
            self.test2V.snp.remakeConstraints{
                (make) in
                make.width.equalTo(ScreenInfo.width)
                make.height.equalTo(100)
                make.top.equalTo(self.test1V.snp.bottom).offset(StatusBarAndNavigationBarH)
            }
        }
    }
    func setUpUI(){
        //创建按钮控件
        btn1 = ViewFactory.createBtn(title: "点击函数",bgColor:UIColor(red: CGFloat(CGFloat(arc4random()) / CGFloat(RAND_MAX)), green: CGFloat(CGFloat(arc4random()) / CGFloat(RAND_MAX)), blue: CGFloat(CGFloat(arc4random()) / CGFloat(RAND_MAX)), alpha: 1.0),titleColor:UIColor.white, action: .stepOneConfirm, sender: self)
        self.view.addSubview(btn1)
        btn1.snp.makeConstraints{
            (make) in
            make.width.equalTo(ScreenInfo.width*2/3)
            make.height.equalTo(36)
            make.top.equalTo(StatusBarAndNavigationBarH)
            make.centerX.equalTo(self.view)
        }

        test1V.backgroundColor = .red
        test1V.isHidden = true
        self.view.addSubview(test1V)
        test1V.snp.makeConstraints{
            (make) in
            make.width.equalTo(ScreenInfo.width)
            make.height.equalTo(100)
            make.top.equalTo(btn1.snp.bottom).offset(StatusBarAndNavigationBarH)
        }
        test2V.backgroundColor = .cyan
        self.view.addSubview(test2V)
        test2V.snp.makeConstraints{
            (make) in
            make.width.equalTo(ScreenInfo.width)
            make.height.equalTo(100)
            make.top.equalTo(btn1.snp.bottom).offset(StatusBarAndNavigationBarH)
        }
    }
}
extension StepBot1VC{
    @objc func toConfirm(sender:UIButton){
        self.ifHide = !self.ifHide
        test1V.isHidden = self.ifHide
        setCon(vals:self.ifHide)
//        if StepBot1VC.changeCtrlOne != nil {
//            StepBot1VC.changeCtrlOne!()
//        }
    }
}
public extension Selector {
    static let stepOneConfirm = #selector(StepBot1VC.toConfirm(sender:))
}
