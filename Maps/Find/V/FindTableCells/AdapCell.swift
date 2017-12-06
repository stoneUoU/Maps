//
//  WHTableViewCell.swift
//  Maps
//
//  Created by test on 2017/11/6.
//  Copyright © 2017年 com.youlu. All rights reserved.
//

import UIKit

class AdapCell: UITableViewCell {
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
        //底部的label 初始化
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
        //重点：给contentView布局，让它的底部跟contentLable的底部一致
//        contentView.snp.makeConstraints { (make) -> Void in
//            make.bottom.equalTo(self.contentLable.snp.bottom).offset(10)
//            make.leading.equalTo(self)
//            make.top.equalTo(self)
//            make.trailing.equalTo(self)
//        }
    }


}
