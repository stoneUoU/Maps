//
//  AlipayVC.swift
//  Maps
//
//  Created by test on 2017/12/20.
//  Copyright © 2017年 com.youlu. All rights reserved.
//
import UIKit
let kScreenW: CGFloat = UIScreen.main.bounds.width
let kScreenH: CGFloat = UIScreen.main.bounds.height

class AlipayVC: UIViewController,UITableViewDataSource,UITableViewDelegate,MYPRefreshHeaderDelegate,UIGestureRecognizerDelegate {

    /**
     *  自定义的navigationBar
     */
    let mNavigationBarHeight: CGFloat = 64
    let mCustomNavigationBarWidth: CGFloat = 300


    private lazy var mCustomOneNavigationBar: UIView = {
        let tmp: UIView = UIView.init(frame: CGRect.init(x: (kScreenW - self.mCustomNavigationBarWidth)/2, y: 24, width: self.mCustomNavigationBarWidth, height: 36))

        // 增加控件增加视觉效果
        let tmpLabel: UILabel = UILabel()
        tmpLabel.textAlignment = .center
        tmpLabel.textColor = UIColor.white
        tmpLabel.text = "显示默认NavigationBar"

        tmp.addSubview(tmpLabel)
        tmpLabel.snp.makeConstraints({ (make) in
            make.left.equalToSuperview().offset(20)
            make.center.equalToSuperview()
            make.top.equalToSuperview()
        })

        return tmp
    }()

    private lazy var mCustomTwoNavigationBar: UIView = {
        let tmp: UIView = UIView.init(frame: CGRect.init(x: (kScreenW - self.mCustomNavigationBarWidth)/2, y: 24, width: self.mCustomNavigationBarWidth, height: 36))
        // 默认显示mCustomOneNavigationBar
        tmp.alpha = 0

        // 增加控件增加视觉效果
        let tmpLabel: UILabel = UILabel()
        tmpLabel.textAlignment = .center
        tmpLabel.textColor = UIColor.white
        tmpLabel.text = "切换其它NavigationBar"

        tmp.addSubview(tmpLabel)
        tmpLabel.snp.makeConstraints({ (make) in
            make.left.equalToSuperview().offset(20)
            make.center.equalToSuperview()
            make.top.equalToSuperview()
        })

        return tmp
    }()


    lazy var mCustomNavigationBar: UIView = {
        let tmp: UIView = UIView()
        tmp.backgroundColor = UIColor.orange

        tmp.addSubview(self.mCustomOneNavigationBar)
        tmp.addSubview(self.mCustomTwoNavigationBar)

        return tmp
    }()


    /**
     *  TOPView相关
     */
    private let mTopOneViewHeight: CGFloat = 120
    private let mTopTwoViewHeight: CGFloat = 240

