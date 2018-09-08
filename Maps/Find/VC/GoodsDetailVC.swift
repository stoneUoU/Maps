//
//  GoodsDetailVC.swift
//  Maps
//
//  Created by test on 2018/1/10.
//  Copyright © 2018年 com.youlu. All rights reserved.
//

import UIKit

class GoodsDetailVC: BaseToolVC {

    var tableV = UITableView()
    var webView: UIWebView?
    var activity: UIActivityIndicatorView?
    let maxContentOfSetY: CGFloat = 80
    var webHeaderView: UILabel?
    var isLoadedWeb = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp(centerVals: "商品详情", rightVals: "")
        self.view.backgroundColor = .white
        tableV = UITableView()
        tableV=UITableView.init(frame: CGRect(x:0,y:StatusBarAndNavigationBarH,width:ScreenInfo.width,height:ScreenInfo.height - StatusBarAndNavigationBarH - TabbarSafeBotM), style:.grouped)
        tableV.delegate = self
        tableV.dataSource = self
        tableV.backgroundColor = .white
        //注册cell
        tableV.register(AdapCell.self, forCellReuseIdentifier: "cell")
        tableV.tableHeaderView = UIView(frame:CGRect(x:0,y:0,width:ScreenW,height:0.001))
//        if #available(iOS 11, *) {
//            tableV.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, -AllTabBarH, 0)
//            tableV.contentInset = UIEdgeInsetsMake(0, 0, -AllTabBarH, 0)
//        }
        // 设置预估行高 --> 先让 tableView 能滚动，在滚动的时候再去计算显示的 cell 的真正的行高，并且调整 tabelView 的滚动范围
        tableV.estimatedRowHeight = 100
        // 设置 tabelView 行高,自动计算行高
        tableV.rowHeight = UITableViewAutomaticDimension

        self.view.addSubview(tableV)
        self.initWebView()
        self.initWebHeaderView()
        self.initActivity()
    }
    func initWebView() {
        let webView = UIWebView.init(frame: CGRect(x: 0, y: self.tableV.frame.maxY, width: self.view.frame.width, height: self.view.frame.height))
        webView.delegate = self
        webView.scrollView.delegate = self
        webView.backgroundColor = UIColor.white
        self.view.addSubview(webView)
        self.webView = webView
    }

    func initWebHeaderView() {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: ScreenW, height: 40))
        label.textAlignment = .center
        label.text = "上拉，返回宝贝详情"
        label.font = UIFont.systemFont(ofSize: 13)
        label.alpha = 0
        self.webView?.addSubview(label)
        self.webHeaderView = label
        //label.bringSubview(toFront: self.webView!)
    }

    func initActivity() {
        let activity = UIActivityIndicatorView()
        activity.center = CGPoint(x: ScreenW/2, y: (ScreenH - 64)/2)
        activity.isHidden = true
        activity.activityIndicatorViewStyle = .gray
        self.webView?.addSubview(activity)
        self.activity = activity
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.setHidesBackButton(true, animated: true)
        CustomTabBarVC.hideBar(animated: true);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension GoodsDetailVC{
    @objc func sendNotice(_:UIButton){
        //发送通知
        SnailNotice.post(notification: .happy,object: nil,passDicts: ["success":"true"])
    }
}
//数据源方法
extension GoodsDetailVC:UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate{

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 18
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerV =  UIView()
        footerV.backgroundColor = .white
        let loadL = UILabel()
        loadL.text = "继续拖动，查看图文详情"
        loadL.font = UIFont.systemFont(ofSize: 12)
        footerV.addSubview(loadL)
        loadL.snp.makeConstraints{(make) in
            make.centerX.equalTo(footerV)
            make.centerY.equalTo(footerV)
        }
        return footerV
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : AdapCell = tableView.dequeueReusableCell(withIdentifier: "cell")! as! AdapCell
        if indexPath.row%2==0 {
            cell.contentLable.text = "我是假数据我是假数据我是假数据"
        }
        else
        {
            if indexPath.row%3 == 0{
                cell.contentLable.text = "我是假数据我是假数据我是假数据我是假数据我是假数据我是假数据我是假数据我是假数据我是假数据"
            }
            else{
                cell.contentLable.text = "我是假数据我是假数据我是假数据我是假数据我是假数据我是假数据我是假数据我是假数据我是假数据我是假数据我是假数据我是假数据我是假数据我是假数据我是假数据我是假数据我是假数据我是假数据我是假数据我是假数据我是假数据"
            }
        }
        return cell
    }


    func goToWebDetail() {
        UIView.animate(withDuration: 0.3, animations: {
            self.webView?.frame = CGRect(x: 0, y: StatusBarAndNavigationBarH, width: ScreenW, height: ScreenH)
            self.tableV.frame = CGRect(x:0,y:StatusBarAndNavigationBarH,width:ScreenInfo.width,height:ScreenInfo.height - StatusBarAndNavigationBarH - TabbarSafeBotM)

        }) { (finished) in
            guard !self.isLoadedWeb else {
                return
            }
            let request = URLRequest(url: URL(string: "https://www.baidu.com")!)
            self.webView?.loadRequest(request)
            self.isLoadedWeb = true
        }
    }

    func backToTableDetail() {
        UIView.animate(withDuration: 0.3, animations: {
            self.webView?.frame = CGRect(x: 0, y: ScreenH, width: ScreenW, height: ScreenH)
            self.tableV.frame = CGRect(x:0,y:StatusBarAndNavigationBarH,width:ScreenInfo.width,height:ScreenInfo.height - StatusBarAndNavigationBarH - TabbarSafeBotM)
        }, completion: nil)
    }

    func handleWebHeaderViewAnimation(_ offSetY: CGFloat) {
        self.webHeaderView?.alpha = -offSetY/maxContentOfSetY
        self.webHeaderView?.center = CGPoint(x: ScreenW/2, y: -offSetY/2)

        if -offSetY > maxContentOfSetY {
            self.webHeaderView?.text = "释放，返回宝贝详情"
        } else {
            self.webHeaderView?.text = "下拉，返回宝贝详情"
        }
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offSetY = scrollView.contentOffset.y
        let beyondOffSetY = scrollView.contentSize.height - ScreenH

        if scrollView.isMember(of: UITableView.self) {
            if offSetY - beyondOffSetY >= self.maxContentOfSetY {
                self.goToWebDetail()
            }
        } else {
            if offSetY <= -self.maxContentOfSetY, offSetY < 0 {
                self.backToTableDetail()
            }
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !scrollView.isMember(of: UITableView.self) {
            self.handleWebHeaderViewAnimation(scrollView.contentOffset.y)
        }
    }

    // MARK: - Webview delegate

    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        self.activity?.isHidden = false
        self.activity?.startAnimating()
        return true
    }

    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.activity?.stopAnimating()
    }

    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        self.activity?.stopAnimating()
    }

}
