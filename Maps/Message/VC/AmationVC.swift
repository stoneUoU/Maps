//
//  AmationVC.swift
//  Maps
//
//  Created by test on 2017/11/13.
//  Copyright © 2017年 com.youlu. All rights reserved.
//

import UIKit
import SnapKit
class AmationVC: UIViewController,UIGestureRecognizerDelegate {
    //声明导航条
    var passVals:[String : Any] = [String : Any]()
    var navigationBar:UINavigationBar?
    var sgmentControl:UISegmentedControl?
    var cyanV = UIView()
    var containerV = UIView()
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
        print(passVals,"sssss")
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        navigationBar?.isTranslucent = false
        // 5.设置导航栏阴影图片
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension AmationVC{
    //创建一个导航项
    func onMakeNavitem()->UINavigationItem{
        var navigationItem = UINavigationItem()
        //创建左边按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"icon_return.png"), style: .plain, target: self, action: #selector(MineSubVC.goBack))
        //设置导航栏标题
        sgmentControl = UISegmentedControl()
        sgmentControl?.tintColor = UIColor.red
        //添加子项
        sgmentControl?.insertSegment(withTitle: "北京", at: 0, animated: true)
        sgmentControl?.insertSegment(withTitle: "上海", at: 1, animated: true)
        sgmentControl?.insertSegment(withTitle: "深圳", at: 2, animated: true)
        sgmentControl?.selectedSegmentIndex=0 //默认选中第1项
        sgmentControl?.addTarget(self, action: #selector(updateView), for: UIControlEvents.valueChanged)
        sgmentControl?.snp.makeConstraints{(make) in
            make.width.equalTo(ScreenW/2)
        }
        navigationItem.titleView = sgmentControl!
        return navigationItem
    }
    func setUpUI(){
        self.view.addSubview(containerV)
        containerV.snp.makeConstraints{
            (make) in
            make.width.equalTo(ScreenInfo.width)
            make.height.equalTo(ScreenInfo.height - StatusBarAndNavigationBarH)
            make.top.equalTo(self.view).offset(StatusBarAndNavigationBarH)
            make.left.equalTo(self.view)
        }
        add(asChildViewController: Seg1VC())
    }
    // MARK: - View Methods

    func updateView() {
        if sgmentControl!.selectedSegmentIndex == 0 {
            removeOtherCtrl()
            add(asChildViewController: Seg1VC())
        } else if sgmentControl!.selectedSegmentIndex == 1{
            removeOtherCtrl()
            add(asChildViewController: Seg2VC())
        }
        else{
            removeOtherCtrl()
            add(asChildViewController: Seg3VC())
        }
    }

    @objc func goBack() {
        DispatchQueue.main.async{
            self.navigationController?.popViewController(animated: true)
        }
    }
    //手势代码：
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if self.navigationController?.viewControllers.count == 1 {
            return false
        }
        return true
    }
    fileprivate func add(asChildViewController viewController: UIViewController) {
        addChildViewController(viewController)
        containerV.addSubview(viewController.view)
        viewController.view.snp.makeConstraints{
            (make) in
            make.edges.equalTo(containerV)
        }
    }
    fileprivate func removeOtherCtrl() {
        for v in self.containerV.subviews as [UIView] {
            v.removeFromSuperview()
        }
    }
}

//        cyanV.backgroundColor = UIColor.red
//        self.view.addSubview(cyanV)
//        cyanV.snp.makeConstraints{
//            (make) in
//            make.width.height.equalTo(160)
//            make.top.equalTo(StatusBarAndNavigationBarH)
//            make.centerX.equalTo(self.view)
//        }
//
//        let btnV = UIButton()
//        btnV.setTitle("开始动画", for: .normal)
//        btnV.setTitleColor(UIColor.black, for: .normal)
//        btnV.addTarget(self, action: #selector(AmationVC.toA), for: .touchUpInside)
//        self.view.addSubview(btnV)
//        btnV.snp.makeConstraints{
//            (make) in
//            make.width.equalTo(160)
//            make.height.equalTo(36)
//            make.top.equalTo(cyanV.snp.bottom).offset(36)
//            make.centerX.equalTo(self.view)
//        }

//    func toA(){
//
//        //先将数字块大小置为原始尺寸的 1/10
//        self.cyanV.layer.setAffineTransform(CGAffineTransform(scaleX: 0.1,y: 0.1))
//
//        //设置动画效果，动画时间长度 1 秒。
//        UIView.animate(withDuration: 1, delay:0.01, options:[], animations: {
//            ()-> Void in
//            self.cyanV.layer.setAffineTransform(CGAffineTransform(rotationAngle: 90))
//        },
//           completion:{
//            (finished:Bool) -> Void in
//            UIView.animate(withDuration: 0.08, animations:{
//                ()-> Void in
//                self.cyanV.layer.setAffineTransform(CGAffineTransform.identity)
//            })
//        })
//
////        UIView.animate(withDuration: 1, delay:0.01, options:[.curveEaseInOut],
////           animations: {
////            ()-> Void in
////        },
////           completion:{
////            (finished:Bool) -> Void in
////            UIView.animate(withDuration: 1, animations:{
////                ()-> Void in
////                self.cyanV.alpha = 0
////            })
////        })
//    }
