//
//  SpringVC.swift
//  Maps
//
//  Created by test on 2017/12/15.
//  Copyright © 2017年 com.youlu. All rights reserved.
//

import UIKit
import Spring
class SpringVC: UIViewController,UIGestureRecognizerDelegate{
    //声明导航条
    var navigationBar:UINavigationBar!
    var views: SpringView!
    var btnStart :UIButton!
    var btnStop :UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
        self.view.backgroundColor = UIColor.white
        //手势：
        let GesTar = self.navigationController?.interactivePopGestureRecognizer!.delegate
        let Ges = UIPanGestureRecognizer(target:GesTar,
                                         action:Selector(("handleNavigationTransition:")))
        Ges.delegate = self
        self.view.addGestureRecognizer(Ges)
        //同时禁用系统原先的侧滑返回功能
        self.navigationController?.interactivePopGestureRecognizer!.isEnabled = false
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.setHidesBackButton(true, animated: true)
        navigationBar?.isTranslucent = false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension SpringVC{
    func setUpUI(){
        navigationBar = UINavigationBar(frame: CGRect(x:0, y:UIDevice.isX() == true ? 44 : 20, width:ScreenInfo.width, height:44))
        self.view.addSubview(navigationBar)
        onAdd()

        views = SpringView()
        views.backgroundColor = UIColor.orange
        views.alpha = 0
        self.view.addSubview(views)
        views.snp.makeConstraints{
            (make) in
            make.width.equalTo(ScreenInfo.width)
            make.height.equalTo(200)
            make.left.equalTo(0)
            make.top.equalTo(0)
        }

        btnStart = UIButton()
        btnStart.setTitle("开始", for: .normal)
        btnStart.titleLabel?.textColor = .white
        btnStart.backgroundColor = UIColor.cyan
        btnStart.addTarget(self, action: #selector(btnStart(_:)), for:.touchUpInside)
        self.view.addSubview(btnStart)
        btnStart.snp.makeConstraints{
            (make) in
            make.width.equalTo(ScreenInfo.width/2)
            make.height.equalTo(40)
            make.left.equalTo(0)
            make.bottom.equalTo(self.view.snp.bottom).offset(-StatusBarAndNavigationBarH)
        }

        btnStop = UIButton()
        btnStop.setTitle("结束", for: .normal)
        btnStop.titleLabel?.textColor = .white
        btnStop.backgroundColor = UIColor.cyan
        btnStop.addTarget(self, action: #selector(btnStop(_:)), for:.touchUpInside)
        self.view.addSubview(btnStop)
        btnStop.snp.makeConstraints{
            (make) in
            make.width.equalTo(ScreenInfo.width/2 - 1)
            make.height.equalTo(40)
            make.left.equalTo(btnStart.snp.right).offset(1)
            make.bottom.equalTo(self.view.snp.bottom).offset(-StatusBarAndNavigationBarH)
        }
    }
    func onAdd(){
        //给导航条增加导航项
        navigationBar?.pushItem(onMakeNavitem(), animated: true)
    }
    //创建一个导航项
    func onMakeNavitem()->UINavigationItem{
        var navigationItem = UINavigationItem()
        //设置导航栏标题
        navigationItem.title = "Spring动画"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"icon_return.png"), style: .plain, target: self, action: #selector(BackCellVC.goBack))
        return navigationItem
    }
    @objc func goBack() {
        DispatchQueue.main.async{
            self.navigationController?.popViewController(animated: true)
        }
    }
    @objc func sendNotice(_:UIButton){
        //发送通知
        SnailNotice.post(notification: .happy,object: nil,passDicts: ["success":"true"])
    }
    //手势代码：
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if self.navigationController?.viewControllers.count == 1 {
            return false
        }
        return true
    }
    @objc func btnStart(_:UIButton){
        views.alpha = 1
        self.views.animate()
    }
    @objc func btnStop(_:UIButton){
        views.alpha = 0
        self.views.animate()
//        views.snp.remakeConstraints{
//            (make) in
//            make.width.equalTo(ScreenInfo.width)
//            make.height.equalTo(200)
//            make.left.equalTo(0)
//            make.bottom.equalTo(self.view.snp.top).offset(0)
//        }
//        views.animateToNext {
//            self.views.animation = "slideUp"
//        }
    }

}

