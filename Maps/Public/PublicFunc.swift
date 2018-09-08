//
//  PublicFunc.swift
//  Maps
//
//  Created by test on 2017/11/16.
//  Copyright © 2017年 com.youlu. All rights reserved.
//

import UIKit

class PublicFunc: NSObject {
    //设置高度适配界面
    static func setHeight(size:CGFloat) -> CGFloat {
        //Mark: ScreenInfo.height,手机屏幕的高度,开发都以6、6s、7、8开发为准
        if(UIScreen.main.bounds.height <= 667){  // 6 6S 7
            return size
        }else{
            return size * UIScreen.main.bounds.height/667
        }
    }
    //pop回来是否显示tabbar   true:不显示 false:显示
    static func pushToNextCtrl(selfCtrl:UIViewController,otherCtrl:UIViewController,ifBackHaveTab:Bool = true){
        //MARK :使用方法  push方式
        //1.传参使用:
        //let someV = SomeVC()
        //someV.someVals = ["param1":1,"param2":"Stone"]
        //接收参数的控制器： var someVals:[String : Any] = [String : Any]()
        //PublicFunc.pushToNextCtrl(selfCtrl: self, otherCtrl: someV,ifBackHaveTab:false)

        //2.不传参使用:
        //PublicFunc.pushToNextCtrl(selfCtrl: self, otherCtrl: someV(),ifBackHaveTab:false)
        DispatchQueue.main.async{
            //CustomTabBarVC.hideBar();
            otherCtrl.hidesBottomBarWhenPushed = true
            selfCtrl.navigationController?.pushViewController(otherCtrl , animated: true)
            ifBackHaveTab == false ? selfCtrl.hidesBottomBarWhenPushed = false : print("不显示tabbar")
        }
    }
    //pop回前一个控制器
    static func popToPrevCtrl(selfCtrl:UIViewController){
        DispatchQueue.main.async{
            selfCtrl.navigationController?.popViewController(animated: true)
        }
    }
    //pop回前n个控制器
    static func popToSomeCtrl(selfCtrl:UIViewController,otherCtrl:AnyClass){
        DispatchQueue.main.async{
            let temArray: [UIViewController]? = selfCtrl.navigationController?.viewControllers
            for temVC: UIViewController in temArray! {
                if (temVC .isKind(of: otherCtrl)) {
                    selfCtrl.navigationController?.popToViewController(temVC, animated: true)
                }
            }
        }
    }
    static func presentToNaviCtrl(selfCtrl:UIViewController,otherCtrl:UIViewController){
        //MARK :使用方法  present方式进入导航控制器
        //1.传参使用:
        //let someV = SomeVC()
        //someV.someVals = ["param1":1,"param2":"Stone"]
        //接收参数的控制器： var someVals:[String : Any] = [String : Any]()
        //PublicFunc.presentToNaviCtrl(selfCtrl: self, otherCtrl: someV)

        //2.不传参使用:
        //PublicFunc.presentToNaviCtrl(selfCtrl: self, otherCtrl: someV())
        otherCtrl.modalTransitionStyle = .flipHorizontal //.partialCurl向上
        otherCtrl.modalPresentationStyle = .popover
//        case fullScreen
//
//        @available(iOS 3.2, *)
//        case pageSheet
//
//        @available(iOS 3.2, *)
//        case formSheet
//
//        @available(iOS 3.2, *)
//        case currentContext
//
//        @available(iOS 7.0, *)
//        case custom
//
//        @available(iOS 8.0, *)
//        case overFullScreen
//
//        @available(iOS 8.0, *)
//        case overCurrentContext
//
//        @available(iOS 8.0, *)
//        case popover
//
//
//        @available(iOS 7.0, *)
//        case none
        DispatchQueue.main.async{
            selfCtrl.present(UINavigationController(rootViewController: otherCtrl), animated: true, completion: nil)
        }
    }
    static func presentToCommCtrl(selfCtrl:UIViewController,otherCtrl:UIViewController){
        //MARK :使用方法  present方式进入普通控制器
        //1.传参使用:
        //let someV = SomeVC()
        //someV.someVals = ["param1":1,"param2":"Stone"]
        //接收参数的控制器： var someVals:[String : Any] = [String : Any]()
        //PublicFunc.presentToCommCtrl(selfCtrl: self, otherCtrl: someV)

        //2.不传参使用:
        //PublicFunc.presentToCommCtrl(selfCtrl: self, otherCtrl: someV())
        DispatchQueue.main.async{
            selfCtrl.present(otherCtrl, animated: true, completion: nil)
        }
    }
    static func dismissCurrCtrl(selfCtrl:UIViewController){
        //MARK :
        DispatchQueue.main.async{
            selfCtrl.dismiss(animated: true, completion: nil)
        }
    }
    //获取当前控制器
    class  func getCurrCtrl() -> UIViewController? {

        guard let window = UIApplication.shared.windows.first else {
            return nil
        }

        var tempView: UIView?

        for subview in window.subviews.reversed() {
            if subview.classForCoder.description() == "UILayoutContainerView" {

                tempView = subview

                break
            }
        }

        if tempView == nil {

            tempView = window.subviews.last
        }

        var nextResponder = tempView?.next

        var next: Bool {
            return !(nextResponder is UIViewController) || nextResponder is UINavigationController || nextResponder is UITabBarController
        }

        while next{

            tempView = tempView?.subviews.first

            if tempView == nil {

                return nil
            }

            nextResponder = tempView!.next
        }

        return nextResponder as? UIViewController
    }
}
