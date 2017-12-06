//
//  FindVC.swift
//  Centers
//
//  Created by test on 2017/9/29.
//  Copyright © 2017年 com.youlu. All rights reserved.
//

import UIKit
import FTIndicator
import MJRefresh
import Whisper
import Moya
import SwiftyJSON
import RxSwift
//class MyPinAnnotation:MAPointAnnotation{}
class FindVC: UIViewController{
    var leftButton:UIButton?
    //var coRate:CLLocationCoordinate2D?
    fileprivate lazy var findVM : FindVM = FindVM()
    lazy var findV: FindV = {[weak self] in
        let Frame = CGRect(x: 0, y: 0, width: ScreenInfo.width, height: ScreenInfo.height)
        let findV = FindV(frame: Frame)
        findV.findVDelegate = self
        findV.horMoveV.horMoveVDelegate = self
        return findV
        }()

    //    lazy var locationM: CLLocationManager = {//info.plist add :Privacy - Location Always Usage Description
    //        let locationM = CLLocationManager()
    //        locationM.delegate = self
    //        return locationM
    //    }()
    //    lazy var geoCoder: CLGeocoder = {
    //        return CLGeocoder()
    //    }()
    //    var mapView:MAMapView?//定义mapview
    //    var search:AMapSearchAPI?//定义searchAPI
    //    var pin:MyPinAnnotation!
    //    var nearSearch:Bool = true
    //var startO,stopO:CLLocationCoordinate2D!
    //let r = MAUserLocationRepresentation()  //自定义定位小蓝点,初始化 MAUserLocationRepresentation 对象
    //    var myObserver:Bool? {
    //        didSet {
    //            _ = SnailNotice.add(observer: self, selector: #selector(FindVC.reload(notification:)), notification: .happy)
    //        }
    //    }


    //    override func viewDidAppear(_ animated: Bool) {
    //        let pointAnnotation = MAPointAnnotation()
    //        pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: 39.979590, longitude: 116.352792)
    //        mapView?.addAnnotation(pointAnnotation)
    //    }
    lazy var pageTitleView: PageTitleView = {[weak self] in

        //        屏幕的宽度 UIScreen.main.bounds.width
        let titleFrame = CGRect(x: 0, y: CGFloat(300), width: ScreenInfo.width, height: CGFloat(48))
        let titles = ["推荐","游戏"]
        let titleView = PageTitleView(frame: titleFrame, titles: titles)
        titleView.backgroundColor = UIColor.white
        titleView.delegate = self
        return titleView
        }()

