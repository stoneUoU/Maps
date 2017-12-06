//
//  ContentV
//  Gfoods
//
//  Created by test on 2017/9/1.
//  Copyright © 2017年 com.youlu. All rights reserved.
//

import UIKit
import SnapKit
import MJRefresh
import SDWebImage
//此界面的tableCell是用NoticeTableCell.swift
protocol ContentVDel: class {
    //下拉刷新
//    func pullRefresh(contentV : ContentV)
//    //上拉加载
//    func loadRefresh(contentV : ContentV)
}
class ContentV: UIView {
    //没有数据时展示的View
    var noDataV = UIImageView()
    var tableView : UITableView?
    //顶部刷新
    var refreshHeader = MJRefreshNormalHeader()
    //底部加载更多
    var loadFooter = MJRefreshAutoNormalFooter()
    var contentMs : [ContentMs]? {
        didSet {
            //此段代码可修复界面闪动（无数据图片）
            if let contentMAs = contentMs {
                contentMAs.count != 0 ? tableView?.reloadData() : STLog("contentMAs is null")
                STLog(contentMAs)
            }
        }
    }
    weak var contentVDel : ContentVDel?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension ContentV{
    func setupUI(){
        //创建tableview
        tableView=UITableView.init(frame: CGRect(x:0,y:0,width:ScreenInfo.width,height:ScreenInfo.height - (StatusBarAndNavigationBarH + TabbarSafeBotM)) , style:.plain)
        tableView?.delegate=self;//实现代理
        tableView?.dataSource=self;//实现数据源
        tableView?.showsVerticalScrollIndicator = false
        tableView?.showsHorizontalScrollIndicator = false
        tableView?.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView?.estimatedRowHeight = 150   //将tableview的estimatedRowHeight设大一点
        tableView?.rowHeight = UITableViewAutomaticDimension
        //创建一个重用的单元格
        tableView?.register(ContentTbCells.self, forCellReuseIdentifier: "ContentCells")
        addSubview(tableView!)
        //下拉刷新
//        refreshHeader.setRefreshingTarget(self, refreshingAction: #selector(self.headerRefresh))
//        // 现在的版本要用mj_header
//        tableView?.mj_header = refreshHeader
//        // 上拉加载
//        loadFooter.setRefreshingTarget(self, refreshingAction: #selector(self.footerRefresh))
//        tableView?.mj_footer = loadFooter

//        noDataV = UIImageView()
//        noDataV.image = UIImage(named: "noDatas.png")
//        noDataV.isHidden = true
//        self.addSubview(noDataV)
//        noDataV.snp.makeConstraints { (make) in
//            make.centerY.equalTo(self)
//            make.centerX.equalTo(self)
//        }
    }
}
extension ContentV:UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let lengths = self.contentMs else{return 0}
        return lengths.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "ContentCells", for: indexPath as IndexPath) as! ContentTbCells
        let datas: ContentMs = self.contentMs![indexPath.row] as ContentMs
        //除去选中时的颜色
        cell.selectionStyle = .none
        cell.contentLable.text = "\(datas.title)"
        return cell
    }
}
//extension ContentV{
//    //下拉刷新
//    func headerRefresh(){
//        contentVDel?.pullRefresh(contentV: self)
//    }
//    //上拉加载
//    func footerRefresh(){
//        contentVDel?.loadRefresh(contentV: self)
//    }
//}

