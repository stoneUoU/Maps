//
//  FindVM.swift
//  Maps
//
//  Created by test on 2017/10/23.
//  Copyright © 2017年 com.youlu. All rights reserved.
//
import UIKit
import SwiftyJSON
import MethodSDK
class FindVM: NSObject {
    var dataArr = [
        ["png":"pop_2FA.png","vals":"京东超市"],
        ["png":"pop_Message.png","vals":"全球购"],
        ["png":"pop_Project.png","vals":"京东服饰"],
        ["png":"pop_Task.png","vals":"京东生鲜"],
        ["png":"pop_Tweet.png","vals":"京东到家"],
        ["png":"pop_User.png","vals":"充值缴费"],
        ["png":"pop_2FA.png","vals":"领京豆"],
        ["png":"pop_Message.png","vals":"领券"],
        ["png":"pop_Project.png","vals":"赚钱"],
        ["png":"pop_Task.png","vals":"plus会员"],
        ["png":"pop_Tweet.png","vals":"排行榜"],
        ["png":"pop_User.png","vals":"二手优品"],
        ["png":"pop_User.png","vals":"机票火车票"],
        ["png":"pop_2FA.png","vals":"京东回收"],
        ["png":"pop_Message.png","vals":"京东试用"],
        ["png":"pop_Project.png","vals":"司法拍卖"],
        ["png":"pop_Task.png","vals":"装机大师"],
        ["png":"pop_Tweet.png","vals":"京东智能"],
        ["png":"pop_2FA.png","vals":"沃尔玛"],
        ["png":"pop_Message.png","vals":"全部"]
    ]
    var oDatas:[UoUDatas] = [UoUDatas]()
    var titles:[String] = [String]();
    var imagesURLStrings:Array<String> = [];
    func getInfos(paras : [String : Any]? = nil, _ finishCallback : @escaping (_ result: Any) -> ()) {
        NetToolsSDK.requestData(.POST, options:"account/info",parameters:paras, token: Authos) { (result) in
            self.titles = ["我是林磊1",
               "如果代码在使用过程中出现问题",
               "您可以发邮件到coderjianfeng@foxmail.com,我是Stone我是Stone我是Stone"
            ]
            self.imagesURLStrings = [
                "http://img2.niutuku.com/desk/130220/37/37-niutuku.com-927.jpg",
                "http://img2.niutuku.com/desk/1207/1059/ntk122096.jpg",
                "http://img.bizhi.sogou.com/images/2013/07/17/347470.jpg",
                "http://img.bizhi.sogou.com/images/2012/02/11/260497.jpg"
            ];
            for i in 0..<Int(self.dataArr.count) {
                let dataOne = UoUDatas(png: "\(self.dataArr[i]["png"]!)",vals:"\(self.dataArr[i]["vals"]!)");
                self.oDatas.append(dataOne)
            }
            finishCallback(result)
        }
    }
    func getFresh(paras : [String : Any]? = nil, _ finishCallback : @escaping (_ result: Any) -> ()) {
        NetToolsSDK.requestData(.POST, options:"account/info",parameters:paras, token: Authos) { (result) in
            sleep(2)
            self.titles = ["1024程序员节",
                           "双11光棍节",
                           "除夕春节"
            ]
            self.imagesURLStrings = [
                "http://img2.niutuku.com/desk/1208/1413/ntk-1413-619.jpg",
                "http://img.bizhi.sogou.com/images/2013/07/17/347636.jpg",
                "http://img2.niutuku.com/desk/1208/2031/ntk-2031-2733.jpg",
                "http://dl.bizhi.sogou.com/images/2013/07/17/347434.jpg"
            ];
            for i in 0..<Int(self.dataArr.count) {
                let dataOne = UoUDatas(png: "\(self.dataArr[i]["png"]!)",vals:"\(self.dataArr[i]["vals"]!)");
                self.oDatas.append(dataOne)
            }
            finishCallback(result)
        }
    }
}
