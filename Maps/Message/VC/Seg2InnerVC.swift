//
//  Seg2InnerVC.swift
//  Maps
//
//  Created by test on 2017/11/15.
//  Copyright © 2017年 com.youlu. All rights reserved.
//
import UIKit
import SnapKit
class Seg2InnerVC: UIViewController,UIGestureRecognizerDelegate {
    //声明导航条
    var navigationBar:UINavigationBar?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        navigationBar = UINavigationBar(frame: CGRect(x:0, y:UIDevice.isX() == true ? 44 : 20, width:ScreenInfo.width, height:44))
        //给导航条增加导航项
        navigationBar?.pushItem(onMakeNavitem(), animated: true)
        self.view.addSubview(navigationBar!)
        self.setUpUI()
        //手势：
        let GesTar = self.navigationController?.interactivePopGestureRecognizer!.delegate
        let Ges = UIPanGestureRecognizer(target:GesTar,
                                         action:Selector(("handleNavigationTransition:")))
        Ges.delegate = self
        self.view.addGestureRecognizer(Ges)
        //同时禁用系统原先的侧滑返回功能
        self.navigationController?.interactivePopGestureRecognizer!.isEnabled = false
        //toA()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        navigationBar?.isTranslucent = false
        // 5.设置导航栏阴影图片
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
extension Seg2InnerVC{
    //创建一个导航项
    func onMakeNavitem()->UINavigationItem{
        var navigationItem = UINavigationItem()
        //创建左边按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"icon_return.png"), style: .plain, target: self, action: #selector(Seg2InnerVC.goBack))
        navigationItem.title = "测试"
        return navigationItem
    }
    func setUpUI(){
    }

    @objc func goBack() {
        PublicFunc.popToSomeCtrl(selfCtrl: self, otherCtrl: MessageVC)
//        DispatchQueue.main.async{
//            self.navigationController?.popViewController(animated: true)
//        }
    }
    //手势代码：
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if self.navigationController?.viewControllers.count == 1 {
            return false
        }
        return true
    }
}


