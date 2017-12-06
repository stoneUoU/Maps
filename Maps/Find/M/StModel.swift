//
//  StModel.swift
//  Maps
//
//  Created by test on 2017/11/6.
//  Copyright © 2017年 com.youlu. All rights reserved.
//

import UIKit
class StModel: NSObject {
    var name : NSString!;
    var titleView : NSString!;
    var isShow : Bool!;
    var height : CGFloat!;

    init(dict : NSDictionary){
        super.init();
        name = dict.value(forKey: "name") as! NSString!;
        titleView = dict.value(forKey: "titleView") as! NSString!;
        isShow = false;
        height = 50;
    }
}
