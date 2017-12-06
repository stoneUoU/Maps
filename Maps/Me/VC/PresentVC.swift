
//
//  SettingVC.swift
//  Maps
//
//  Created by test on 2017/10/16.
//  Copyright © 2017年 com.youlu. All rights reserved.
//

import UIKit
class PresentVC: UIViewController,UIGestureRecognizerDelegate{
    var Mines = String()
    lazy var presentV: PresentV = {[weak self] in
        let Frame = CGRect(x: 0, y: 0, width: ScreenInfo.width, height: ScreenInfo.height)
        let presentV = PresentV(frame: Frame)
        presentV.cancelBlock = { [weak self] in
            PublicFunc.dismissCurrCtrl(selfCtrl: self!)
        }
        //闭包
        presentV.pushBlock = { (str1,str2) in
            print(str1,str2)
            //PublicFunc.presentToCommCtrl(selfCtrl: self!, otherCtrl: PushVC())
            PublicFunc.pushToNextCtrl(selfCtrl: self!, otherCtrl: PushVC())
        }
        return presentV
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
        self.view.backgroundColor = UIColor.white
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil);
        print(Mines,"Mines")
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
//        self.navigationItem.setHidesBackButton(true, animated: true)
//        navigationBar?.isTranslucent = false
//        navigationBar?.barStyle  =  UIBarStyle.default
//        navigationBar?.setBackgroundImage(UIImage(named: ""), for: UIBarMetrics.default)
        // 5.设置导航栏阴影图片
        //navigationBar?.shadowImage = UIImage()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
extension PresentVC{
    func setUpUI(){
        //self.buildNavigationItem()
//        navigationBar = UINavigationBar(frame: CGRect(x:0, y:20, width:ScreenInfo.width, height:44))
        self.view.addSubview(presentV)
    }
}

