//
//  FolderModel.swift
//  Maps
//
//  Created by test on 2018/1/10.
//  Copyright © 2018年 com.youlu. All rights reserved.
//

import UIKit
//class FolderModel: NSObject {
//    var dataMs_list : [[String : NSObject]]?{
//        didSet{
//            //这里要guard守护
//            guard let dataMs_list = dataMs_list else{return}
//            for dict in dataMs_list{
//                datas.append(DataMs(dict:dict))
//            }
//        }
//    }
//    var code: String = ""
//    var msg: String = ""
//    var total :String = ""
//    lazy var datas: [DataMs] = [DataMs]()
//
//    //这里涉及计算，所以就不要设置为可选了  对外提供的参数之间为不可选的
//    init(dict: [String: NSObject]) {
//        super.init()
//        setValuesForKeys(dict)
//    }
//
//    override func setValue(_ value: Any?, forUndefinedKey key: String) {
//        //在这里面可以做映射
//    }
//
//}

class DataMs: NSObject {
    //["email": , "person_address": , "id": 123, "company_num": , "invoice_name": O, "tel": , "user_id": 10006, "type": 0, "create_time": 2018-01-10 10:13:45]

    var email : String = "";
    var person_address : String = "";
    var id : Int = 0;
    var company_num : String = "";
    var invoice_name : String = "";
    var tel : String = "";
    var user_id : Int = 0;
    var type : Int = 0;
    var create_time : String = "";

    init(dict: [String: NSObject]) {
        super.init()

        setValuesForKeys(dict)
    }

    override func setValue(_ value: Any?, forUndefinedKey key: String) {

    }
}

