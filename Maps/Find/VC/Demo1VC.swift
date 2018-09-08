//
//  Demo1VC.swift
//  Maps
//
//  Created by test on 2017/12/21.
//  Copyright © 2017年 com.youlu. All rights reserved.
//
import UIKit
class Demo1VC:BaseToolVC{
    //声明导航条
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp(centerVals: "快递查询", rightVals: "完成")
        self.setUpUI()
        self.view.backgroundColor = UIColor.cyan
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension Demo1VC{
    func setUpUI(){
        let statusView = UIView()
        statusView.backgroundColor = .green
        self.view.addSubview(statusView)
        statusView.snp.makeConstraints { (make) in
            make.top.equalTo(200)
            make.left.equalTo(0)
            make.width.equalTo(ScreenInfo.width)
            make.height.equalTo(StatusBarAndNavigationBarH)
        }
    }
    @objc override func toRight(_ tapGes: UITapGestureRecognizer) {
        STLog("我来完成了")
    }
}


