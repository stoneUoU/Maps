//
//  MineVC.swift
//  Centers
//
//  Created by test on 2017/9/29.
//  Copyright © 2017年 com.youlu. All rights reserved.
//

import UIKit
import Dodo
import Whisper
import NMPopUpViewSwift
class MineVC: UIViewController,UIGestureRecognizerDelegate {
    //提示弹窗
    var popViewController : PopUpViewControllerSwift!
    var btnB:UIButton!
    var shareView:YSJShareView!
    //声明导航条
    var navigationBar:UINavigationBar?
    
    lazy var mineV: MineV = {[weak self] in
        let Frame = CGRect(x: 0, y: StatusBarAndNavigationBarH, width: ScreenInfo.width, height: ScreenInfo.height-StatusBarAndNavigationBarH)
        let mineV = MineV(frame: Frame)
        mineV.mineVDelegate = self
        return mineV
    }()
    fileprivate func buildNavigationItem() {//242,71,28
        //设置状态栏颜色
        navigationBar = UINavigationBar(frame: CGRect(x:0, y:UIDevice.isX() == true ? 44 : 20, width:ScreenInfo.width, height:44))
        navigationBar?.barStyle  =  UIBarStyle.default
        navigationBar!.setBackgroundImage(UIImage(named: "nav_f2471e.png"), for: UIBarMetrics.default)
        // 5.设置导航栏阴影图片
        navigationBar!.shadowImage = UIImage()
        navigationBar!.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        navigationBar!.tintColor = UIColor.white
        onAdd()
        self.view.addSubview(navigationBar!)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.view.backgroundColor = UIColor.white
        self.setRoundedBorder(5, withBorderWidth: 1, withColor: UIColor(red: 0.0, green: 122.0/2550, blue: 1.0, alpha: 1.0), forButton: btnB)
        //手势：
        let GesTar = self.navigationController?.interactivePopGestureRecognizer!.delegate
        let Ges = UIPanGestureRecognizer(target:GesTar,
                                         action:Selector(("handleNavigationTransition:")))
        Ges.delegate = self
        self.view.addGestureRecognizer(Ges)
        //同时禁用系统原先的侧滑返回功能
        self.navigationController?.interactivePopGestureRecognizer!.isEnabled = false
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        print("在此检测是否登录")
        navigationBar?.isTranslucent = false
        // 5.设置导航栏阴影图片
    }
    override func viewWillDisappear(_ animated: Bool) {
        HudTips.hideHUD(ctrl: self)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
extension MineVC:MineVDelegate,PassValueDelegate{
    func setupUI(){
        //自定义状态栏
        let statusView = UIView()
        statusView.backgroundColor = UIColor(patternImage: UIImage(named:"nav_f2471e.png")!)
        self.view.addSubview(statusView)
        statusView.snp_makeConstraints { (make) in
            //make.centerY.equalTo(topPic)
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.width.equalTo(ScreenInfo.width)
            make.height.equalTo(UIDevice.isX() == true ? 44 : 20)
        }
        self.buildNavigationItem()
        self.view.addSubview(mineV)
        shareView = YSJShareView.init(frame: CGRect(x:0, y:UIScreen.main.bounds.height - 180, width:UIScreen.main.bounds.width, height:180))
        shareView._delegate = self
        shareView.addItem(title: "", withImage: UIImage(named: "share_qq")!)
        shareView.addItem(title: "", withImage: UIImage(named: "share_friend")!)
        shareView.addItem(title: "", withImage: UIImage(named: "share_weibo")!)
        shareView.addItem(title: "", withImage: UIImage(named: "share_weChat")!)
        // Do any additional setup after loading the view, typically from a nib.
        //短信验证码登录
        btnB = UIButton.init(type: UIButtonType.custom)
        btnB.setTitle("我是林磊", for: UIControlState.normal)
        btnB.backgroundColor = UIColor.red
        btnB.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btnB.setTitleColor(UIColor.black, for: .normal) //普通状态下文字的颜色
        btnB.frame = CGRect(x:200,y:124,width:80,height:40)
        self.view.addSubview(btnB)
        MGHelpView.addHelpViewWithDisplayView(CGRect(x:200,y:124,width:80,height:40), spotlightType: SpotlightType.spotlightTypeRect
            , textImageName: "addBillHelp", textLocationType: TextLocationType.bottomLeft, tagString: "888888", completion: nil)




        let firstBtn = UILabel()
        firstBtn.frame = CGRect(x: 100, y: 100, width: ScreenInfo.width/3, height: 40)
        let previousPrice = "$" + "1000"
        let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: previousPrice, attributes: [NSFontAttributeName:UIFont(name: "HelveticaNeue-Light", size: 11.0)!])
        attributeString.addAttribute(NSBaselineOffsetAttributeName, value: 0, range: NSMakeRange(0, attributeString.length))
        attributeString.addAttribute(NSStrikethroughStyleAttributeName, value: 1, range: NSMakeRange(0, attributeString.length))
        attributeString.addAttribute(NSForegroundColorAttributeName, value: UIColor.lightGray, range: NSRange(location:0,length:attributeString.length))

        let currentPrice : NSMutableAttributedString = NSMutableAttributedString(string: "8888" + "    ")
        currentPrice.append(attributeString)
        firstBtn.attributedText = currentPrice
//        firstBtn.backgroundColor = UIColor.red
//        firstBtn.setTitle("点击测试", for: .normal)
//        firstBtn.addTarget(self, action:#selector(MineVC.toMessage), for:.touchUpInside)
//        firstBtn.titleLabel?.textColor = UIColor.white
        //self.view.addSubview(firstBtn)
    }
    func onAdd(){
        //给导航条增加导航项
        navigationBar?.pushItem(onMakeNavitem(), animated: true)
    }
    //创建一个导航项
    func onMakeNavitem()->UINavigationItem{
        let navigationItem = UINavigationItem()
        let rightBtn = UIBarButtonItem(title: "设置", style: UIBarButtonItemStyle.plain, target: self, action: #selector(MineVC.toMessage))
        let leftBtn = UIBarButtonItem(title: "消息", style: UIBarButtonItemStyle.plain, target: self, action: #selector(MineVC.toMessage))
        // left按钮
        navigationItem.setLeftBarButton(leftBtn, animated: true)
        // right按钮
        navigationItem.setRightBarButton(rightBtn, animated: true)

        return navigationItem
    }
    //定义一个带字符串参数的闭包
    //    func myClosure(testStr:String)->Void{
    //        //这句话什么时候执行？，闭包类似于oc中的block或者可以理解成c语言中函数，只有当被调用的时候里面的内容才会执行
    //        print(testStr);
    //    }
    //MARK: - passValueDelegate代理回调
    func passValue(passVals:String) {
        print("接收代理回调的值:\(passVals)")
    }
    func toSub(mineV: MineV) {
        shareView.show()
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now(), execute: {
//            let mineSubV = MineSubVC()
//            //push方式
//            //将闭包传递到二级界面，在二级界面中调用
//            mineSubV.testClosure = {
//                [unowned self](newValue:String) ->Void
//                in
//                print(newValue,"闭包回调传值")
//            }
//            //代理传值
//            mineSubV.delegate = self
//            PublicFunc.pushToNextCtrl(selfCtrl: self, otherCtrl: mineSubV,ifBackHaveTab:false)
//        })
    }
    func toAlertView(mineV: MineV) {
        PublicFunc.presentToNaviCtrl(selfCtrl: self, otherCtrl: PresentVC())
    }
    func toAlertTip(mineV: MineV) {
        //present方式
        let presentV = PresentVC()
        presentV.Mines = "Yeahs"
        PublicFunc.presentToNaviCtrl(selfCtrl: self, otherCtrl: presentV)
        //self.present(UINavigationController(rootViewController: PresentVC() as! UIViewController), animated: true, completion: nil)
    }
}

extension MineVC:YSJShareViewDelegate{
    func shareBtnClick(index: Int) {
        HudTips.showHUD(ctrl:self)
    }
    @objc func toSetting(btn:UIButton) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now(), execute: {
            PublicFunc.pushToNextCtrl(selfCtrl: self, otherCtrl: SettingVC(),ifBackHaveTab:false)
        })
    }
    func toMessage() {
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now(), execute: {
//            PublicFunc.pushToNextCtrl(selfCtrl: self, otherCtrl: ContentVC(),ifBackHaveTab:false)
//        })
    }
    func setRoundedBorder(_ radius : CGFloat, withBorderWidth borderWidth: CGFloat, withColor color : UIColor, forButton button : UIButton)
    {
        let l : CALayer = button.layer
        l.masksToBounds = true
        l.cornerRadius = radius
        l.borderWidth = borderWidth
        l.borderColor = color.cgColor
    }
    //手势代码：
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if self.navigationController?.viewControllers.count == 1 {
            return false
        }
        return true
    }
}

