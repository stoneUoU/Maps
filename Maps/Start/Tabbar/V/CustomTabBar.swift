//
//  CustomTabBar.swift
//  Centers
//
//  Created by test on 2017/9/29.
//  Copyright © 2017年 com.youlu. All rights reserved.
//

import UIKit

class CustomTabBar: UITabBar {
    
    let tabBarView = TabBarItemsV()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.addSubview(tabBarView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        tabBarView.frame = self.bounds
        self.bringSubview(toFront: tabBarView)
    }
    
    // 重写hitTest方法，让超出tabBar部分也能响应事件
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        if self.clipsToBounds || self.isHidden || self.alpha == 0.0 {
            return nil
        }
        
        //如果事件发生在tabbar里面直接返回
        if let view = super.hitTest(point, with: event) {
            return view
        }
        
        for item in tabBarView.subviews {
            //将坐标从tabbar的坐标系转为item的坐标系
            let itemPoint = item.convert(point, from: self)
            
            //如果事件发生在tabbar里面直接返回
            if let view = item.hitTest(itemPoint, with: event) {
                return view
            }
        }
        
        return nil
    }
    
}

