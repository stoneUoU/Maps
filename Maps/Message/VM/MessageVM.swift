//
//  MessageVM.swift
//  Maps
//
//  Created by test on 2017/10/9.
//  Copyright © 2017年 com.youlu. All rights reserved.
//

import UIKit
import SwiftyJSON
//protocol MessageVMDelegate: class {
//    //注销成功或失败的状态，到控制器中执行相应的代码逻辑
//    func toExecute(messageVM : MessageVM,strCode:Int)
//}
class MessageVM: NSObject {
    //weak var messageVMDelegate : MessageVMDelegate?
    func toTest(paras : [String : Any]? = nil, _ finishCallback : @escaping (_ result: Any) -> ()) {
        AlamofireStart.requestData(.POST, options:"book_carts.php",parameters:paras,token:"",sign:1) { (result) in
            finishCallback(result)
            print(JSON(result),"JSON(result)")
//            if JSON(result)["status"] == 0{
//                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now(), execute: {
//                    toast.showToast(text: "\(JSON(result)["info"])", pos: .Mid)
//                    self.messageVMDelegate?.toExecute(messageVM : self,strCode: JSON(result)["status"].int!)
//                })
//            }
        }
    }
}

