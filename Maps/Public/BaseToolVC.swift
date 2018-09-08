//
//  BaseToolVC.swift
//  Maps
//
//  Created by test on 2017/12/21.
//  Copyright © 2017年 com.youlu. All rights reserved.
//

import UIKit
class BaseToolVC: UIViewController, UIGestureRecognizerDelegate{
    var statusView = UIView()
    var navigationBar = UIView()
    var centerT = UILabel()
    var backV = UIImageView()
    var rightT = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()
        //手势：
        let GesTar = self.navigationController?.interactivePopGestureRecognizer!.delegate
        let Ges = UIPanGestureRecognizer(target:GesTar,
                                         action:Selector(("handleNavigationTransition:")))
        Ges.delegate = self
        self.view.addGestureRecognizer(Ges)
        //同时禁用系统原先的侧滑返回功能
        self.navigationController?.interactivePopGestureRecognizer!.isEnabled = false
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
extension BaseToolVC{
    func setUp(centerVals:String,rightVals:String){
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

        backV.image = UIImage(named: "icon_return.png")
        backV.isUserInteractionEnabled = true
        let backVGes = UITapGestureRecognizer(target: self, action: #selector(self.gesBack(_:)))
        backV.addGestureRecognizer(backVGes)
        navigationBar.addSubview(backV)
        backV.snp.makeConstraints { (make) in
            make.top.equalTo(StatusBarH)
            make.left.equalTo(0)
        }

        //创建中间标题
        centerT.frame = CGRect(x:ScreenInfo.width/4, y:StatusBarH, width:ScreenInfo.width/2, height:NavigationBarH)
        centerT.text = centerVals
        centerT.textAlignment = .center
        centerT.textColor = UIColor.colorWithCustom(242, g: 71, b: 30,alpha: 1)
        navigationBar.addSubview(centerT)

        //创建submit
        rightT.text = rightVals
        rightT.font = UIFont.systemFont(ofSize: 16)
        rightT.textAlignment = .center
        rightT.textColor = UIColor.colorWithCustom(242, g: 71, b: 30,alpha: 1)
        rightT.isUserInteractionEnabled = true
        let rightTGes = UITapGestureRecognizer(target: self, action: #selector(self.toRight(_:)))
        rightT.addGestureRecognizer(rightTGes)
        navigationBar.addSubview(rightT)
        rightT.snp.makeConstraints { (make) in
            make.top.equalTo(StatusBarH)
            make.height.equalTo(NavigationBarH)
            make.right.equalTo(-16)
        }
    }
    //手势代码：
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if self.navigationController?.viewControllers.count == 1 {
            return false
        }
        return true
    }
    @objc func gesBack(_ tapGes :UITapGestureRecognizer){
        PublicFunc.popToPrevCtrl(selfCtrl: self)
    }
    @objc func toRight(_ tapGes :UITapGestureRecognizer){
        STLog("等继承者来完成相应功能")
        //cuServiceViewDelegate?.toSubmit(cuServiceView : self)
    }
}
