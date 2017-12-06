//
//  ViewVC.swift
//  Maps
//
//  Created by test on 2017/12/5.
//  Copyright © 2017年 com.youlu. All rights reserved.
//

import UIKit
import SnapKit
class ViewVC: UIViewController,UIGestureRecognizerDelegate {
    //声明导航条
    var navigationBar:UINavigationBar?
    var statusView = UIView()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .cyan
        navigationBar = UINavigationBar(frame: CGRect(x:0, y:UIDevice.isX() == true ? 44 : 20, width:ScreenInfo.width, height:44))
        //给导航条增加导航项
        navigationBar?.pushItem(onMakeNavitem(), animated: true)
        self.view.addSubview(navigationBar!)
        //手势：
        let GesTar = self.navigationController?.interactivePopGestureRecognizer!.delegate
        let Ges = UIPanGestureRecognizer(target:GesTar,
                                         action:Selector(("handleNavigationTransition:")))
        Ges.delegate = self
        self.view.addGestureRecognizer(Ges)
        //同时禁用系统原先的侧滑返回功能
        self.navigationController?.interactivePopGestureRecognizer!.isEnabled = false
        //toA()
        self.setUpUi()

        let showView = UIImageView.init(frame: CGRect(x: 100, y: 100, width: 100, height: 100))

        showView.image = UIImage(named: "img_juxing")
        showView.layer.mask = test(showView: showView)
        self.view.addSubview(showView)

        //UIView
        let blankView = UIView.init(frame: CGRect(x: 250, y: 100, width: 100, height: 100))

        blankView.backgroundColor = UIColor.green
        blankView.layer.mask = test(showView: blankView)
        self.view.addSubview(blankView)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        navigationBar?.isTranslucent = false
        // 5.设置导航栏阴影图片
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
extension ViewVC{
    //创建一个导航项
    func onMakeNavitem()->UINavigationItem{
        var navigationItem = UINavigationItem()
        //创建左边按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"icon_return.png"), style: .plain, target: self, action: #selector(ViewVC.goBack))
        navigationItem.title = "碘酒图片"
        return navigationItem
    }
    func setUpUi(){
        statusView = UIView()
        statusView.backgroundColor = .white
        self.view.addSubview(statusView)
        statusView.snp.makeConstraints{ (make) in
            //make.centerY.equalTo(topPic)
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.width.equalTo(ScreenInfo.width)
            make.height.equalTo(20)
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


    ///设置小三角
    func test(showView: UIView) -> CAShapeLayer {
        let viewWidth = CGFloat(showView.frame.width)
        let viewHeight = CGFloat(showView.frame.height)

        //所占的宽度,整个view所占的宽度不会变,已经被制定,所以这个宽度会占用整个view的宽度,
        let rightSpace: CGFloat = 10
        //距离顶部的距离
        let topSpace: CGFloat = 30

        let point1 = CGPoint(x:0, y:0)
        let point2 = CGPoint(x:viewWidth - rightSpace, y:0)
        let point3 = CGPoint(x:viewWidth - rightSpace, y:topSpace)
        let point4 = CGPoint(x:viewWidth, y:topSpace)
        let point5 = CGPoint(x:viewWidth - rightSpace, y:topSpace + 10)
        let point6 = CGPoint(x:viewWidth - rightSpace, y:viewHeight)
        let point7 = CGPoint(x:0, y:viewHeight)

        let path = UIBezierPath()
        path.move(to: point1)
        path.addLine(to: point2)
        path.addLine(to: point3)
        path.addLine(to: point4)
        path.addLine(to: point5)
        path.addLine(to: point6)
        path.addLine(to: point7)

        let layer = CAShapeLayer()
        layer.path = path.cgPath
        return layer
    }

}
