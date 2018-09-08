//
//  FpCenterVM.swift
//  Gfoods
//
//  Created by test on 2017/9/5.
//  Copyright © 2017年 com.youlu. All rights reserved.
//

import UIKit
import SwiftyJSON
import MethodSDK
protocol FpCenterVMDelegate: class {
    //获取发票信息是否成功，到控制器中执行相应的代码逻辑
    func toExecute(fpCenterVM:FpCenterVM,strCode:Int)
}
class FpCenterVM: NSObject {
    weak var fpCenterVMDelegate : FpCenterVMDelegate?
    var fpCenterModels:[FpCenterModels] = [FpCenterModels]()
    var dataMs:[DataMs] = [DataMs]()
    var totalMount:Double = 0
    func getFPInfos(paras : [String : Any]? = nil, _ finishCallback : @escaping (_ result: Any) -> ()) {
        NetToolsSDK.requestData(.POST, options:"/invoice/operation",parameters:paras, token: Authos) { (result) in
            switch JSON(result)["RequestFail"] {
            case true:
                //网络请求超时
                self.fpCenterVMDelegate?.toExecute(fpCenterVM : self,strCode: 666)
            default:
                if JSON(result)["code"] == 0{
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now(), execute: {
                        guard let dict = result as? [String : NSObject] else { return }
                        guard let datas = dict["data"] as? [[String : NSObject]] else { return }
                        for dicts in datas{
                            //这里涉及计算，所以上面直接守护了dataArray
                            let group = DataMs(dict: dicts)
                            self.dataMs.append(group)
                        }
                        let datasM: DataMs = self.dataMs[0] as DataMs
                        STLog(datasM.id)

                        self.totalMount = Double("\(JSON(result)["total"])")!
                        for i in 0..<Int(JSON(result)["data"].count) {
                            let datas = FpCenterModels(person_address: "\(JSON(result)["data"][i]["person_address"])",company_num:"\(JSON(result)["data"][i]["company_num"])",tel: "\(JSON(result)["data"][i]["tel"])",user_id: "\(JSON(result)["data"][i]["user_id"])",create_time: "\(JSON(result)["data"][i]["create_time"])",invoice_name: "\(JSON(result)["data"][i]["invoice_name"])",type: "\(JSON(result)["data"][i]["type"])",id: "\(JSON(result)["data"][i]["id"])",email: "\(JSON(result)["data"][i]["email"])");
                            self.fpCenterModels.append(datas)
                        }
                        finishCallback(result)
                    })
                }else{
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now(), execute: {
                        StToastSDK().showToast(text:"\(JSON(result)["msg"])",type:Pos)
                        self.fpCenterVMDelegate?.toExecute(fpCenterVM : self,strCode: JSON(result)["code"].int!)
                    })
                }
            }
        }
    }
}
