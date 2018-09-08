//
//  ContentVC.swift
//  Maps
//
//  Created by test on 2017/11/24.
//  Copyright © 2017年 com.youlu. All rights reserved.
//

import UIKit
import SwiftyJSON
import MethodSDK
class ContentVC: UIViewController {
    fileprivate lazy var tabSwitchVM : TabSwitchVM = TabSwitchVM()
    // MARK: - Build UI mineView
    var contentMs : [ContentMs] = [ContentMs]()
    lazy var contentV: ContentV = {[weak self] in
        let titleFrame = CGRect(x: 0, y: 0, width: ScreenInfo.width, height: ScreenInfo.height-StatusBarAndNavigationBarH)
        let contentV = ContentV(frame: titleFrame)
        return contentV
    }()
    var intIndex:Int = 0
    var paras = [String : Any]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.setUpUI()
        loadFirstR(intIndex:intIndex)

        //通过闭包调用主页刷新（更换性别）
        TabSwitchVC.netBlock = { [weak self] in
            STLog("有网，刷新")
        }

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
extension ContentVC{
    func setUpUI(){
        self.view.addSubview(contentV)
    }
    //第一次进来
    func loadFirstR(intIndex:Int){
        switch intIndex {
        case FreshID:
            self.paras = ["cond":["title":"","type_id": ""  ,"sort":0],"limit":10,"page":1]
        default:
            self.paras = ["cond":["title":"","type_id":intIndex ,"sort":0],"limit":10,"page":1]
        }
        self.tabSwitchVM.fetchDatas(paras:self.paras){(result) in
            if JSON(result)["code"] == 0{
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now(), execute: {
                    self.contentMs.removeAll()
                    self.contentV.contentMs?.removeAll()
                    for i in 0..<Int(JSON(result)["data"].count) {
                        let datas = ContentMs(type_id: "\(JSON(result)["data"][i]["type_id"])",pic: "\(JSON(result)["data"][i]["pic"])",type_name: "\(JSON(result)["data"][i]["type_name"])",create_time: "\(JSON(result)["data"][i]["create_time"])", title: "\(JSON(result)["data"][i]["title"])",id: "\(JSON(result)["data"][i]["id"])",browser: "\(JSON(result)["data"][i]["browser"])",model: "\(JSON(result)["data"][i]["model"])")
                        self.contentMs.append(datas)
                    }
                    self.contentV.contentMs = self.contentMs
                })
            }else{
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now(), execute: {
                    StToastSDK().showToast(text:"\(JSON(result)["msg"])",type:Pos)
                })
            }
        }
    }
}

