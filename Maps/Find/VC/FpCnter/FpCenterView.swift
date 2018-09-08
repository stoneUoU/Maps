//
//  FpCenterView.swift
//  Gfoods
//
//  Created by test on 2017/9/5.
//  Copyright © 2017年 com.youlu. All rights reserved.
//

import UIKit
import SnapKit
import MJRefresh
//发票中心
//此界面的tableCell是用MineTableCell.swift
protocol FpCenterViewDelegate: class {
    //去编辑发票
    func toEditFp(fpCenterView : FpCenterView,str:FpCenterModels)
    //下拉刷新
    func pullRefresh(fpCenterView : FpCenterView)
    //上拉加载
    func loadRefresh(fpCenterView : FpCenterView)

    //有网去刷新
    func netRefresh(fpCenterView : FpCenterView)
}
class FpCenterView: UIView {
    var st_place = NonetAnimateView.init()
    var tableView : UITableView?
    //顶部刷新
    var refreshHeader = MJRefreshNormalHeader()
    //底部加载更多
    var loadFooter = MJRefreshAutoNormalFooter()
    lazy var botView: UIView = {[weak self] in
        let botView = UIView()
        botView.backgroundColor = UIColor.colorWithCustom(243, g: 245, b: 248)
        let Addbtn = UIButton()
        Addbtn.setTitle("添加发票抬头", for:.normal)
        Addbtn.backgroundColor = UIColor.white
        //Addbtn.addTarget(self, action:#selector(AddFp(_:)),for: .touchUpInside)
        Addbtn.setTitleColor(UIColor.colorWithCustom(242, g: 71, b: 30), for: .normal) //普通状态下文字的颜色
        Addbtn.titleLabel?.font = UIFont.UiFontSize(size: 18)
        Addbtn.isUserInteractionEnabled = true
        Addbtn.layer.cornerRadius = 5
        Addbtn.layer.masksToBounds = true
        botView.addSubview(Addbtn)
        Addbtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(botView)
            make.centerX.equalTo(botView)
            make.width.equalTo(ScreenInfo.width - 15 * 2)
            make.height.equalTo(PublicFunc.setHeight(size: 44))
        }
        return botView
        }()
    //var Addbtn = UIButton()
    weak var fpCenterViewDelegate : FpCenterViewDelegate?
    var fpCenterModels : [FpCenterModels]?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension FpCenterView{
    func setupUI(){
        self.addSubview(botView)
        botView.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.snp.bottom).offset(-TabbarSafeBotM)
            make.left.equalTo(0)
            make.width.equalTo(ScreenInfo.width )
            make.height.equalTo(PublicFunc.setHeight(size: 60))
        }

        tableView=UITableView.init(frame: CGRect(x:0,y:StatusBarAndNavigationBarH,width:ScreenInfo.width,height:ScreenInfo.height - PublicFunc.setHeight(size: 60) - StatusBarAndNavigationBarH - TabbarSafeBotM ), style:.grouped)
        tableView?.delegate=self;//实现代理
        tableView?.dataSource=self;//实现数据源
        tableView?.backgroundColor = UIColor.colorWithCustom(243, g: 245, b: 248,alpha: 1)
        tableView?.showsVerticalScrollIndicator = false
        tableView?.showsHorizontalScrollIndicator = false
        tableView?.separatorStyle = UITableViewCellSeparatorStyle.none
        addSubview(tableView!)
        //创建一个重用的单元格
        tableView?.register(FpCenterGRTableCells.self, forCellReuseIdentifier: "FpCenterGRCells")
        tableView?.register(FpCenterGSTableCells.self, forCellReuseIdentifier: "FpCenterGSCells")
        //下拉刷新
        refreshHeader.setRefreshingTarget(self, refreshingAction: #selector(self.headerRefresh))
        // 现在的版本要用mj_header
        tableView?.mj_header = refreshHeader
        // 上拉加载
        loadFooter.setRefreshingTarget(self, refreshingAction: #selector(self.footerRefresh))
        tableView?.mj_footer = loadFooter
        tableView?.estimatedRowHeight = 0;
        tableView?.estimatedSectionHeaderHeight = 0;
        tableView?.estimatedSectionFooterHeight = 0;
    }
    func addTipsV(imgArr:Array<String>,tipStr:String,ifRefresh:Bool){
        st_place =  NonetAnimateView.init(frame:(self.tableView?.bounds)!)
        st_place.showNonetView(tipStr, imageArray: imgArr, toView: self.tableView!)
        self.tableView?.bringSubview(toFront: self.refreshHeader)
        st_place.click_closure = {
            self.fpCenterViewDelegate?.netRefresh(fpCenterView: self)
        }
    }
    func removeTipsV(){
        st_place.removeFromSuperview();
    }
}
extension FpCenterView:UITableViewDataSource, UITableViewDelegate {
    //段数
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let lengths = self.fpCenterModels else{return 0}
        return lengths.count
    }
    //行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    //设置行高
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return PublicFunc.setHeight(size: 65);
    }
    //set Footer Height
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return PublicFunc.setHeight(size: 0.0001);
    }
    //set Header Height
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return PublicFunc.setHeight(size: 10);
    }
    //设置单元格间的边框位置
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0);
    }
    //cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let datas: FpCenterModels = self.fpCenterModels![indexPath.section] as FpCenterModels
        switch Int(datas.type)! {
        case 1:
            let cell=tableView.dequeueReusableCell(withIdentifier: "FpCenterGSCells", for: indexPath as IndexPath) as! FpCenterGSTableCells
            //除去选中时的颜色
            cell.backgroundColor = UIColor.colorWithCustom(241, g: 243, b: 246,alpha: 1)
            cell.selectionStyle = .none
            cell.name.text = "\(datas.invoice_name)"
            cell.icon_img.image = UIImage(named: "img_fapiao_gongsi.png")
            cell.ifTaxName.text = "税号：\(datas.company_num)"
            cell.backgroundColor = UIColor.colorWithCustom(243, g: 245, b: 248,alpha: 1)
            return cell
        default:
            let cell=tableView.dequeueReusableCell(withIdentifier: "FpCenterGRCells", for: indexPath as IndexPath) as! FpCenterGRTableCells
            //除去选中时的颜色
            cell.backgroundColor = UIColor.colorWithCustom(241, g: 243, b: 246,alpha: 1)
            cell.selectionStyle = .none
            cell.name.text = "\(datas.invoice_name)"
            cell.icon_img.backgroundColor = UIColor.colorWithCustom(242, g: 71, b: 30,alpha: 1)
            cell.icon_img.image = UIImage(named: "img_fapiao_geren.png")
            return cell
        }
    }
    //点击发票编辑 0：个人   1：公司
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now(), execute: {
            let datas: FpCenterModels = self.fpCenterModels![indexPath.section] as FpCenterModels
            //通知代理
            self.fpCenterViewDelegate?.toEditFp(fpCenterView : self,str:datas)
        })
    }
    
}
extension FpCenterView{
    //下拉刷新
    func headerRefresh(){
        fpCenterViewDelegate?.pullRefresh(fpCenterView: self)
    }
    //上拉加载
    func footerRefresh(){
        fpCenterViewDelegate?.loadRefresh(fpCenterView: self)
    }

//    func AddFp(_:UIButton){
//        fpCenterViewDelegate?.toAddFp(fpCenterView: self)
//    }
}
