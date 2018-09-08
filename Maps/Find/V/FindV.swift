//
//  FindV.swift
//  Centers
//
//  Created by test on 2017/9/29.
//  Copyright © 2017年 com.youlu. All rights reserved.
//

import UIKit
import LLCycleScrollView
import MJRefresh
import SnapKit
//protocol FindVDelegate: class {
//    //跳转Tab
//    func toTab(findV : FindV)
//    //跳转Sub
//    func toSub(findV : FindV)
//    //定位pos
//    //func toPos(findV : FindV)
//}

protocol FindVDelegate: class {
    //去下拉刷新
    func toFresh(findV : FindV)
}
class FindV: UIView {
    weak var findVDelegate : FindVDelegate?
    //var localBtn:UILabel!
    //var scrollV:UIScrollView!
    //声明导航条
    var navigationBar = UIView()
    var centerT = UILabel()
    var tableV:UITableView!
    var headerV:UIView!
    //    let statusView = UIView()
    //    let testView = UIView()
    //    let colorView = UIView()
    // 顶部刷新 Mjrefresh
    let freshH = MJRefreshNormalHeader()
    let alphaChangeBoundary = ScreenW * (212 / 375) - 64
    var imagesURLStrings:Array<String>?{
        didSet {
            DispatchQueue.main.async{
                self.bannerDemo.imagePaths = self.imagesURLStrings!
            }
        }
    }
    var titles:[String]?{
        didSet {
            DispatchQueue.main.async{
                self.titleDemo.titles = self.titles!
            }
        }
    }
    // Demo--其他属性
    lazy var bannerDemo: LLCycleScrollView = {
        let bannerDemo = LLCycleScrollView.llCycleScrollViewWithFrame(CGRect.init(x: 0, y: 0, width:ScreenInfo.width, height: PublicFunc.setHeight(size: 180)),didSelectItemAtIndex: { index in
            print("当前点击图片的位置为:\(index)")
        })
        // 滚动间隔时间
        bannerDemo.autoScrollTimeInterval = 3.0
        bannerDemo.customPageControlStyle = .snake
        // 非.system的状态下，设置PageControl的tintColor
        bannerDemo.customPageControlInActiveTintColor = UIColor.gray
        // 设置.system系统的UIPageControl当前显示的颜色
        bannerDemo.pageControlCurrentPageColor = UIColor.white
        bannerDemo.pageControlPosition = .right
        // 非.system的状态下，设置PageControl的间距(默认为8.0)
        bannerDemo.customPageControlIndicatorPadding = 8.0
        bannerDemo.imageViewContentMode = .scaleToFill
        // 加载状态图
        bannerDemo.placeHolderImage = UIImage(named: "default.jpg")
        bannerDemo.coverImage = UIImage(named: "cover.jpg")
        return bannerDemo
    }()
    lazy var titleDemo: LLCycleScrollView = {
        let titleDemo = LLCycleScrollView.llCycleScrollViewWithTitles(frame: CGRect.init(x: ScreenInfo.width/4, y: PublicFunc.setHeight(size: 180), width: 3*ScreenInfo.width/4, height: PublicFunc.setHeight(size: 30))) { (index) in
            print("当前点击文本的位置为:\(index)")
        }
        titleDemo.customPageControlStyle = .none
        titleDemo.scrollDirection = .horizontal
        titleDemo.font = UIFont.systemFont(ofSize: 13)
        titleDemo.textColor = .black
        titleDemo.titleBackgroundColor = UIColor.colorWithCustom(255, g: 255, b: 255)
        titleDemo.numberOfLines = 2
        // 文本　Leading约束
        titleDemo.titleLeading = 10
        return titleDemo
    }()
    lazy var boBaoV: UILabel = {[weak self] in
        let boBaoV = UILabel(frame:CGRect(x:0, y:PublicFunc.setHeight(size: 180), width:ScreenInfo.width/4, height:PublicFunc.setHeight(size: 30)))
        boBaoV.text = "呱呱播："
        boBaoV.textAlignment = .center
        boBaoV.textColor = .red
        boBaoV.backgroundColor = UIColor.colorWithCustom(255, g: 255, b: 255)
        return boBaoV
        }()
    lazy var horMoveV: HorMoveV = {[weak self] in
        let Frame = CGRect(x: 0.0, y: PublicFunc.setHeight(size: 210), width: ScreenInfo.width, height: PublicFunc.setHeight(size: 124))
        let horMoveV = HorMoveV(frame: Frame)
        return horMoveV
        }()

