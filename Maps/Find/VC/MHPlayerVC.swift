
//
//  MHPlayerVC
//  Maps
//
//  Created by test on 2017/11/6.
//  Copyright © 2017年 com.youlu. All rights reserved.
//
import UIKit

class MHPlayerVC: UIViewController,UIGestureRecognizerDelegate{
    //声明导航条
    var navigationBar:UINavigationBar!
    var player = ZYPlayer()
    var autoV = UIView()
    let alert = TipAlert(message: "卖萌求鼓励\nXXX新版本用着还喜欢么，给点鼓励好不好呢？", image: UIImage(named: "exampleImage")!)
    var needToUpdate : Bool = true
    //假设服务器传过来的最新的版本号是0.0.3
    var newVersion : String = "1.0.5"

    var currentNodeName:String!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
        self.view.backgroundColor = UIColor.white

        alert.acceptBlock = {
            print("去评价了！")
        }
        alert.denyBlock = {
            print("其实我是拒绝的")
        }
        alert.forceBlock = {
            print("强制更新")
        }

        //        获取当前的版本号
        let currentVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString")

        self.needToUpdate = self.compareVersionUpdate(newVersion: self.newVersion, currentVersion: currentVersion as! String)

        //手势：
        let GesTar = self.navigationController?.interactivePopGestureRecognizer!.delegate
        let Ges = UIPanGestureRecognizer(target:GesTar,
                                         action:Selector(("handleNavigationTransition:")))
        Ges.delegate = self
        self.view.addGestureRecognizer(Ges)
        //同时禁用系统原先的侧滑返回功能
        self.navigationController?.interactivePopGestureRecognizer!.isEnabled = false
    }
    func compareVersionUpdate(newVersion : String, currentVersion : String) -> Bool {
        let newVersionArr = newVersion.components(separatedBy: ".")
        let currVersionArr = currentVersion.components(separatedBy: ".")
        var newVersionCount = Double(newVersionArr.joined(separator: ""))
        var currVersionCount = Double(currVersionArr.joined(separator: ""))
        if newVersionArr.count > currVersionArr.count {
            currVersionCount = currVersionCount! * pow(10, Double(newVersionArr.count - currVersionArr.count))
        }else{
            newVersionCount = newVersionCount! * pow(10, Double(currVersionArr.count - newVersionArr.count))
        }
        if newVersionCount! > currVersionCount! {
            return true
        }else{
            return false
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.setHidesBackButton(true, animated: true)
        navigationBar?.isTranslucent = false
        CustomTabBarVC.hideBar(animated: true);
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension MHPlayerVC{
    func setUpUI(){
        navigationBar = UINavigationBar(frame: CGRect(x:0, y:UIDevice.isX() == true ? 44 : 20, width:ScreenInfo.width, height:44))
        self.view.addSubview(navigationBar)
        onAdd()
        // 将整个ZYPlayer文件夹拖拽到你的项目中即可，无其他依赖
        // 扩展或者调整UI，建议直接在xib中修改。
        // 总共代码精简在500行左右，如果想增加牛逼功能，请先阅读代码，注释已经不能再详细了

        // 注意：在使用前，请注意自己项目的部署关系，由于屏幕旋转需要手动进行，所以请参见demo内的ZYTabBarController的重新两个方法，将代码拷贝到你的rootViewController 中，并且按照注释进行简单配置
        // 这样无论你的项目是否支持横竖屏，播放器的旋转都不会有问题

        // 创建播放器的初始化方法
        player = ZYPlayer(nibName: "ZYPlayer", bundle: nil, onView: self.view, orgFrame: CGRect(x: 0, y: StatusBarAndNavigationBarH, width: view.bounds.width, height: view.bounds.width*9/16), url: "http://media.vtibet.com/masvod/public/2014/01/23/20140123_143bd4c1b14_r1_300k.mp4")
        // 下面是可选的属性设置
        player.fillMode = .resizeAspectFill
        //        player.bgView = ...
        //        player.centerBtn ....
        //        player.state (获取播放状态)

        // 特别注意: 当你需要切换其他界面的时候，请调用下面的方法，销毁播放器，避免内存泄漏
        //        player.releasePlayer()

        view.addSubview(player.view)
        addChildViewController(player)
//        player.view.snp.makeConstraints{
//            (make) in
//            make.top.equalTo(self.navigationBar!.snp.bottom).offset(0)
//            make.left.equalTo(0)
//            make.width.equalTo(ScreenInfo.width)
//            make.height.equalTo(ScreenInfo.width/2)
//        }

        autoV.backgroundColor = .cyan
        self.view.addSubview(autoV)
        autoV.snp.makeConstraints{
            (make) in
            make.top.equalTo(self.player.view.snp.bottom).offset(0)
            make.left.equalTo(0)
            make.width.equalTo(ScreenInfo.width)
            make.height.equalTo(ScreenInfo.width/2)
        }

        let btn = UIButton(type: .custom)
        btn.frame = CGRect.zero
        btn.setTitle("防止button被连续点击1", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = UIColor.red
        //btn.ignoreInterval = false
        //btn.customInterval = 1
        btn.addTarget(self, action: #selector(click), for: .touchUpInside)
        self.view.addSubview(btn)
        btn.snp.makeConstraints{
            (make) in
            make.top.equalTo(self.autoV.snp.bottom).offset(48)
            make.left.equalTo(0)
            make.width.equalTo(ScreenInfo.width)
            make.height.equalTo(48)
        }

        let btnFalse = UIButton(type: .custom)
        btnFalse.frame = CGRect.zero
        btnFalse.setTitle("防止button被连续点击2", for: .normal)
        btnFalse.setTitleColor(.white, for: .normal)
        btnFalse.backgroundColor = UIColor.red
        btnFalse.addTarget(self, action: #selector(funcFalse), for: .touchUpInside)
        //btnFalse.ignoreInterval = true
        //btnFalse.customInterval = 1
        self.view.addSubview(btnFalse)
        btnFalse.snp.makeConstraints{
            (make) in
            make.top.equalTo(btn.snp.bottom).offset(48)
            make.left.equalTo(0)
            make.width.equalTo(ScreenInfo.width)
            make.height.equalTo(48)
        }

    }
    func click(){
//        let dic = ["stone":"a","acd":"c","abc":"c","1nlei":"b"]
//        print(dic["stone"])
//        let result = dic.sorted {$0.0 < $1.0}
//        print(result)
        STLog("1234");
//        let payAlert = DNPayAlertView(frame: CGRect.zero)
//        payAlert.setTitle("请输入支付密码")
//        payAlert.setDetail("提现")
//        payAlert.setAmount(10)
//        payAlert.completeBlock = ({(password: String) -> Void in
//            print("password" + password)
//        })
//        payAlert.show()
        //STLog(STCacheTool.cacheSize)
    }
    func funcFalse(){
        STCacheTool.clearCache()
        STLog(STCacheTool.cacheSize)
        //updateDetailArray:传入更新的内容数组
        //isForcedUpdate:是否进行强制更新
        //versionStr：版本号
        //updateURLString：跳转地址
        if self.needToUpdate {
            let versionAlertView = VersionAlertView.init(updatedDelArray: ["修复bug,增加内购功能,888888888888888是否进行强制更新是否进行强制更新88888是否进行强制更新是否进行强制更新88888是否进行强制更新是否进行强制更新"], isForcedUpdate: true, versionStr: "V\(self.newVersion)",updateURLString: "https://itunes.apple.com/app/id1296719144")
            versionAlertView.show()
        }
       // alert.show(closeBtnHide: false, btnTitleArr: ["下次再说","立即更新"])
//        PayAlert.titleInfo = "请设置支付密码"
//        PayAlert.receAmount = "0"
//        PayAlert.methodInfo = "OO"
//        PayAlert.ifMoneyDisplay = false
//        let payAlert = PayAlert(frame: UIScreen.main.bounds)
//        payAlert.show(view: self.view)
//        payAlert.completeBlock = ({(password:String) -> Void in
//            print("输入的密码是:" + password)
//        })
    }
    func onAdd(){
        //给导航条增加导航项
        navigationBar?.pushItem(onMakeNavitem(), animated: true)
    }
    //创建一个导航项
    func onMakeNavitem()->UINavigationItem{
        var navigationItem = UINavigationItem()
        //设置导航栏标题
        navigationItem.title = "MHPlayer"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"icon_return.png"), style: .plain, target: self, action: #selector(MHPlayerVC.goBack))
        return navigationItem
    }
    @objc func goBack() {
        DispatchQueue.main.async{
            self.navigationController?.popViewController(animated: true)
        }
    }
    @objc func sendNotice(_:UIButton){
        //发送通知
        SnailNotice.post(notification: .happy,object: nil,passDicts: ["success":"true"])
    }
    //手势代码：
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if self.navigationController?.viewControllers.count == 1 {
            return false
        }
        return true
    }
}