    lazy var pageContentView:PageContentView = {[weak self] in
        //1. 确定内容的frame
        let contentFrame = CGRect(x: 0, y: CGFloat(350), width: ScreenInfo.width,height: 500)
        //2. 确定所有的子控制器
        var childVcs = [UIViewController]()
        for _ in 0..<1{
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor(r: CGFloat(arc4random_uniform(255)), g: CGFloat(arc4random_uniform(255)), b: CGFloat(arc4random_uniform(255)))
            childVcs.append(vc)
        }
        let contentView = PageContentView(frame: contentFrame, childVcs: childVcs, parentViewController: self)
        contentView.delegate = self
        return contentView
        }()
    var netUseVals:String!
    var noticeObser:Bool? {
        didSet {
            _ = SnailNotice.add(observer: self, selector: #selector(FindVC.setNet(notification:)), notification: .netChange)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        //self.buildNavigationItem()
        self.findV.buildNavigationItem()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.view.backgroundColor = UIColor.white
        noticeObser = true //开启所有观察
        //监听是否有网
        netUseVals = keychain.get("ifnetUseful")
//        TouchIdManager.touchIdWithHand(fallBackTitle: "", succeed: {
//            STLog("解锁成功")
//        }) { (error) in
//            print(error.localizedDescription)
//        }
        getDatas()
        //self.getAuthority()
        //手动调用刷新效果
        //findV.freshH.beginRefreshing()
        //        print("DispatchQueue.main.sync: befor", Thread.current)
        //        DispatchQueue.global().async {
        //            print("DispatchQueue.global().async: Time task", Thread.current, "\n --: 耗时操作在后台线程中执行！")
        //
        //            DispatchQueue.main.async {
        //                print("DispatchQueue.main.async: update UI", Thread.current, "\n --: 耗时操作执行完毕后在主线程更新 UI 界面！")
        //            }
        //        }
        //        print("DispatchQueue.main.sync: after", Thread.current)

        //print("华丽的分界线====================华丽的分界线")
        func async() {

            print("DispatchQueue.global().async: befor", Thread.current)
            // 全局队列进行 10次异步
            for index in 0..<10 {

                //DispatchQueue.global().async {
                //DispatchQueue.main.async {
                DispatchQueue.main.sync{
                    //print("DispatchQueue.global().async: task:(taskIndex:\(index)", Thread.current)
                }
            }
            //print("DispatchQueue.global().async: after", Thread.current)
        }
        func sync() {
            //print("DispatchQueue.global().sync: befor", Thread.current)
            for index in 0..<10 {
                DispatchQueue.global().sync {
                    print("DispatchQueue.global().sync: task:(taskIndex:\(index))", Thread.current)
                }
            }
            //print("DispatchQueue.global().sync: after", Thread.current)
        }
        
        //func startNet(){
        func startNet(){
            Network.request(.mineAPI(["opr":"search","data":["vals":""]] as [String : Any]), success: { json in
                //获取歌曲信息
                //print(json,"获取歌曲信息")
            }, error: { statusCode in
                //服务器报错等问题
                //print("请求错误！错误码：\(statusCode)")
            }, failure: { error in
                //没有网络等问题
                //print("请求失败！错误信息：\(error.errorDescription ?? "")")
            })
        }
        startNet()

//        func startRx(){
//            RxHttpProvider.request(.mineAPI(["opr":"search","data":["vals":""]] as [String : Any])).filterSuccessfulStatusCodes()
//                .mapJSON()
//                .subscribe(onNext: { (json) in
//                    //do something with posts
//                    print(json,"RxJson")
//                })
//                .addDisposableTo(DisposeBag)
//        }
//        startRx()
            //使用我们的provider进行网络请求（获取频道列表数据）
//            HttpbinProvider.request(.mineAPI(["opr":"search","data":["vals":""]] as [String : Any])) { result in
//                switch result {
//                case let .success(response):
//                    do {
//                        //过滤成功的状态码响应
//                        try response.filterSuccessfulStatusCodes()
//                        let data = JSON(response.data) // 响应数据
//                        print(data,"oooo")
//                        //继续做一些其它事情....
//                    }
//                    catch {
//                        //处理错误状态码的响应...
//                    }
//                //继续做一些其它事情....
//                case let .failure(error):
//                    //错误处理....
//                    break
//                }
//            }
//        }
//        startNet()
        //async()
        //async()

    }
    //    override func viewWillDisappear(_ animated: Bool) {
    //        super.viewWillDisappear(animated)
    //        locationM.stopUpdatingLocation()
    //    }
    //移除通知
    deinit {
        SnailNotice.remove(observer: self, notification: .netChange)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
//MAMapViewDelegate
//extension FindVC:FindVDelegate,ReturnValDelegate{
//    func setupUI(){
//        //搭地图
////        mapView = MAMapView(frame: self.view.bounds)
////        mapView?.delegate = self
////        //        r.showsAccuracyRing = false   //精度圈是否显示
////        //        r.showsHeadingIndicator = false  //是否显示蓝点方向指向
////        //        r.fillColor = UIColor.red   //调整精度圈填充颜色
////        //        r.strokeColor = UIColor.blue   //调整精度圈边线颜blue色
////        //        r.lineWidth = 2     //调整精度圈边线宽度gray
////        //        r.enablePulseAnnimation = false  //精度圈是否显示律动效果
////        //        r.locationDotBgColor = UIColor.gray  //调整定位蓝点的背景颜色
////        //        r.locationDotFillColor = UIColor.blue //调整定位蓝点的颜色
////        mapView?.isShowsIndoorMap = true
////        //mapView?.update(r)
////        mapView?.showsScale = true
////        mapView?.scaleOrigin = CGPoint(x: 10, y: 10)
////        mapView?.logoCenter = CGPoint(x: 10, y: 10)
////        mapView?.showsUserLocation = true
////        mapView?.userTrackingMode = .follow
////        //获取POI数据
////        search = AMapSearchAPI()
////        search?.delegate = self
//
//        //        let request = AMapPOIKeywordsSearchRequest()
//        //        request.keywords = "麦当劳"
//        //        request.requireExtension = true
//        //        request.city = "南昌"
//        //
//        //        request.cityLimit = true
//        //        request.requireSubPOIs = true
//        //        //发起POI关键字搜索
//        //        search?.aMapPOIKeywordsSearch(request)
//        //self.view.addSubview(mapView!)
//
//
//        //self.buildNavigationItem()
//
////        let localBtn = UILabel()
////        localBtn.text = "定位"
////        localBtn.textColor = UIColor.colorWithCustom(242,g:72,b:28)
////        localBtn.font=UIFont.UiBoldFontSize(size: 18)
////        localBtn.textAlignment = .center
////        //将label用户交互设为true
////        localBtn.isUserInteractionEnabled = true
////        let posGes = UITapGestureRecognizer(target: self, action: #selector(self.position(_:)))
////        localBtn.addGestureRecognizer(posGes)
////        self.view.addSubview(localBtn)
////        localBtn.snp_makeConstraints { (make) in
////            make.bottom.equalTo(-PublicFunc.setHeight(size:60))
////            make.left.equalTo(0)
////            make.width.equalTo(ScreenInfo.width/3)
////            make.height.equalTo(PublicFunc.setHeight(size: 30))
////        }
//        self.view.addSubview(findV)
//        //self.view.bringSubview(toFront: self.findV.localBtn)
//    }
//    func onAdd(){
//        //给导航条增加导航项
//        navigationBar?.pushItem(onMakeNavitem(), animated: true)
//    }
//    //创建一个导航项
//    func onMakeNavitem()->UINavigationItem{
//        var navigationItem = UINavigationItem()
//        navigationItem.title = "发现"
//        leftButton = UIButton(frame: CGRect(x:0, y:0, width:70, height:40))
//        leftButton!.titleLabel?.font = UIFont.systemFont(ofSize: 16)
//        leftButton!.setTitleColor(UIColor.black, for: .normal)
//        leftButton!.addTarget(self, action:#selector(FindVC.changeCity(sender:)), for: UIControlEvents.touchUpInside)
//        leftButton!.setImage(UIImage(named: "icon_tab_guaguatiandi_selected.png"), for: UIControlState.normal)
//        leftButton?.imageEdgeInsets = UIEdgeInsetsMake(0, -9, 0, 0)
//        leftButton?.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
//        let leftItem:UIBarButtonItem = UIBarButtonItem(customView: leftButton!)
//        navigationItem.leftBarButtonItem = leftItem
//        return navigationItem
//    }
//    //搜索周边
////    func searchCustomLocation(_ center:CLLocationCoordinate2D){
////        let request = AMapPOIAroundSearchRequest()
////        request.location = AMapGeoPoint.location(withLatitude: CGFloat(center.latitude), longitude: CGFloat(center.longitude))
////        request.keywords = "超市"
////        request.radius = 600
////        request.requireExtension = true
////        search?.aMapPOIAroundSearch(request)
////    }
//
//
//    //获取权限
////    func getAuthority(){
////        if(CLLocationManager.authorizationStatus() != .denied) {
////            print("应用拥有定位权限")
////            locationM.startUpdatingLocation()
////        }else {
////            let aleat = UIAlertController(title: "打开定位开关", message:"定位服务未开启,请进入系统设置>隐私>定位服务中打开开关,并允许xxx使用定位服务", preferredStyle: .alert)
////            let tempAction = UIAlertAction(title: "取消", style: .cancel) { (action) in
////            }
////            let callAction = UIAlertAction(title: "立即设置", style: .default) { (action) in
////                let url = NSURL.init(string: UIApplicationOpenSettingsURLString)
////                if(UIApplication.shared.canOpenURL(url! as URL)) {
////                    UIApplication.shared.openURL(url! as URL)
////                }
////            }
////            aleat.addAction(tempAction)
////            aleat.addAction(callAction)
////            self.present(aleat, animated: true, completion: nil)
////        }
////    }
//    func toSub(findV: FindV) {
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now(), execute: {
//            let subV = SubVC()
//            //push方式
//            self.hidesBottomBarWhenPushed = true
//            self.navigationController?.pushViewController(subV , animated: true)
//            self.hidesBottomBarWhenPushed = false
//        })
//    }
//    func toTab(findV: FindV) {
//        self.tabBarController?.selectedIndex = 1
//        CustomTabBarVC.customTabBar.tabBarView.btns[0].isSelected = false
//        //增加第二个tabItem的颜色
//        CustomTabBarVC.customTabBar.tabBarView.btns[1].isSelected = true
//        CustomTabBarVC.customTabBar.tabBarView.tabBarItemClicked(sender: CustomTabBarVC.customTabBar.tabBarView.btns[1])
//        //NotificationCenter.default.post(name:NSNotification.Name(rawValue:"NotifyTabChange"), object: nil, userInfo: ["success":"true"])
//        //发送通知
//        //SnailNotice.post(notification: .tabJump,object: nil,passDicts: ["success":"true"])
//    }
////    func toPos(findV: FindV) {
////        self.searchCustomLocation(self.coRate!)
////    }
////    @objc func position(_ tapGes :UITapGestureRecognizer) {
////        nearSearch = true
////        FTIndicator.setIndicatorStyle(.dark)
////        //FTIndicator.showProgressWithmessage("正在加载中")
////        FTIndicator.showNotification(withTitle: "恭喜，定位成功", message: "我有消息")
////        self.searchCustomLocation(self.coRate!)
////    }
//    @objc func reload(notification:NSNotification) {
//        let dict = notification.userInfo //获取通self知的信息
//        if String(describing: dict!["success"]!)=="true" {
//            print("收到通知执行的方法")
//        }
//    }
//    @objc func changeCity(sender:UIButton){
//        let showCityV =  ShowCityVC();
//        showCityV.delegate = self
//        self.hidesBottomBarWhenPushed = true
//        self.navigationController?.pushViewController(showCityV, animated: true)
//        self.hidesBottomBarWhenPushed = false
//    }
//    //MARK: - passValueDelegate代理回调
//    func passValue(passVals:String) {
//        print("接收代理回调的值:\(passVals)")
//        leftButton?.setTitle((passVals as NSString).substring(to: 2), for: UIControlState.normal)
//    }
//}

extension FindVC:UIScrollViewDelegate,FindVDelegate,HorMoveVDelegate{
    func toWhisper(horMoveV: HorMoveV) {

//        Network.request(.toType, success: { json in
//            //获取歌曲信息
//            print(json)
//        }, error: { statusCode in
//            //服务器报错等问题
//            print("请求错误！错误码：\(statusCode)")
//        }, failure: { error in
//            //没有网络等问题
//            print("请求失败！错误信息：\(error.errorDescription ?? "")")
//        })

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now(), execute: {
            let backCellV = BackCellVC()
            //push方式
            self.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(backCellV , animated: true)
            self.hidesBottomBarWhenPushed = false
        })
    }
    func toDetail(horMoveV: HorMoveV) {
        //使用我们的provider进行网络请求（该请求不需要授权）
        HttpbinProvider.request(.toLogin(["opr": "add", "data": ["registration_id": "", "account": "15717914505", "password": "66fa03f6ba652e2850d5e19d3a3fa9fc"]] as [String : Any])) { result in

            switch result {
            case let .success(response):
                let statusCode = response.statusCode // 响应状态码：200, 401, 500...
                let data = JSON(response.data) // 响应数据
                //print(data,"oooo")
            //继续做一些其它事情....
            case let .failure(error):
                //错误处理....
                break
            }

//            if case let .success(response) = result {
//                //解析数据
//                let data = try? response.mapJSON()
//                let json = JSON(data!)
//                print(json)
//                //...
//            }
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now(), execute: {
            let adapcellV = AdapcellVC()
            //push方式
            self.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(adapcellV , animated: true)
            self.hidesBottomBarWhenPushed = false
        })
    }
    func setupUI(){
        self.view.addSubview(findV)
        //print(self.findV.headerV,"oooo")
//        self.findV.headerV.addSubview(pageTitleView)
//        self.findV.headerV.addSubview(pageContentView)
        // 设置代理
        //findV.tableV.delegate = self
        //        不需要调整UIScollView的内边距
        automaticallyAdjustsScrollViewInsets = false
    }
    @objc func setNet(notification:NSNotification) {
        netUseVals = notification.userInfo!["netUseful"] as! String
        //print(netUseVals,"网络变化")
    }
    func toSuccess(loginV: LoginV) {

    }
    func getDatas(){
        if netUseVals == "Useable"{
            // 2.创建Group
            let dGroup = DispatchGroup()
            dGroup.enter()
            let paras = ["opr":"search","data":["vals":""]] as [String : Any]
            HudTips.showHUD(ctrl:self)
            findVM.getInfos(paras:paras){(result) in
                self.findV.imagesURLStrings = self.findVM.imagesURLStrings
                self.findV.titles = self.findVM.titles
                self.findV.horMoveV.oDatas = self.findVM.oDatas
                dGroup.leave()
                HudTips.hideHUD(ctrl:self)
                StToast().showToast(text:"登录成功",type: pos )
            }
        }else{
            StToast().showToast(text:"\(missNetTips)",type:Pos)
        }
    }
    func toFresh(findV:FindV){
        if netUseVals == "Useable"{
            HudTips.showHUD(ctrl:self)
            //移除View中的数据
            self.findV.imagesURLStrings?.removeAll()
            self.findV.titles?.removeAll()
            self.findV.horMoveV.oDatas?.removeAll()

            //移除ViewModels里面的数据
            self.findVM.imagesURLStrings.removeAll()
            self.findVM.titles.removeAll()
            self.findVM.oDatas.removeAll()
            let dGroup = DispatchGroup()
            dGroup.enter()
            let paras = ["opr":"search","data":["vals":""]] as [String : Any]
            findVM.getFresh(paras:paras){(result) in
                print(self.findVM.titles)
                self.findV.imagesURLStrings = self.findVM.imagesURLStrings
                self.findV.titles = self.findVM.titles
                self.findV.horMoveV.oDatas = self.findVM.oDatas
                dGroup.leave()
                HudTips.hideHUD(ctrl:self)
                StToast().showToast(text:"刷新成功，来呀，互相杀害刷新成功，来呀，互相杀害刷新成功，来呀，互相杀害",type:.top)
                findV.freshH.endRefreshing()
                //findV.scrollV.mj_header.endRefreshing()
            }
        }else{
            StToast().showToast(text:"\(missNetTips)",type:Pos)
            findV.freshH.endRefreshing()
        }
    }
}
//MARK: - 遵守PageTitleViewDelegate协议
extension FindVC: PageTitleViewDelegate{
    func pageTitleView(titleView: PageTitleView, selectedIndex index: Int) {
        print(index,"VVVVVV")
        pageContentView.setCurrentIndex(currentIndex: index)
    }
}

//MARK: - 遵守PagecontentViewDelegate协议
extension FindVC : UIPageContentViewDelegate{
    func pageContentView(contentView: PageContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        //print(targetIndex,"ooooo")
        pageTitleView.setTitleWithProgress(progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
}
//extension FindVC: CLLocationManagerDelegate,AMapSearchDelegate{
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let newLocation = locations.last else {return}
//        self.coRate = newLocation.coordinate
//        //查询当前位置附近的小黄车
//        self.searchCustomLocation(self.coRate!)
//        if newLocation.horizontalAccuracy < 0 { return }
//        geoCoder.reverseGeocodeLocation(newLocation) { (pls: [CLPlacemark]?, error: Error?) in
//            if error == nil {
//                guard let pl = pls?.first else {return}
//                self.leftButton?.setTitle((pl.locality! as NSString).substring(to: 2), for: .normal)
//            }else{
//                print(error,"error")
//            }
//        }
//        manager.stopUpdatingLocation()
//    }
//
//    //搜索poi完成后的回调
//    func onPOISearchDone(_ request: AMapPOISearchBaseRequest!, response: AMapPOISearchResponse!) {
//        guard response.count>0 else{
//            print("周边没有小黄车")
//            return
//        }
//        var  annotations:[MAPointAnnotation] = []
//        annotations = response.pois.map{
//            let annotation = MAPointAnnotation()
//            annotation.coordinate = CLLocationCoordinate2D(latitude:CLLocationDegrees($0.location.latitude),longitude:CLLocationDegrees($0.location.longitude))
//            print($0.distance,"vvvvv")
//            if $0.distance < 300{
//                annotation.title = "红包小黄车"
//                annotation.subtitle = "骑行超过10分钟可获得大量红包"
//            }else{
//                annotation.title = "正常小黄车"
//            }
//
//            return annotation
//        }
//        self.mapView?.addAnnotations(annotations)
//        if nearSearch{
//            self.mapView?.showAnnotations(annotations, animated: true)
//            nearSearch = !nearSearch
//        }
//        //解析response获取POI信息，具体解析见 Demo
//    }
//
//    //地图初始化完成：
//    func mapInitComplete(_ mapView: MAMapView!) {
//        pin = MyPinAnnotation()
//        pin.coordinate = mapView.centerCoordinate
//        pin.lockedScreenPoint = CGPoint(x:view.bounds.width/2,y:view.bounds.height/2)
//        //pin.lockedScreenPoint = CLLocationCoordinate2D(latitude:CLLocationDegrees(self.coRate!.latitude),longitude:CLLocationDegrees(self.coRate!.longitude)) as! CGPoint
//        pin.isLockedToScreen = true
//
//        self.mapView?.addAnnotations([pin])
//        self.mapView?.showAnnotations([pin], animated: true)
//    }
//
//
//
//
//
//    //自定义大头针
//    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
//
//        if annotation.isKind(of: MAPointAnnotation.self) {
//            let pointReuseIndetifier = "pointReuseIndetifier"
//            var annotationView: MAPinAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: pointReuseIndetifier) as! MAPinAnnotationView?
//
//            if annotationView == nil {
//                annotationView = MAPinAnnotationView(annotation: annotation, reuseIdentifier: pointReuseIndetifier)
//            }
//            //用户自定义的位置
//            if annotation is MAUserLocation{
//                return nil
//            }
//            if annotation is MyPinAnnotation{
//                return nil
//            }
//            if annotation.title! == "红包小黄车" {
//                annotationView?.image = UIImage(named: "icon_tab_guaguatiandi_selected.png")
//            }else{
//                annotationView?.image = UIImage(named: "icon_tab_guaguatiandi_default.png")
//            }
//
//            //设置中心点偏移，使得标注底部中间点成为经纬度对应点
//            annotationView?.centerOffset = CGPoint(x:0, y:-18);
//            annotationView?.canShowCallout = true
//            //annotationView?.animatesDrop = true
//            return annotationView!
//        }
//
//        return nil
//    }
//
//    func mapView(_ mapView: MAMapView!, mapDidMoveByUser wasUserAction: Bool) {
//        if wasUserAction{
//            pin.isLockedToScreen = true
//            nearSearch = true
//            //查询当前位置附近的小黄车
//            self.searchCustomLocation(mapView.centerCoordinate)
//        }
//    }
//
//    func mapView(_ mapView: MAMapView!, didSelect view: MAAnnotationView!) {
//        //print("我点击了")
//        startO = pin.coordinate
//        stopO = view.annotation.coordinate
//
//        let startPoint = AMapNaviPoint.location(withLatitude: 39.993135, longitude: 116.474175)!
//    }
//}

