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
    //增加通知
    override func viewDidLoad() {
        super.viewDidLoad()
        createMainTabBarChildViewController()
        addCustomTabBar()
        
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
    
    fileprivate func createMainTabBarChildViewController() {
        tabBarControllerAddChildViewController(FindVC())
        tabBarControllerAddChildViewController(TabSwitchVC())
        //这个控制器暂时不起作用
        tabBarControllerAddChildViewController(UIViewController())
        tabBarControllerAddChildViewController(MessageVC())
        tabBarControllerAddChildViewController(MineVC())
    }
    fileprivate func tabBarControllerAddChildViewController(_ childView: UIViewController) {
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
