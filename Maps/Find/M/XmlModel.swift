//
//  XmlModel.swift
//  Maps
//
//  Created by test on 2017/12/20.
//  Copyright © 2017年 com.youlu. All rights reserved.
//

import UIKit

class XmlModel: NSObject {
    var uid : String!;
    var uname : String!;
    var mobile : String!;
    var home : String!;

    init(uid : String,uname:String,mobile:String,home:String){
        super.init();
        self.uid = uid
        self.uname = uname
        self.mobile = mobile
        self.home = home
    }
}


struct XmlStruct {
    var uid :String
    var uname :String
    var mobile :String
    var home :String
}
