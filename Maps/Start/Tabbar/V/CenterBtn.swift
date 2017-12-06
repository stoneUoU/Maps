//
//  CenterBtn.swift
//  Centers
//
//  Created by test on 2017/9/29.
//  Copyright © 2017年 com.youlu. All rights reserved.
//

import UIKit

class CenterBtn: UIButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imageSize:CGSize = self.imageView!.frame.size
        let titleSize:CGSize = self.titleLabel!.frame.size
        
        let space: CGFloat = 0.0
        
        self.imageEdgeInsets = UIEdgeInsets(top: -titleSize.height - space, left: 0, bottom: 0, right: -titleSize.width)
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left:-imageSize.width, bottom: -imageSize.height - space, right: 0)
    }
    
}
