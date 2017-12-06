//
//  AmationVC.swift
//  Maps
//
//  Created by test on 2017/11/13.
//  Copyright © 2017年 com.youlu. All rights reserved.
//

import UIKit
import SnapKit
class SectorVC: UIViewController,UIGestureRecognizerDelegate {
    //声明导航条
    var navigationBar:UINavigationBar?
    var sgmentControl:UISegmentedControl?
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
extension SectorVC{
    //创建一个导航项
    func onMakeNavitem()->UINavigationItem{
        var navigationItem = UINavigationItem()
        //创建左边按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"icon_return.png"), style: .plain, target: self, action: #selector(MineSubVC.goBack))
        return navigationItem
    }
    func setUpUI(){
        //add(asChildViewController: Seg1VC())
        // 使用 UISegmentedControl(items:) 建立 UISegmentedControl
        // 參數 items 是一個陣列 會依據這個陣列顯示選項
        // 除了文字 也可以擺放圖片 像是 [UIImage(named:"play")!,"晚餐"]
        let mySegmentedControl = UISegmentedControl(items: ["早餐","午餐","晚餐","宵夜"])

        // 設置外觀顏色 預設為藍色
        mySegmentedControl.tintColor = UIColor.black

        // 設置底色 沒有預設的顏色
        mySegmentedControl.backgroundColor = UIColor.lightGray

        // 設置預設選擇的選項
        // 從 0 開始算起 所以這邊設置為第一個選項
        mySegmentedControl.selectedSegmentIndex = 0

        // 設置切換選項時執行的動作
        mySegmentedControl.addTarget(self, action: #selector(SectorVC.onChange), for: .valueChanged)

        // 設置尺寸及位置並放入畫面中
        mySegmentedControl.frame.size = CGSize(width: ScreenInfo.width * 0.8, height: 30)
        mySegmentedControl.center = CGPoint(x: ScreenInfo.width * 0.5, y: StatusBarAndNavigationBarH - 22)
        self.view.addSubview(mySegmentedControl)
        add(asChildViewController: Seg1VC())
    }
    // MARK: - View Methods
    // 切換選項時執行動作的方法
    @objc func onChange(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            remove(asChildViewController: Seg2VC())
            remove(asChildViewController: Seg3VC())
            remove(asChildViewController: Seg4VC())
            add(asChildViewController: Seg1VC())
        } else if sender.selectedSegmentIndex == 1{
            remove(asChildViewController: Seg1VC())
            remove(asChildViewController: Seg3VC())
            remove(asChildViewController: Seg4VC())
            add(asChildViewController: Seg2VC())
        } else if sender.selectedSegmentIndex == 2{
            remove(asChildViewController: Seg1VC())
            remove(asChildViewController: Seg2VC())
            remove(asChildViewController: Seg4VC())
            add(asChildViewController: Seg3VC())
        }else{
            remove(asChildViewController: Seg1VC())
            remove(asChildViewController: Seg2VC())
            remove(asChildViewController: Seg3VC())
            add(asChildViewController: Seg4VC())
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
        // Add Child View Controller
        addChildViewController(viewController)
        // Add Child View as Subview
        view.addSubview(viewController.view)
        // Configure Child View
        // viewController.view.frame = view.bounds
        viewController.view.frame = CGRect(x: 0, y: StatusBarAndNavigationBarH, width: self.view.frame.size.width, height: self.view.frame.size.height - StatusBarAndNavigationBarH)
        viewController.view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        // Notify Child View Controller
        viewController.didMove(toParentViewController: self)
    }
    fileprivate func remove(asChildViewController viewController: UIViewController) {
        // Notify Child View Controller
        viewController.willMove(toParentViewController: nil)
        // Remove Child View From Superview
        viewController.view.removeFromSuperview()
        // Notify Child View Controller
        viewController.removeFromParentViewController()
    }
}