    //建立导航条
    func buildNavigationItem() {//242,71,28
        //设置状态栏颜色
        if UIDevice.isX() == true{
            navigationBar.frame = CGRect(x: 0, y: 0, width: ScreenW, height: 88)
        }else{
            navigationBar.frame = CGRect(x: 0, y: 0, width: ScreenW, height: 64)
        }

        navigationBar.backgroundColor = UIColor.colorWithHexString(hex:"#ff602f").withAlphaComponent(0)
        self.addSubview(navigationBar)
        //创建中间标题
        centerT.frame = CGRect(x:ScreenInfo.width/4, y:UIDevice.isX() == true ? CGFloat(44) : CGFloat(20), width:ScreenInfo.width/2, height:CGFloat(44))
        centerT.text = "发现"
        centerT.textAlignment = .center
        centerT.textColor = .white
        navigationBar.addSubview(centerT)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension FindV:UITextFieldDelegate{

    func setupUI(){
        //自定义状态栏
        //        let statusView = UIView()
        //        statusView.backgroundColor = .white
        //        self.addSubview(statusView)
        //        statusView.snp.makeConstraints{ (make) in
        //            //make.centerY.equalTo(topPic)
        //            make.top.equalTo(0)
        //            make.left.equalTo(0)
        //            make.width.equalTo(ScreenInfo.width)
        //            make.height.equalTo(20)
        //        }
        //        scrollV = UIScrollView()
        //        // 添加到父视图
        //        addSubview(scrollV)
        //        scrollV.snp_makeConstraints { (make) in
        //            make.top.equalTo(-20)
        //            make.left.equalTo(0)
        //            make.width.equalTo(ScreenInfo.width)
        //            make.height.equalTo(ScreenInfo.height - CGFloat(24))
        //        }
        // 添加子视图label
        //        var originY:CGFloat = 10.0
        //        for number in 1...10
        //        {
        //            let label = UILabel(frame: CGRect(x:10.0, y:originY, width:ScreenInfo.width - 20, height:200.0))
        //            scrollV.addSubview(label)
        //            label.backgroundColor = UIColor(red: CGFloat(CGFloat(arc4random()) / CGFloat(RAND_MAX)), green: CGFloat(CGFloat(arc4random()) / CGFloat(RAND_MAX)), blue: CGFloat(CGFloat(arc4random()) / CGFloat(RAND_MAX)), alpha: 1.0)
        //            label.textColor = UIColor.red
        //            label.textAlignment = .center
        //            label.text = String(format: "scrollView add 第 %ld 个 label", arguments: [number]);
        //
        //            originY = (label.frame.minY + label.frame.height + 10.0)
        //        }
        // 背景颜色
        //        scrollV.backgroundColor = .white
        //        // 自适应父视图
        //        scrollV.autoresizingMask = UIViewAutoresizing.flexibleHeight
        //        // 其他属性
        //        scrollV.isScrollEnabled = true // 可以上下滚动
        //        scrollV.scrollsToTop = true // 点击状态栏时，可以滚动回顶端
        //        scrollV.bounces = true // 反弹效果，即在最顶端或最底端时，仍然可以滚动，且释放后有动画返回效果
        //        scrollV.isPagingEnabled = false // 分页显示效果
        //        scrollV.showsHorizontalScrollIndicator = true // 显示水平滚动条
        //        scrollV.showsVerticalScrollIndicator = true // 显示垂直滚动条
        //        scrollV.indicatorStyle = UIScrollViewIndicatorStyle.white // 滑动条的样式、
        //
        //        //下拉刷新相关设置
        //        freshH.height = CGFloat(100)
        //        freshH.setRefreshingTarget(self, refreshingAction: .freshFunc)
        //        scrollV.mj_header = freshH
        //        freshH.stateLabel.snp.makeConstraints{
        //            (make) in
        //            make.top.equalTo(36)
        //            make.center.equalToSuperview()
        //        }
        //        // 设置自动切换透明度(在导航栏下面自动隐藏)
        //        freshH.isAutomaticallyChangeAlpha = true
        //        scrollV.mj_header.ignoredScrollViewContentInsetTop = CGFloat(0);


        //        let containV = UIView()
        //        containV.backgroundColor = .white
        //        scrollV.addSubview(containV)
        //        containV.snp.makeConstraints{(make) in
        //            make.edges.equalTo(scrollV)
        //            make.width.equalTo(scrollV)
        //        }
        //
        //        scrollV.addSubview(boBaoV)
        //        scrollV.addSubview(horMoveV)

        tableV = UITableView()
        tableV=UITableView.init(frame: CGRect(x:0,y:UIDevice.isX() == true ? CGFloat(-44) : CGFloat(-20),width:ScreenInfo.width,height:ScreenInfo.height), style:.grouped)
        tableV.delegate = self;
        tableV.dataSource = self;
        tableV.register(InfoScrollCell.self, forCellReuseIdentifier: "InfoScrollCell")
        //scrollV.addSubview(tableV)
        self.addSubview(tableV)
        tableV.estimatedRowHeight = 44.0
        tableV.rowHeight = UITableViewAutomaticDimension
        tableV.tableFooterView = UIView(frame:CGRect(x:0,y:0,width:0,height:0.001))
        tableV.sectionHeaderHeight = 0.0
        tableV.sectionFooterHeight = 0.0
        //下拉刷新相关设置
        freshH.height = UIDevice.isX() ? PublicFunc.setHeight(size: 120) : PublicFunc.setHeight(size: 100)
        freshH.setRefreshingTarget(self, refreshingAction: .freshFunc)
        // 设置自动切换透明度(在导航栏下面自动隐藏)
        freshH.isAutomaticallyChangeAlpha = true
        tableV.mj_header = freshH
        freshH.stateLabel.snp.makeConstraints{
            (make) in
            make.top.equalTo(UIDevice.isX() ? PublicFunc.setHeight(size: 54) : PublicFunc.setHeight(size: 45))
            make.center.equalToSuperview()
        }

        //        tableV.snp.makeConstraints{ (make) in
        //            make.top.equalTo(horMoveV.snp.bottom).offset(0)
        //            make.left.equalTo(0)
        //            make.width.equalTo(ScreenInfo.width)
        //            //make.bottom.equalTo(containV.snp.bottom).offset(0)
        //        }
        //        statusView.backgroundColor = UIColor(red: CGFloat(CGFloat(arc4random()) / CGFloat(RAND_MAX)), green: CGFloat(CGFloat(arc4random()) / CGFloat(RAND_MAX)), blue: CGFloat(CGFloat(arc4random()) / CGFloat(RAND_MAX)), alpha: 1.0)
        //        scrollV.addSubview(statusView)
        //        statusView.snp.makeConstraints{ (make) in
        //            make.top.equalTo(horMoveV.snp.bottom)
        //            make.left.equalTo(0)
        //            make.width.equalTo(ScreenInfo.width)
        //            make.height.equalTo(300)
        //        }
        //
        //        testView.backgroundColor = UIColor(red: CGFloat(CGFloat(arc4random()) / CGFloat(RAND_MAX)), green: CGFloat(CGFloat(arc4random()) / CGFloat(RAND_MAX)), blue: CGFloat(CGFloat(arc4random()) / CGFloat(RAND_MAX)), alpha: 1.0)
        //        scrollV.addSubview(testView)
        //        testView.snp.makeConstraints{ (make) in
        //            make.top.equalTo(statusView.snp.bottom)
        //            make.left.equalTo(0)
        //            make.width.equalTo(ScreenInfo.width)
        //            make.height.equalTo(300)
        //        }
        //
        //        colorView.backgroundColor = UIColor(red: CGFloat(CGFloat(arc4random()) / CGFloat(RAND_MAX)), green: CGFloat(CGFloat(arc4random()) / CGFloat(RAND_MAX)), blue: CGFloat(CGFloat(arc4random()) / CGFloat(RAND_MAX)), alpha: 1.0)
        //        scrollV.addSubview(colorView)
        //        colorView.snp.makeConstraints{ (make) in
        //            make.top.equalTo(testView.snp.bottom).offset(0)
        //            make.left.equalTo(0)
        //            make.width.equalTo(ScreenInfo.width)
        //            make.height.equalTo(300)
        //            make.bottom.equalTo(containV.snp.bottom).offset(0)
        //        }
    }
}
extension FindV:UITableViewDataSource,UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        headerV = UIView()
        headerV.backgroundColor = .white
        headerV.addSubview(bannerDemo)
        headerV.addSubview(titleDemo)
        headerV.addSubview(horMoveV)
        headerV.addSubview(boBaoV)
        return headerV
    }
    //set Header Height
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return PublicFunc.setHeight(size: 348);
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "InfoScrollCell", for: indexPath) as! InfoScrollCell
        //        let identifier = "InfoScrollCell"
        //        var cell = tableView.cellForRow(at: indexPath)
        //            as? InfoScrollCell
        //        if cell == nil{
        //            cell = InfoScrollCell(style: .default, reuseIdentifier: identifier)
        //            cell?.selectionStyle = .none
        //        }

        //        cell.textLabel?.text = "xxxx\(indexPath.row)"
        cell.titleLab?.text = "我是林磊"

        if indexPath.row%2==0 {
            cell.despLab?.text = "我是假数据我是假数据我是假数据"
        }
        else
        {
            if indexPath.row%3 == 0{
                cell.despLab?.text = "我是假数据我是假数据我是假数据我是假数据我是假数据我是假数据我是假数据我是假数据我是假数据"
            }
            else{
                cell.despLab?.text = "我是假数据我是假数据我是假数据我是假数据我是假数据我是假数据我是假数据我是假数据我是假数据我是假数据我是假数据我是假数据我是假数据我是假数据我是假数据我是假数据我是假数据我是假数据我是假数据我是假数据我是假数据"
            }
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("第\(indexPath.row)行被点击了")
    }
    // MARK: - UIScrollViewDelegate
    //视图滚动中一直触发


    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        if offsetY >= 0 && offsetY <= alphaChangeBoundary{
            navigationBar.backgroundColor = UIColor.colorWithHexString(hex:"#ff602f").withAlphaComponent(offsetY / alphaChangeBoundary)
        }else if offsetY > alphaChangeBoundary {
            navigationBar.backgroundColor = UIColor.colorWithHexString(hex:"#ff602f")
        }else {
            navigationBar.backgroundColor = UIColor.colorWithHexString(hex:"#ff602f").withAlphaComponent(0)
        }

        if offsetY < 0 {

            UIView.animate(withDuration: 0.1, animations: {
                self.navigationBar.alpha = 0
                self.centerT.alpha = 0
            })

        }else{
            UIView.animate(withDuration: 0.1, animations: {
                self.navigationBar.alpha = 1
                self.centerT.alpha = 1
            })
        }
    }
}

