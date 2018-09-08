//
//  StepBot3VC.swift
//  Maps
//
//  Created by test on 2017/12/7.
//  Copyright © 2017年 com.youlu. All rights reserved.
//

import UIKit

class StepBot3VC: UIViewController {
    var btn1 = UIButton()
    // MARK: 回调属性  主页性别refresh闭包
    static var changeCtrlThree: (() -> ())?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
        self.view.backgroundColor = UIColor(red: CGFloat(CGFloat(arc4random()) / CGFloat(RAND_MAX)), green: CGFloat(CGFloat(arc4random()) / CGFloat(RAND_MAX)), blue: CGFloat(CGFloat(arc4random()) / CGFloat(RAND_MAX)), alpha: 1.0)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
extension StepBot3VC{
    func setUpUI(){
        //创建按钮控件
        btn1 = ViewFactory.createBtn(title: "点击函数",bgColor:UIColor(red: CGFloat(CGFloat(arc4random()) / CGFloat(RAND_MAX)), green: CGFloat(CGFloat(arc4random()) / CGFloat(RAND_MAX)), blue: CGFloat(CGFloat(arc4random()) / CGFloat(RAND_MAX)), alpha: 1.0),titleColor:UIColor.white, action: .stepThreeConfirm, sender: self)
        self.view.addSubview(btn1)
        btn1.snp.makeConstraints{
            (make) in
            make.width.equalTo(ScreenInfo.width*2/3)
            make.height.equalTo(36)
            make.top.equalTo(StatusBarAndNavigationBarH)
            make.centerX.equalTo(self.view)
        }
    }
}
extension StepBot3VC{
    @objc func toConfirm(sender:UIButton){
        if StepBot3VC.changeCtrlThree != nil {
            StepBot3VC.changeCtrlThree!()
        }
    }
}
public extension Selector {
    static let stepThreeConfirm = #selector(StepBot3VC.toConfirm(sender:))
}
