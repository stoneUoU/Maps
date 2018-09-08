//
//  AppDelegate.swift
//  Centers
//
//  Created by test on 2017/9/29.
//  Copyright © 2017年 com.youlu. All rights reserved.
//

import UIKit
import CoreData
import ReachabilitySwift
import IQKeyboardManagerSwift
import KeychainSwift
import ZLaunchAdVC
import MethodSDK
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    let reachability = Reachability()!
    var noticeObser:Bool? {
        didSet {
            _ = SnailNotice.add(observer: self, selector: #selector(AppDelegate.loadFirstCtrl), notification: .startFinish)
        }
    }
    //let visualEffect = UIVisualEffectView.init(effect: UIBlurEffect.init(style: .extraLight))
    // launchOptions:判断启动方式
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: ScreenBounds)
        window?.makeKeyAndVisible()
        // Do any additional setup after loading the view.
        noticeObser = true //开启所有观察
        //配置用户Key
        //AMapServices.shared().apiKey = mapKey
        //初始化MAMapView
        //AMapServices.shared().enableHTTPS = true
        IQKeyboardManager.sharedManager().enable = true

        // 检测网络连接状态
        if reachability.isReachable {
            //print("网络连接：可用")
            DispatchQueue.main.async {
                keychain.set("Useable", forKey: "ifnetUseful")
            }
        } else {
            DispatchQueue.main.async {
                keychain.set("unUseable", forKey: "ifnetUseful")
            }
        }
        reachability.whenReachable = { reachability in
            DispatchQueue.main.async {
                keychain.set("Useable", forKey: "ifnetUseful")
                if let currCtrl = PublicFunc.getCurrCtrl(){
                    //STLog("\(currCtrl)，appdel")
                    keychain.set("\(currCtrl)", forKey: "currCtrl");
                }
                SnailNotice.post(notification: .netChange,object: nil,passDicts: ["netUseful":"Useable"])
            }
        }
        reachability.whenUnreachable = { reachability in
            DispatchQueue.main.async {
                keychain.set("unUseable", forKey: "ifnetUseful")
                StToastSDK().showToast(text:"\(missNetTips)",type: Pos )
                SnailNotice.post(notification: .netChange,object: nil,passDicts: ["netUseful":"unUseable"])
            }
        }
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
        if launchOptions != nil {
            /// 通过推送方式启动
            if keychain.getBool("ifU") as? Bool == nil{
                window?.rootViewController = AppStartVC()
            }else{
                //不是第一次打开应用
                window?.rootViewController = TestVC()
            }
        } else {
            loadHomeViewCtrl()
        }
        return true
    }
    @objc func loadHomeViewCtrl() {
//        ZLaunchAdVC.clearDiskCache()
//        /// 加载广告
//        let adVC = ZLaunchAdVC(waitTime: 3,rootVC: CustomTabBarVC());
//        request { model in
//            adVC.configure { button, adView in
//                button.skipBtnType = model.skipBtnType
//                adView.animationType = model.animationType
//                adView.adFrame = CGRect(x: 0, y: 0, width: ScreenW, height: ScreenW*model.height/model.width)
//            }
//            adVC.setImage(UIImage(named: "ads2")!, duration: model.duration, action: {
//                keychain.set(true, forKey: "noticeD");
//            })
//        }
        self.window?.rootViewController = CustomTabBarVC()//adVC
    }
    @objc func loadFirstCtrl() {
        self.window?.rootViewController = CustomTabBarVC()
    }
    //MARK -- 程序辞去激活时调用的方法
    func applicationWillResignActive(_ application: UIApplication) {
//        visualEffect.frame = CGRect(x: 0, y: 0, width: ScreenW, height: ScreenH)
//        visualEffect.alpha = 0.5
//        application.keyWindow?.addSubview(visualEffect)
    }


    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        NotificationCenter.default.post(name: Notification.Name(rawValue: "LAYERANIMATION"), object: nil)

//        LaunchADView.setValue(imgURL: "http://cdn.duitang.com/uploads/item/201408/27/20140827062302_ymAJe.jpeg", webURL: "https://www.baidu.com", showTime: 3)
//        //  用于显示启动页。若启动数据更新，则将在下次启动后展示新的启动页
//        LaunchADView.show { (url) in
//            let vc = AdsVC()
//            vc.open_url = url!
//            if let currCtrl = PublicFunc.getCurrCtrl(){
//                currCtrl.navigationController?.pushViewController(vc, animated: true)
//            }
//        }
        DispatchQueue.main.async{
            self.window?.rootViewController?.present(UINavigationController(rootViewController: SetVC()), animated: false, completion: nil)
        }
    }

    //MARK -- 程序已经被激活时调用的方法
    func applicationDidBecomeActive(_ application: UIApplication) {
        //visualEffect.removeFromSuperview()
    }


    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
   
    }

}

extension AppDelegate {
    /// 模拟请求数据，此处解析json文件
    func request(_ completion: @escaping (AdModel)->()) -> Void {
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            if let path = Bundle.main.path(forResource: "data", ofType: "json") {
                let url = URL(fileURLWithPath: path)
                do {
                    let data = try Data(contentsOf: url)
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    if let dict = json as? [String: Any],
                        let dataArray = dict["data"] as? [[String: Any]] {
                        /// 随机显示
                        let idx = Int(arc4random()) % dataArray.count
                        let model = AdModel(dataArray[idx])
                        completion(model)
                    }
                } catch  {
                    print(error)
                }
            }
        }
    }
}

