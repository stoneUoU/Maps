//
//  StepTopVC.swift
//  Maps
//
//  Created by test on 2017/12/7.
//  Copyright © 2017年 com.youlu. All rights reserved.
//

import UIKit

class StepTopVC: UIViewController,UIGestureRecognizerDelegate {
    //声明导航条
    var navigationBar = UIView()
    var centerT = UILabel()
    var backV = UIImageView()
    var spaceV = UIView()
    var topV = UIView()
    var botV = UIView()
    var circle1 = UIView()
    var line1 = UIView()
    var circle2 = UIView()
    var line2 = UIView()
    var circle3 = UIView()
    var line3 = UIView()
    var circle4 = UIView()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
        self.view.backgroundColor = .white
        //手势：
        let GesTar = self.navigationController?.interactivePopGestureRecognizer!.delegate
        let Ges = UIPanGestureRecognizer(target:GesTar,
                                         action:Selector(("handleNavigationTransition:")))
        Ges.delegate = self
        self.view.addGestureRecognizer(Ges)
        //同时禁用系统原先的侧滑返回功能
        self.navigationController?.interactivePopGestureRecognizer!.isEnabled = false
        //通过闭包调用主页topV更新
        StepBot1VC.changeCtrlOne = { [weak self] in
            self?.line1.backgroundColor = .red
            self?.circle2.backgroundColor = .red
            self?.removeOtherCtrl()
            self?.add(asChildViewController: StepBot2VC())
        }
        //通过闭包调用主页topV更新
        StepBot2VC.changeCtrlTwo = { [weak self] in
            self?.line2.backgroundColor = .red
            self?.circle3.backgroundColor = .red
            self?.removeOtherCtrl()
            self?.add(asChildViewController: StepBot3VC())
        }
        //通过闭包调用主页topV更新
        StepBot3VC.changeCtrlThree = { [weak self] in
            self?.line3.backgroundColor = .red
            self?.circle4.backgroundColor = .red
            self?.removeOtherCtrl()
            self?.add(asChildViewController: StepBot4VC())
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        // 5.设置导航栏阴影图片
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension StepTopVC{
    func setUpUI(){
        navigationBar.frame = CGRect(x: 0, y: 0, width: ScreenInfo.width, height: StatusBarAndNavigationBarH)
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
        centerT.frame = CGRect(x:ScreenInfo.width/4, y:StatusBarH, width:ScreenInfo.width/2, height:CGFloat(44))
        centerT.text = "信息管理"
        centerT.textAlignment = .center
        centerT.textColor = UIColor.colorWithCustom(242, g: 71, b: 30,alpha: 1)
        navigationBar.addSubview(centerT)

        spaceV = UIView()
        spaceV.backgroundColor = UIColor.colorWithCustom(199, g: 199, b: 204,alpha: 0.70)
        navigationBar.addSubview(spaceV)
        spaceV.snp.makeConstraints { (make) in
            make.bottom.equalTo(navigationBar.snp.bottom).offset(0)
            make.height.equalTo(CGFloat(0.7))
            make.width.equalTo(ScreenInfo.width)
        }
        topV = UIView()
        topV.backgroundColor = .white
        self.view.addSubview(topV)
        topV.snp.makeConstraints{
            (make) in
            make.top.equalTo(self.spaceV.snp.bottom).offset(0)
            make.left.equalTo(self.view)
            make.width.equalTo(ScreenInfo.width)
            make.height.equalTo(PublicFunc.setHeight(size: 120))
        }
        circle1 = UIView()
        circle1.backgroundColor = .red
        circle1.layer.cornerRadius = 24
        //实现效果
        circle1.clipsToBounds = true
        topV.addSubview(circle1)
        circle1.snp.makeConstraints{
            (make) in
            make.centerY.equalTo(self.topV)
            make.left.equalTo(15)
            make.width.equalTo(48)
            make.height.equalTo(48)
        }
        line1 = UIView()
        line1.backgroundColor = .cyan
        topV.addSubview(line1)
        line1.snp.makeConstraints{
            (make) in
            make.centerY.equalTo(self.topV)
            make.left.equalTo(circle1.snp.right).offset(0)
            make.width.equalTo((ScreenInfo.width - 30 - 4*48)/3)
            make.height.equalTo(6)
        }
        circle2 = UIView()
        circle2.backgroundColor = .cyan
        circle2.layer.cornerRadius = 24
        //实现效果
        circle2.clipsToBounds = true
        topV.addSubview(circle2)
        circle2.snp.makeConstraints{
            (make) in
            make.centerY.equalTo(self.topV)
            make.left.equalTo(line1.snp.right).offset(0)
            make.width.equalTo(48)
            make.height.equalTo(48)
        }
        line2 = UIView()
        line2.backgroundColor = .cyan
        topV.addSubview(line2)
        line2.snp.makeConstraints{
            (make) in
            make.centerY.equalTo(self.topV)
            make.left.equalTo(circle2.snp.right).offset(0)
            make.width.equalTo((ScreenInfo.width - 30 - 4*48)/3)
            make.height.equalTo(6)
        }
        circle3 = UIView()
        circle3.backgroundColor = .cyan
        circle3.layer.cornerRadius = 24
        //实现效果
        circle3.clipsToBounds = true
        topV.addSubview(circle3)
        circle3.snp.makeConstraints{
            (make) in
            make.centerY.equalTo(self.topV)
            make.left.equalTo(line2.snp.right).offset(0)
            make.width.equalTo(48)
            make.height.equalTo(48)
        }
        line3 = UIView()
        line3.backgroundColor = .cyan
        topV.addSubview(line3)
        line3.snp.makeConstraints{
            (make) in
            make.centerY.equalTo(self.topV)
            make.left.equalTo(circle3.snp.right).offset(0)
            make.width.equalTo((ScreenInfo.width - 30 - 4*48)/3)
            make.height.equalTo(6)
        }
        circle4 = UIView()
        circle4.backgroundColor = .cyan
        circle4.layer.cornerRadius = 24
        //实现效果
        circle4.clipsToBounds = true
        topV.addSubview(circle4)
        circle4.snp.makeConstraints{
            (make) in
            make.centerY.equalTo(self.topV)
            make.left.equalTo(line3.snp.right).offset(0)
            make.width.equalTo(48)
            make.height.equalTo(48)
        }

        botV = UIView()
        botV.backgroundColor = .cyan
        self.view.addSubview(botV)
        botV.snp.makeConstraints{
            (make) in
            make.top.equalTo(self.topV.snp.bottom).offset(0)
            make.left.equalTo(self.view)
            make.width.equalTo(ScreenInfo.width)
            make.height.equalTo(ScreenInfo.height - StatusBarAndNavigationBarH - PublicFunc.setHeight(size: 120))
        }
        add(asChildViewController: StepBot1VC())
    }

//    func updateView() {
//        if sgmentControl!.selectedSegmentIndex == 0 {
//            removeOtherCtrl()
//            add(asChildViewController: Seg1VC())
//        } else if sgmentControl!.selectedSegmentIndex == 1{
//            removeOtherCtrl()
//            add(asChildViewController: Seg2VC())
//        }
//        else{
//            removeOtherCtrl()
//            add(asChildViewController: Seg3VC())
//        }
//    }
    //手势代码：
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if self.navigationController?.viewControllers.count == 1 {
            return false
        }
        return true
    }
    fileprivate func add(asChildViewController viewController: UIViewController) {
        addChildViewController(viewController)
        botV.addSubview(viewController.view)
        viewController.view.snp.makeConstraints{
            (make) in
            make.edges.equalTo(botV)
        }
    }
    fileprivate func removeOtherCtrl() {
        for v in self.botV.subviews as [UIView] {
            v.removeFromSuperview()
        }
    }
    @objc func gesBack(_ tapGes :UITapGestureRecognizer){
        DispatchQueue.main.async{
            self.navigationController?.popViewController(animated: true)
        }
    }
}
