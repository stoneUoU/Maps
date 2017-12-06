//
//  MessageVC.swift
//  Centers
//
//  Created by test on 2017/9/29.
//  Copyright © 2017年 com.youlu. All rights reserved.
//

import UIKit
import SwiftyJSON
import RxSwift
import FTIndicator
class MessageVC: UIViewController,UIGestureRecognizerDelegate {
    lazy var safeAreas = UIView()
    fileprivate lazy var messageVM : MessageVM = MessageVM()
    // MARK: - Build UI
    lazy var messageV: MessageV = {[weak self] in
        let AllFrame = CGRect(x: 0, y: 0, width: ScreenInfo.width, height: ScreenInfo.height)
        let messageV = MessageV(frame: AllFrame)
        messageV.messageVDelegate = self
        return messageV
    }()
    //声明导航条
    var navigationBar:UINavigationBar?
    fileprivate func buildNavigationItem() {//242,71,28
        //设置状态栏颜色
        navigationBar = UINavigationBar(frame: CGRect(x:0, y:UIDevice.isX() == true ? 44 : 20, width:ScreenInfo.width, height:44))
        navigationBar?.barStyle  =  UIBarStyle.default
        onAdd()
        self.view.addSubview(navigationBar!)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        navigationBar?.isTranslucent = false
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.view.backgroundColor = UIColor.white
        self.buildNavigationItem()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target:self, action:#selector(MessageVC.handleTap(sender:))))
        //safeAreas.backgroundColor = .red
        //self.view.addSubview(safeAreas)
//        safeAreas.snp.makeConstraints{
//            (make) -> Void in
//            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(0)
//            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).offset(0)
//            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).offset(0)
//            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(0)
//        }
        HudTips.showHUD(ctrl: self)
        let paras = ["opr":"cart_infos"] as [String : Any]
        self.messageVM.toTest(paras:paras){(result) in
            if JSON(result)["status"] == 0{
                DispatchQueue.main.async{
                    HudTips.hideHUD(ctrl: self)
                    //StToast().showToast(text:"\(JSON(result)["info"])",type:.top)
                    self.messageV.amountVals.text = "\(JSON(result)["data"]["b_amount"])"
                    self.messageV.countVals.text = "\(JSON(result)["data"]["b_count"])"
                }
            }else{
                DispatchQueue.main.async{
                    HudTips.hideHUD(ctrl: self)
                    //StToast().showToast(text:"\(JSON(result)["info"])",type:.top)
                }
            }
        }

        //手势：
        let GesTar = self.navigationController?.interactivePopGestureRecognizer!.delegate
        let Ges = UIPanGestureRecognizer(target:GesTar,
                                         action:Selector(("handleNavigationTransition:")))
        Ges.delegate = self
        self.view.addGestureRecognizer(Ges)
        //同时禁用系统原先的侧滑返回功能
        self.navigationController?.interactivePopGestureRecognizer!.isEnabled = false

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
extension MessageVC:MessageVDelegate{
    func setupUI(){
        self.view.addSubview(messageV)
//        let scrollView = UIScrollView()
//        view.addSubview(scrollView)
//        scrollView.snp.makeConstraints{(make) -> Void in
//            make.edges.equalTo(self.view)
//        }
//        let container = UIView()
//        scrollView.addSubview(container)
//        container.snp.makeConstraints{(make) -> Void in
//            make.edges.equalTo(scrollView)
//            make.width.equalTo(scrollView)
//        }
//        let redView = UIView()
//        redView.backgroundColor = UIColor.red
//        scrollView.addSubview(redView)
//        redView.snp.makeConstraints{(make) -> Void in
//            make.left.right.top.equalTo(scrollView)
//            make.height.equalTo(600)
//        }
//        let blueView = UIView()
//        blueView.backgroundColor = UIColor.blue
//        scrollView.addSubview(blueView)
//        blueView.snp.makeConstraints{(make) -> Void in
//            make.top.equalTo(redView.snp.bottom)
//            make.left.right.equalTo(scrollView)
//            make.height.equalTo(400)
//            make.bottom.equalTo(container)
//        }
    }
    func toPrints(messageV: MessageV) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now(), execute: {
            PublicFunc.pushToNextCtrl(selfCtrl: self, otherCtrl: ScanVC(),ifBackHaveTab:false)
        })
    }

    func onAdd(){
        //给导航条增加导航项
        navigationBar?.pushItem(onMakeNavitem(), animated: true)
    }
    //创建一个导航项
    func onMakeNavitem()->UINavigationItem{
        let navigationItem = UINavigationItem()
        let rightBtn = UIBarButtonItem(title: "搜索", style: UIBarButtonItemStyle.plain, target: self, action: #selector(MessageVC.toSearch))
        let leftBtn = UIBarButtonItem(title: "分段", style: UIBarButtonItemStyle.plain, target: self, action: #selector(MessageVC.toMessage))

        // 设置导航栏标题
        navigationItem.title = "RXSwift测试"
        // left按钮
        navigationItem.setLeftBarButton(leftBtn, animated: true)
        // right按钮
        navigationItem.setRightBarButton(rightBtn, animated: true)

        return navigationItem
    }
    func toSearch(){
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now(), execute: {
            PublicFunc.pushToNextCtrl(selfCtrl: self, otherCtrl: SearchVC(),ifBackHaveTab:false)
        })
    }
    func toMessage(){
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now(), execute: {
            PublicFunc.pushToNextCtrl(selfCtrl: self, otherCtrl: ViewVC(),ifBackHaveTab:false)
        })
    }
    func toAlter(messageV: MessageV) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now(), execute: {
            let amationV = AmationVC()
            //amationV.passVals = ["param1":1,"param2":"Stone"]
            //amationV.hidesBottomBarWhenPushed = true
            PublicFunc.pushToNextCtrl(selfCtrl: self, otherCtrl: amationV,ifBackHaveTab:false)
        })
//        let view = CardView.init(frame: self.view.bounds)
//        view.backgroundColor = UIColor.purple
//        view.textLabel?.text = "4353245"
//        view.setView(frame: self.view.bounds)
    }
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        super.prepare(for: segue, sender: nil)
//        
//        guard let popupVC = segue.destination as? PopupVC else { return }
//        
//        popupVC.customBlurEffectStyle = .light
//    }
//    MessageVMDelegate
//    messageVM.messageVMDelegate = self
//    func toExecute(messageVM: MessageVM, strCode:Int) {
//        if strCode == 0{
//            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now(), execute: {
//                print("5555")
//            })
//        }
//    }
    //手势代码：
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if self.navigationController?.viewControllers.count == 1 {
            return false
        }
        return true
    }

    //对应方法
    func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            messageV.telField.resignFirstResponder()
        }
        sender.cancelsTouchesInView = false
    }
}


