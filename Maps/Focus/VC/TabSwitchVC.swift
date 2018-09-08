//
//  TabSwitchVC.swift
//  Maps
//
//  Created by test on 2017/11/24.
//  Copyright © 2017年 com.youlu. All rights reserved.
//

import UIKit
import SwiftyJSON
protocol FirstFDels: class {
    func dofirstFresh()
}
class TabSwitchVC: UIViewController {
    fileprivate lazy var tabSwitchVM : TabSwitchVM = TabSwitchVM()
    var segmentView : ZPSegmentBarView?
    var style = ZPStyle()
    var childVcs = [UIViewController]()
    //传值  将titleV的值传给contentV
    var demoVals = [String]()
    var demoIds = [String]()
    static var netBlock: (() -> ())?
    var titleIds : [String]!{
        didSet {
            for i in 0 ..< Int(self.titleIds.count)  {
                let vc = ContentVC()
                vc.intIndex = Int(self.titleIds[i])!
                childVcs.append(vc)
            }
        }
    }
    var titleVals : [String]! {
        didSet {
            //创建ZPSegmentBarView
            segmentView = ZPSegmentBarView(frame: CGRect(x: 0, y: -NavigationBarH, width: view.bounds.width, height: view.bounds.height - TabBarH), titles: self.titleVals, style: style, childVcs: childVcs, parentVc: self)
            self.view.addSubview(segmentView!)
        }
    }
    var netUseVals:String!
    var noticeObser:Bool? {
        didSet {
            _ = SnailNotice.add(observer: self, selector: #selector(TabSwitchVC.setNet(notification:)), notification: .netChange)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.setUpUI()
        self.navigationController?.navigationBar.isHidden = true
        style.titleViewBackgroundColor = .white //titleView背景颜色,默认是紫色
        style.normalColor = .darkGray
        style.selecteColor = .red
        style.isShowBottomLine=false
        style.isScrollEnabled=true; //标题是否可以滚动,默认为true;
        style.isNeedScale=true      //标题文字是否缩放,默认为true;
        startR()

        noticeObser = true //开启所有观察
        //监听是否有网
        netUseVals = keychain.get("ifnetUseful")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //移除通知
    deinit {
        STLog("销毁，TabSwitchVC")
        SnailNotice.remove(observer: self, notification: .netChange)
    }
}
extension TabSwitchVC{
    func setUpUI(){
        //自定义状态栏
        let statusView = UIView()
        statusView.backgroundColor = .white
        self.view.addSubview(statusView)
        statusView.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.width.equalTo(ScreenInfo.width)
            make.height.equalTo(UIDevice.isX() == true ? 44 : 20)
        }
    }
    func startR(){
        let paras = ["param":"none"] as [String : Any]
        tabSwitchVM.getTitleInfos(paras:paras){(result) in
            if JSON(result)["code"] == 0{
                for i in 0 ..< self.tabSwitchVM.tabSwitchMs.count{
                    self.demoVals.append(self.tabSwitchVM.tabSwitchMs[i].name)
                    self.demoIds.append(self.tabSwitchVM.tabSwitchMs[i].id)
                }
                self.demoVals.insert("最新", at: 0)
                self.demoIds.insert("\(FreshID)", at: 0)
                self.titleIds = self.demoIds
                self.titleVals = self.demoVals
            }
        }
    }
    @objc func setNet(notification:NSNotification) {
        netUseVals = notification.userInfo!["netUseful"] as! String
        if netUseVals == "Useable"{
            if keychain.get("currCtrl") == "\(self)"{
                STLog("刷新，TabSwitchVC")
                //闭包会主页刷新
                if TabSwitchVC.netBlock != nil {
                    TabSwitchVC.netBlock!()
                }
            }
        }
    }
}
