//
//  STViewVC.swift
//  Maps
//
//  Created by test on 2018/1/10.
//  Copyright © 2018年 com.youlu. All rights reserved.
//

import UIKit

class STViewVC: BaseToolVC{

    lazy var mainScroll: STPageSCroll = {
        let titles = ["图文详情", "产品参数", "店铺推荐"]
        let list = STTableView(frame: CGRect(x: 0, y: 0, width: ScreenW, height: ScreenH - StatusBarAndNavigationBarH - 40), style: .plain)
        let request1 = NSURLRequest(url: URL(string: "https://m.baidu.com/ssid=f17b33333837303736e20c/fm_kl=17709454cf/from=2001a/s?word=%E5%BE%AE%E5%8D%9A&sa=tb&ts=6034200&t_kt=0&ie=utf-8&rsv_t=9636R14NfDeI4cI7MF97ydINU%252FmY7bX1dtWdziBNOA6fZkpLbws7dZLopKs&rsv_pq=15161972120391105661&ss=100&t_it=1&rqlang=zh&rsv_sug4=8614&inputT=7161&oq=%E5%BE%AE%E5%8D%9A")!)
        let request2 = NSURLRequest(url: URL(string: "https://m.baidu.com/ssid=f17b33333837303736e20c/fm_kl=17709454cf/from=2001a/s?word=%E5%9C%A3%E5%A2%9F&sa=ts_1&ts=6172600&t_kt=0&ie=utf-8&rsv_t=18c9FSsvNfa4KliUIiab6G6ShwRtzV9CQw321kq2nHMcwhtyCXH0g5xte0E&rsv_pq=13829630444039355249&ss=100&rq=%E5%9C%A3&rqlang=zh&rsv_sug4=25954&inputT=24388&oq=%E6%89%8B%E6%9C%BA")!)
        let web1 = STWebView(frame: CGRect(x: 0, y: 0, width: ScreenW, height: ScreenH - StatusBarAndNavigationBarH - 40))
        let web2 = STWebView(frame: CGRect(x: 0, y: 0, width: ScreenW, height: ScreenH - StatusBarAndNavigationBarH - 40))
        web1.loadRequest(request1 as URLRequest)
        web2.loadRequest(request2 as URLRequest)
        let views = [list, web1, web2]

        //let topView = Bundle.main.loadNibNamed("TopView", owner: self, options: nil)?.last as? TopView
        //let size = topView?.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
        //topView?.frame = CGRect(x: 0, y: 0, width: ScreenW, height: (size?.height)!)

        let topView = UIView(frame:CGRect(x: 0, y: 0, width: ScreenW, height: 1000));
        topView.backgroundColor = .cyan;

        let scroll: STPageSCroll = STPageSCroll(frame: CGRect(x: 0, y: StatusBarAndNavigationBarH, width: ScreenW, height: ScreenH - StatusBarAndNavigationBarH),topView: topView, titles: titles,views: views)
        return scroll
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp(centerVals: "交互", rightVals: "")
        view.addSubview(mainScroll)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.setHidesBackButton(true, animated: true)
        CustomTabBarVC.hideBar(animated: true);
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