extension FindV{
    @objc func freshFunc(_ tapGes :UITapGestureRecognizer){
        findVDelegate?.toFresh(findV : self)
    }
}
public extension Selector {
    static let freshFunc = #selector(FindV.freshFunc(_:))
}
//extension FindV{
//    @objc func subJump(_ tapGes :UITapGestureRecognizer){
//        findVDelegate?.toSub(findV : self)
//    }
//    @objc func tabJump(_ tapGes :UITapGestureRecognizer){
//        findVDelegate?.toTab(findV : self)
//    }
////    @objc func position(_ tapGes :UITapGestureRecognizer){
////        findVDelegate?.toPos(findV : self)
////    }
//}

//短信验证码登录
//        let btnSub = UILabel()
//        btnSub.text = "跳入子页面"
//        btnSub.textColor = UIColor.colorWithCustom(242,g:72,b:28)
//        btnSub.font=UIFont.UiBoldFontSize(size: 18)
//        btnSub.textAlignment = .center
//        //将label用户交互设为true
//        btnSub.isUserInteractionEnabled = true
//        let subGes = UITapGestureRecognizer(target: self, action: #selector(self.subJump(_:)))
//        btnSub.addGestureRecognizer(subGes)
//        addSubview(btnSub);
//        btnSub.snp_makeConstraints { (make) in
//            make.top.equalTo((ScreenInfo.height - PublicFunc.setHeight(size: 30))/2)
//            make.left.equalTo(0)
//            make.width.equalTo(ScreenInfo.width/2)
//            make.height.equalTo(PublicFunc.setHeight(size: 30))
//        }
//
//
//        let btnTab = UILabel()
//        btnTab.text = "跳入Tab页"
//        btnTab.textColor = UIColor.colorWithCustom(242,g:72,b:28)
//        btnTab.font=UIFont.UiBoldFontSize(size: 18)
//        btnTab.textAlignment = .center
//        //将label用户交互设为true
//        btnTab.isUserInteractionEnabled = true
//        let tabGes = UITapGestureRecognizer(target: self, action: #selector(self.tabJump(_:)))
//        btnTab.addGestureRecognizer(tabGes)
//        addSubview(btnTab);
//        btnTab.snp_makeConstraints { (make) in
//            make.top.equalTo((ScreenInfo.height - PublicFunc.setHeight(size: 30))/2)
//            make.left.equalTo(btnSub.snp.right).offset(0)
//            make.width.equalTo(ScreenInfo.width/2)
//            make.height.equalTo(PublicFunc.setHeight(size: 30))
//        }

//        localBtn = UILabel()
//        localBtn.text = "定位"
//        localBtn.textColor = UIColor.colorWithCustom(242,g:72,b:28)
//        localBtn.font=UIFont.UiBoldFontSize(size: 18)
//        localBtn.textAlignment = .center
//        //将label用户交互设为true
//        localBtn.isUserInteractionEnabled = true
//        let posGes = UITapGestureRecognizer(target: self, action: #selector(self.position(_:)))
//        localBtn.addGestureRecognizer(posGes)
//        addSubview(localBtn)
//        localBtn.snp_makeConstraints { (make) in
//            make.bottom.equalTo(-PublicFunc.setHeight(size:60))
//            make.left.equalTo(0)
//            make.width.equalTo(ScreenInfo.width/3)
//            make.height.equalTo(PublicFunc.setHeight(size: 30))
//        }