    private lazy var mTopOneView: UIView = {
        let tmp: UIView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenW, height: self.mTopOneViewHeight))
        tmp.backgroundColor = UIColor.clear

        // 放置一些控件增加视觉效果
        var x: CGFloat = 0
        let tmpWidth: CGFloat = 70
        let tmpHeight: CGFloat = 80
        let leftMargin = (kScreenW/4.0 - tmpWidth)/2.0
        x += leftMargin

        for i in 0...3 {
            let tmpBtn: UIButton = UIButton()
            tmpBtn.backgroundColor = self.randomColor()
            tmpBtn.addTarget(self, action: #selector(self.btnClickAction), for: .touchUpInside)
            tmp.addSubview(tmpBtn)
            tmpBtn.snp.makeConstraints({ (make) in
                make.left.equalToSuperview().offset(x)
                make.centerY.equalToSuperview()
                make.size.equalTo(CGSize.init(width: tmpWidth, height: tmpHeight))
            })
            x += tmpWidth
            x += leftMargin*2
        }

        return tmp
    }()

    private lazy var mTopTwoView: UIView = {
        let tmp: UIView = UIView.init(frame: CGRect.init(x: 0, y: self.mTopOneViewHeight, width: kScreenW, height: self.mTopTwoViewHeight))
        tmp.backgroundColor = UIColor.white

        // 放置一些控件增加视觉效果
        var x: CGFloat = 0
        var y: CGFloat = 0
        let tmpWidth: CGFloat = 40
        let leftMargin = (kScreenW/5.0 - tmpWidth)/2.0
        let topMargin = (self.mTopTwoViewHeight/3.0 - tmpWidth)/2.0
        x += leftMargin
        y += topMargin

        // 一行放置5个，总共三行
        for i in 0...14 {
            let tmpBtn: UIButton = UIButton()
            tmpBtn.backgroundColor = self.randomColor()
            tmpBtn.addTarget(self, action: #selector(self.btnClickAction), for: .touchUpInside)
            tmp.addSubview(tmpBtn)
            tmpBtn.snp.makeConstraints({ (make) in
                make.left.equalToSuperview().offset(x)
                make.top.equalToSuperview().offset(y)
                make.size.equalTo(CGSize.init(width: tmpWidth, height: tmpWidth))
            })
            if i == 4 || i == 9 || i == 14 {
                // 换行
                x = leftMargin
                y += tmpWidth
                y += topMargin*2
            }
            else {
                x += tmpWidth
                x += leftMargin*2
            }
        }


        return tmp
    }()

    private lazy var mTopView: UIView = {
        let tmp: UIView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenW, height: self.mTopOneViewHeight + self.mTopTwoViewHeight))
        tmp.backgroundColor = UIColor.orange

        tmp.addSubview(self.mTopOneView)
        tmp.addSubview(self.mTopTwoView)

        return tmp
    }()

    /**
     *  RefreshHeader
     */

    let mRefreshHeaderHeight: CGFloat = 65

    lazy var mRefreshHeader: MYPRefreshHeader = {
        let tmp: MYPRefreshHeader = MYPRefreshHeader.init(frame: CGRect.init(x: 0, y: self.mTopOneViewHeight + self.mTopTwoViewHeight - self.mRefreshHeaderHeight, width: kScreenW, height: self.mRefreshHeaderHeight))
        tmp.mDelegate = self
        tmp.mRefreshStatus = MRefreshStatus.normal

        return tmp
    }()

    /**
     *  TableView
     */
    private lazy var mTableview: UITableView = {
        let tmp: UITableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0), style: .grouped)
        tmp.dataSource = self
        tmp.delegate = self
        // 修改Indicator的位置
        tmp.scrollIndicatorInsets = UIEdgeInsetsMake(self.mTopOneViewHeight + self.mTopTwoViewHeight, 0, 0, 0)

        // 设置TableHeaderView
        self.resetTableHeaderView(tableview: tmp,height: self.mTopOneViewHeight + self.mTopTwoViewHeight)

        // 将TopView添加到TableView上面
        // 添加在TableView上面才能保证滑动TopView的时候联动TableView
        tmp.addSubview(self.mTopView)

        return tmp
    }()


    /**
     *
     */
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        self.view.backgroundColor = UIColor.white
        self.automaticallyAdjustsScrollViewInsets = false

        // 使用自定义的NavigationBar
        self.navigationController?.view.sendSubview(toBack: (self.navigationController?.navigationBar)!)

        self.view.addSubview(mCustomNavigationBar)
        mCustomNavigationBar.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(mNavigationBarHeight)
        }


        self.view.addSubview(mTableview)
        mTableview.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(mCustomNavigationBar.snp.bottom)
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

    /**
     *  刷新相关
     */

    func mStartRefreshing(refreshHeader: MYPRefreshHeader) {
        weak var weakSelf = self
        UIView.animate(withDuration: 0.3, animations: {
            self.resetTableHeaderView(tableview: self.mTableview ,height: self.mTopOneViewHeight + self.mTopTwoViewHeight + self.mRefreshHeaderHeight)
            self.mTableview.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
        }) { (result) in
            // 效果,3S之后停止刷新
            // 实际使用中，根据网络返回接口自行调用
            DispatchQueue.global().async {
                sleep(3)
                DispatchQueue.main.async {
                    weakSelf?.mRefreshHeader.mRefreshStatus = .none
                }
            }
        }
    }

    func mEndRefreshing(refreshHeader: MYPRefreshHeader) {
        if self.mTableview.frame.height != self.mTopOneViewHeight + self.mTopTwoViewHeight {
            UIView.animate(withDuration: 0.3, animations: {
                self.resetTableHeaderView(tableview: self.mTableview, height: self.mTopOneViewHeight + self.mTopTwoViewHeight)
                // 停止刷新的时候是否需要会到contentoffset为(0,0)的状态根据需求确定

            }) { (result) in

            }
        }
    }

    /**
     *  Tablevie代理
     */
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell()
        cell.backgroundColor = UIColor.white

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell: UITableViewCell = tableView.cellForRow(at: indexPath)!
        cell.backgroundColor = self.randomColor()

    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }

    /**
     *  处理滑动时候的状态变化
     */
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 获取当前的offsetY
        let tmpOffsetY: CGFloat = scrollView.contentOffset.y

        if tmpOffsetY <= 0 {
            mTopView.frame = CGRect.init(x: 0, y: tmpOffsetY, width: kScreenW, height: mTopOneViewHeight + mTopTwoViewHeight)

            // 内部子控件恢复正常
            // 凡是在else里处理过的控件，在该条件里面都需要恢复到初始状态
            mCustomTwoNavigationBar.alpha = 0
            mCustomOneNavigationBar.alpha = 1
            mTopOneView.alpha = 1
            mTopOneView.frame = CGRect.init(x: 0, y: 0, width: kScreenW, height: mTopOneViewHeight)
        }
        else {
            // 上滑处理联动效果

            // 1.处理navigationBar
            let navigationBarSwitchPointY: CGFloat = 40

            if tmpOffsetY <= navigationBarSwitchPointY {
                mCustomTwoNavigationBar.alpha = 0
                mCustomOneNavigationBar.alpha = 1 - tmpOffsetY/navigationBarSwitchPointY
            }
            else {
                mCustomOneNavigationBar.alpha = 0
                mCustomTwoNavigationBar.alpha = (tmpOffsetY - navigationBarSwitchPointY)/navigationBarSwitchPointY
            }

            // 2.处理逐渐需要隐藏的mTopOneView
            // 该值是根据mTopOneView的高度和内部button的高度确定的,mTopOneView.height - btn.height
            let topOneViewSwitchPointY: CGFloat = mTopOneViewHeight/2.0

            if tmpOffsetY <= topOneViewSwitchPointY {
                mTopOneView.alpha = 1 - tmpOffsetY/topOneViewSwitchPointY
                // 高度处理
                mTopOneView.frame = CGRect.init(x: 0, y: tmpOffsetY/2.0, width: kScreenW, height: mTopOneViewHeight)
            }
            else {

            }
        }

        // 下拉刷新相关
        if tmpOffsetY < 0 {
            // 如果此时正在刷新，做特殊处理
            if mRefreshHeader.mRefreshStatus == .refreshing {
                return
            }

            let refreshStatusSwitchPoint: CGFloat = mRefreshHeaderHeight

            if tmpOffsetY > -refreshStatusSwitchPoint {
                mRefreshHeader.mRefreshStatus = .normal
            }
            else {
                mRefreshHeader.mRefreshStatus = .willRefresh
            }
        }

    }

    /**
     *  结束拖动
     */
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // decelerate: 该值为true的时候表示scrollview在停止拖动之后还会向前滑动一段距离，并且在结束之后调用scrollViewDidEndDecelerating方法
        // decelerate: 该值为NO的时候表示scrollview在停止拖拽之后立即停止滑动
        if !decelerate {
            // 如果已经停止滑动了，立刻判断是否需要处理mTopOneView
            self.checkCurrentContentOffset(scrollView)
        }

        // 判断此时是否需要刷新
        let tmpOffsetY: CGFloat = scrollView.contentOffset.y

        // 该值需要和上面保持一致
        let refreshStatusSwitchPoint: CGFloat = mRefreshHeaderHeight
        if tmpOffsetY < -refreshStatusSwitchPoint {
            // 如果此时正在刷新，做特殊处理
            if mRefreshHeader.mRefreshStatus == .refreshing {
                return
            }
            // 恢复原样先
            mTableview.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
            // 开始刷新
            mRefreshHeader.mRefreshStatus = .refreshing
        }
    }

    /**
     *  减速停止
     */
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.checkCurrentContentOffset(scrollView)
    }

    /**
     *  动画停止(暂时不使用,只有动画修改contentoffset或者scrollRectToVisible的时候才会调用)
     *  现在采用在"checkCurrentContentOffset"方法中人为动画同时修改contentoffset和alpha的方式,避免alpha的突然变化
     */
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        // 避免因为对mTopOneView的操作导致alpha的显示问题
        // 不在"heckCurrentContentOffset"方法中操作的原因是为了避免alpha的突然变化
        let tmpOffsetY: CGFloat = scrollView.contentOffset.y
        if tmpOffsetY == 0 {
            mTopOneView.alpha = 1
        }
        else {
            mTopOneView.alpha = 0
        }
    }

    /**
     *  检测当前坐标，判断mTopOneView需要显示还是隐藏
     */
    func checkCurrentContentOffset(_ scrollView: UIScrollView) {
        let tmpOffsetY: CGFloat = scrollView.contentOffset.y
        // 设置 >0 的判断单纯的是为了让这个方法只处理是否隐藏mTopOneView的事件
        if tmpOffsetY > 0 {
            // 设置状态变化的点，保持和上面的设值统一
            let topOneViewSwitchPointY: CGFloat = mTopOneViewHeight/2.0
            if tmpOffsetY <= topOneViewSwitchPointY {
                // 恢复原样
                UIView.animate(withDuration: 0.3, animations: {
                    self.mTableview.contentOffset = CGPoint.init(x: 0, y: 0)
                    self.mTopOneView.alpha = 1
                }, completion: nil)
            }
            else if tmpOffsetY > topOneViewSwitchPointY && tmpOffsetY < mTopOneViewHeight {
                // 隐藏mTopOneView
                UIView.animate(withDuration: 0.3, animations: {
                    self.mTableview.contentOffset = CGPoint.init(x: 0, y: self.mTopOneViewHeight)
                    self.mTopOneView.alpha = 0
                }, completion: nil)
            }
            else {

            }
        }
    }

    /**
     *  设置TableHeaderView
     *  该方法的主要作用在于在需要刷新的时候动态修改headerview的高度以显示refreshHeader
     */
    func resetTableHeaderView(tableview: UITableView,height: CGFloat) {
        // 设置headerView
        let tmpHeaderView: UIView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenW, height: height))
        tmpHeaderView.backgroundColor = UIColor.clear
        tableview.tableHeaderView = tmpHeaderView

        // 修改refreshHeader的frame并重新添加到tableheaderview上面
        mRefreshHeader.frame = CGRect.init(x: 0, y: height - mRefreshHeaderHeight, width: kScreenW, height: mRefreshHeaderHeight)
        tableview.tableHeaderView?.addSubview(mRefreshHeader)

        // 将topView放置到最上方,如果已经添加了的话
        if tableview.subviews.contains(mTopView) {
            tableview.bringSubview(toFront: mTopView)
        }
    }


    /**
     *  点击改变颜色效果
     */
    @objc private func btnClickAction(sender: UIButton) {
        sender.backgroundColor = self.randomColor()
    }


    /**
     *  获取随机颜色
     */
    private func randomColor() -> UIColor {
        let R: Double = Double(arc4random() % 256)
        let G: Double = Double(arc4random() % 256)
        let B: Double = Double(arc4random() % 256)
        return UIColor.init(colorLiteralRed: Float(R/255.0), green: Float(G/255.0), blue: Float(B/255.0), alpha: 1)
    }
    //手势代码：
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if self.navigationController?.viewControllers.count == 1 {
            return false
        }
        return true
    }
}

