//
//  CustomTabBarVC.swift
//  Centers
//
//  Created by test on 2017/9/29.
//  Copyright © 2017年 com.youlu. All rights reserved.
//

import UIKit
class CustomTabBarVC: UITabBarController, TabBarItemsVDelegate {
    var popMenu:PopMenu!;
    static let customTabBar = CustomTabBar()
    let visualEffect = UIVisualEffectView.init(effect: UIBlurEffect.init(style: .extraLight))
    static func showBar(animated:Bool, duration : Double = 0.1) {
        UIView.animate(withDuration: duration, animations: {
            customTabBar.isHidden = false
            customTabBar.frame.origin.y = ScreenH - (TabBarH)
            //customTabBar.transform = CGAffineTransform.identity
        })
    }

    static func hideBar(animated:Bool, duration : Double = 0.1) {
        UIView.animate(withDuration: duration, animations: {
            customTabBar.frame.origin.y = ScreenH + 15
            customTabBar.isHidden = true
            //customTabBar.transform = CGAffineTransform(translationX: 0, y: TabBarH + 15)
        })
    }
    //增加通知
    override func viewDidLoad() {
        super.viewDidLoad()
        createMainTabBarChildViewController()
        addCustomTabBar()
        //添加代理
        //LoginVC.jumpDel = self  ,JumpDel

        LoginVC.addCtrlBlock = { [weak self] in
            STLog("YYYY");
        }
        let itemArray:Array<MenuItem> = [MenuItem(title: "项目", iconName: "pop_Project", position: 0),
             MenuItem(title: "任务", iconName: "pop_Task", position: 1),
             MenuItem(title: "状态", iconName: "pop_Tweet", position: 2),
             MenuItem(title: "好友", iconName: "pop_User", position: 3),
             MenuItem(title: "私信", iconName: "pop_Message", position: 4),
             MenuItem(title: "验证", iconName: "pop_2FA", position: 5),
         ];
        popMenu = PopMenu(frame:CGRect(x:0,y:0,width:ScreenInfo.width,height:ScreenInfo.height), item: itemArray);
        popMenu.type = .Diffuse;
        
        popMenu.itemClicked = { index in
            print("the \(index)'s item was clicked.");
        }
    }
    
    func createMainTabBarChildViewController() {
        tabBarControllerAddChildViewController(FindVC())
        tabBarControllerAddChildViewController(TabSwitchVC())
        //这个控制器暂时不起作用
        tabBarControllerAddChildViewController(UIViewController())
        tabBarControllerAddChildViewController(MessageVC())
        tabBarControllerAddChildViewController(MineVC())
    }
    func tabBarControllerAddChildViewController(_ childView: UIViewController) {
        let navigationVC = UINavigationController(rootViewController:childView)
        self.addChildViewController(navigationVC)
    }
    
    /// 添加自定义tabBar
    func addCustomTabBar() {
        CustomTabBarVC.customTabBar.tabBarView.delegate = self
        self.setValue(CustomTabBarVC.customTabBar, forKey: "tabBar")
    }
    // MARK: MQLTabBarItemsViewDelegate
    func didSelectItemAtIndex(view: TabBarItemsV, index: Int) -> Void{
        self.selectedIndex = index
    }
    func presentLoginVC(view: TabBarItemsV) {
//        visualEffect.frame = CGRect(x: 0, y: 0, width: ScreenW, height: ScreenH)
//        visualEffect.alpha = 0.5
//        self.view.addSubview(visualEffect)
        DispatchQueue.main.async{
            self.present(UINavigationController(rootViewController: LoginVC()), animated: false, completion: nil)
            //self.visualEffect.removeFromSuperview()
        }
    }
    func doJump() {
        //STLog("5435")
        tabBarControllerAddChildViewController(MineVC())
    }
    func didClickCenterItem(view: TabBarItemsV) -> Void{
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now(), execute: {
            //let postV = PostVC()
            self.popMenu.showMenuAtView(containerView:self.view);
            //push方式
            //self.navigationController?.pushViewController(sbV , animated: true)
            //present方式
            //self.present(postV, animated: false, completion: nil)
            //self.show(postV as UIViewController, sender: postV)
        })
    }
}
