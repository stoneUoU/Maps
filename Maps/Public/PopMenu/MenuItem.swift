//
//  MenuItem.swift
//  Maps
//
//  Created by test on 2017/10/16.
//  Copyright © 2017年 com.youlu. All rights reserved.
//

import Foundation
import UIKit

class MenuItem: NSObject{
    var title:String!;
    var iconImage:UIImage!;
    var position:NSInteger!;
    
    init(title:String, iconName:String, position:NSInteger) {
        super.init();
        self.title = title;
        self.iconImage = UIImage(named: iconName);
        self.position = position;
    }
}

