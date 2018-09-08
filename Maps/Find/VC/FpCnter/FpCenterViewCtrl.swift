//
//  FpCenterViewCtrl.swift
//  Gfoods
//
//  Created by test on 2017/9/4.
//  Copyright © 2017年 com.youlu. All rights reserved.
//

import UIKit
import SwiftyJSON
import MJRefresh
//import MethodSDK
//发票中心
class FpCenterViewCtrl: BaseToolVC {
    //第几页：
    var index = 1
    //每页显示几条数据
    var pageSize:Double = 10
    //数据总数
    var totalMount:Double = 0
    //断网时的数据
    var fpCenterModels:[FpCenterModels] = [FpCenterModels]()
    var netUseVals:String!
    var noticeObser:Bool? {
        didSet {
            _ = SnailNotice.add(observer: self, selector: #selector(FpCenterViewCtrl.setNet(notification:)), notification: .netChange)
        }
    }
    
    fileprivate lazy var fpCenterVM : FpCenterVM = FpCenterVM()
    lazy var fpCenterView: FpCenterView = {[weak self] in
        let titleFrame = CGRect(x: 0, y: 0, width: ScreenInfo.width, height: ScreenInfo.height)
        let fpCenterView = FpCenterView(frame: titleFrame)
        fpCenterView.fpCenterViewDelegate = self
        return fpCenterView
        }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setUp(centerVals: "我的发票", rightVals: "")
        self.view.backgroundColor = UIColor.colorWithCustom(241, g: 243, b: 246,alpha: 1)
        // Do any additional setup after loading the view.
        self.fpCenterView.loadFooter.isHidden = true
        noticeObser = true //开启所有观察
        //监听是否有网
        netUseVals = keychain.get("ifnetUseful")
        SelectVC()
    }
    deinit {
        SnailNotice.remove(observer: self, notification: .netChange)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.setHidesBackButton(true, animated: true)
        CustomTabBarVC.hideBar(animated: true);
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func setNet(notification:NSNotification) {
        netUseVals = notification.userInfo!["netUseful"] as! String
    }
}
extension FpCenterViewCtrl:FpCenterViewDelegate,FpCenterVMDelegate{
    func netRefresh(fpCenterView: FpCenterView) {
        self.SelectVC()
    }
    func setupUI(){
        //FpCenterVMDelegate
        fpCenterVM.fpCenterVMDelegate = self
        self.view.addSubview(fpCenterView)
    }
    //进界面查询
    func SelectVC(){
        if netUseVals == "Useable"{
            HudTips.showHUD(ctrl: self)
            let paras = ["opr":"search","data":["page":1,"limit":pageSize,"cond":["id":""]]] as [String : Any]
            self.fpCenterView.fpCenterModels?.removeAll()
            //移除ViewModels里面的数据
            self.fpCenterVM.fpCenterModels.removeAll()
            //获取发票信息
            fpCenterVM.getFPInfos(paras:paras){(result) in
                if JSON(result)["code"] == 0{
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now(), execute: {
                        self.fpCenterView.fpCenterModels =  self.fpCenterVM.fpCenterModels
                        self.totalMount = self.fpCenterVM.totalMount
                        if self.totalMount == 0{
                            self.fpCenterView.removeTipsV()
                            self.fpCenterView.addTipsV(imgArr: ["empty"], tipStr: "没有数据哟", ifRefresh: true)
                        }else{
                            self.fpCenterView.removeTipsV()
                        }
                        self.fpCenterView.tableView?.reloadData()
                        HudTips.hideHUD(ctrl: self)
                        //此操作是为了解决当数据量不够分页时，隐藏loadFooter
                        if self.pageSize >= self.totalMount{
                            self.fpCenterView.loadFooter.isHidden = true
                        }else{
                            self.fpCenterView.loadFooter.isHidden = false
                        }
                    })
                }
            }
        }else{
            //没网时从这里取数据
            HudTips.hideHUD(ctrl: self)
            self.fpCenterView.addTipsV(imgArr: ["deer1","deer2","deer3"], tipStr: "没有连接到网络，心里空空的", ifRefresh: false)
        }
    }
    func AddFp(_:UIButton){
        STLog("增加")
    }
    func pullRefresh(fpCenterView: FpCenterView) {
        if netUseVals == "Useable"{
            let paras = ["opr":"search","data":["page":1,"limit":pageSize,"cond":["id":""]]] as [String : Any]
            self.fpCenterView.fpCenterModels?.removeAll()
            //移除ViewModels里面的数据
            self.fpCenterVM.fpCenterModels.removeAll()
            self.fpCenterView.loadFooter.isHidden = true
            //获取发票信息
            fpCenterVM.getFPInfos(paras:paras){(result) in
                if JSON(result)["code"] == 0{
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now(), execute: {
                        self.fpCenterView.fpCenterModels =  self.fpCenterVM.fpCenterModels
                        self.index = 1 //刷新后将index恢复为1
                        fpCenterView.refreshHeader.endRefreshing()
                        self.totalMount = self.fpCenterVM.totalMount
                        if self.totalMount == 0{
                            self.fpCenterView.removeTipsV()
                            self.fpCenterView.addTipsV(imgArr: ["empty"], tipStr: "没有数据哟", ifRefresh: true)
                        }else{
                            self.fpCenterView.removeTipsV()
                        }
                        self.fpCenterView.tableView?.reloadData()
                        fpCenterView.loadFooter.resetNoMoreData()
                        //此操作是为了解决当数据量不够分页时，隐藏loadFooter
                        if self.pageSize >= self.totalMount{
                            self.fpCenterView.loadFooter.isHidden = true
                        }else{
                            self.fpCenterView.loadFooter.isHidden = false
                        }
                    })
                }else{
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now(), execute: {
                        StToastSDK().showToast(text:"\(JSON(result)["msg"])",type:Pos)
                        
                        self.fpCenterView.refreshHeader.endRefreshing()
                        HudTips.hideHUD(ctrl: self)
                    })
                }
            }
        }else{
            StToastSDK().showToast(text:"\(missNetTips)",type: Pos )
            fpCenterView.refreshHeader.endRefreshing()
        }
    }
    func loadRefresh(fpCenterView: FpCenterView) {
        if netUseVals == "Useable"{
            index = index + 1
            let paras = ["opr":"search","data":["page":index,"limit":pageSize,"cond":["id":""]]] as [String : Any]
            //获取发票信息
            fpCenterVM.getFPInfos(paras:paras){(result) in
                if JSON(result)["code"] == 0{
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now(), execute: {
                        self.fpCenterView.fpCenterModels =  self.fpCenterVM.fpCenterModels
                        self.fpCenterView.tableView?.reloadData()
                        fpCenterView.loadFooter.endRefreshing()
                        STLog(Double(self.index));
                        STLog(ceil(self.totalMount/self.pageSize));
                        if Double(self.index) >= ceil(self.totalMount/self.pageSize) {
                            fpCenterView.loadFooter.endRefreshingWithNoMoreData()
                        }
                    })
                }else{
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now(), execute: {
                        self.index = self.index - 1
                        StToastSDK().showToast(text:"\(JSON(result)["msg"])",type:Pos)
                    })
                }
            }
        }else{
            StToastSDK().showToast(text:"\(missNetTips)",type: Pos )
        }
    }
    func toExecute(fpCenterVM: FpCenterVM, strCode: Int) {
        if strCode == OutCode {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5 , execute: {
                HudTips.hideHUD(ctrl: self)
                //解决请求后台返回错误时隐藏MJRefresh的底部
                self.fpCenterView.loadFooter.isHidden = true
                STLog("获取发票信息失败")
            })
        }
    }
    func  toEditFp(fpCenterView: FpCenterView, str: FpCenterModels) {
         //    0/1：个人/公司
        STLog("编辑")
    }

}
