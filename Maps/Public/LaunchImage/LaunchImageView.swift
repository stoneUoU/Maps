//
//  LaunchImageView.swift
//  AppLaunchADExample
//
//  Created by 童星 on 2016/10/28.
//  Copyright © 2016年 童星. All rights reserved.
//

import UIKit

class LaunchImageView: UIImageView {

    public var target: AnyObject?
    public var action: Selector?

    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addTarget(target: Any?, action: Selector ) {
        self.target = target as AnyObject?
        self.action = action
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (self.target?.responds(to: action))! {
            _ = self.target?.perform(action, with: self)
        }
    }

}
