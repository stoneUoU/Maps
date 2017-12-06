//
//  ContentTbCells.swift
//  Maps
//
//  Created by test on 2017/11/26.
//  Copyright © 2017年 com.youlu. All rights reserved.
//

import UIKit
class ContentTbCells: UITableViewCell {
    //懒加载label
    var contentLable:UILabel!
    //重写cell init方法
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupUI(){
        let label2 = UILabel()
        label2.font = .systemFont(ofSize: 14)
        label2.textColor = .black
        label2.numberOfLines = 0
        self.addSubview(label2)
        contentLable = label2;
        contentLable.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.top.equalTo(10)
            make.bottom.equalTo(-10)
        }
    }
}
