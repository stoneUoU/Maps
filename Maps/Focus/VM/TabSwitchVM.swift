//
//  TabSwitchVM.swift
//  Maps
//
//  Created by test on 2017/11/24.
//  Copyright © 2017年 com.youlu. All rights reserved.
//

import UIKit
import SwiftyJSON
//protocol QuackVMDelegate: class {
//    //获取系统信息是否成功，到控制器中执行相应的代码逻辑
//    func toExecute(quackVM:QuackVM,strCode:Int)
//}
class TabSwitchVM: NSObject {
    //weak var quackVMDelegate : QuackVMDelegate?
    var totalMount:Double = 0
    var token = UserDefaults.standard.object(forKey: "token") as? String
    var tabSwitchMs:[TabSwitchMs] = [TabSwitchMs]()
    var contentMs : [ContentMs] = [ContentMs]()
    func getTitleInfos(paras : [String : Any]? = nil, _ finishCallback : @escaping (_ result: Any) -> ()) {
        AlamofireStart.requestData(.POST, options:"/app/news/type/list",parameters:paras, token: ssid, sign: 0) { (result) in
            if JSON(result)["code"] == 0{
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now(), execute: {
                    self.tabSwitchMs.removeAll()
                    for i in 0..<Int(JSON(result)["data"].count) {
                        let dataOne = TabSwitchMs(name:"\(JSON(result)["data"][i]["name"])",id:"\(JSON(result)["data"][i]["id"])");
                        self.tabSwitchMs.append(dataOne)
                    }
                    finishCallback(result)
                })
            }else{
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now(), execute: {
                    StToast().showToast(text:"\(JSON(result)["msg"])",type:Pos)
                })
            }
        }
    }

    func fetchDatas(paras : [String : Any]? = nil, _ finishCallback : @escaping (_ result: Any) -> ()) {
        AlamofireStart.requestData(.POST, options:"/app/news/list",parameters:paras, token: ssid, sign: 0)  { (result) in
            finishCallback(result)
        }
    }
}
