//
//  testCtrlVC.swift
//  Maps
//
//  Created by test on 2017/12/21.
//  Copyright © 2017年 com.youlu. All rights reserved.
//

import UIKit
class TestCtrlVC: UIViewController{
    var someVals:[String : Any] = [String : Any]()
    var totalV = UIView()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI(showCtrl:someVals["showCtrl"] as! Int)
        self.view.backgroundColor = UIColor.white
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension TestCtrlVC{
    func setUpUI(showCtrl:Int){
        self.view.addSubview(totalV)
        totalV.snp.makeConstraints{
            (make) in
            make.width.equalTo(ScreenInfo.width)
            make.height.equalTo(ScreenInfo.height)
            make.top.equalTo(self.view)
            make.left.equalTo(self.view)
        }
        removeOtherCtrl()
        showCtrl == 0 ? add(asChildViewController: Demo1VC()) : add(asChildViewController: Demo2VC())
    }
}
extension TestCtrlVC{
    fileprivate func add(asChildViewController viewController: UIViewController) {
        addChildViewController(viewController)
        totalV.addSubview(viewController.view)
        viewController.view.snp.makeConstraints{
            (make) in
            make.edges.equalTo(totalV)
        }
    }
    fileprivate func removeOtherCtrl() {
        for v in self.totalV.subviews as [UIView] {
            v.removeFromSuperview()
        }
    }
}


