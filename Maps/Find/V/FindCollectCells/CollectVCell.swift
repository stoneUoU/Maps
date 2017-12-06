//
//  CollectVCell.swift
//  Maps
//
//  Created by test on 2017/11/15.
//  Copyright © 2017年 com.youlu. All rights reserved.
//

import UIKit
class CollectVCell: UICollectionViewCell {
    lazy var imgV = UIImageView()
    lazy var textLab = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupUI(){
        imgV = UIImageView()
        self.addSubview(imgV)
        imgV.snp_makeConstraints { (make) in
            make.top.equalTo(self).offset(PublicFunc.setHeight(size:6))
            make.centerX.equalTo(self)
            make.width.height.equalTo(PublicFunc.setHeight(size:28))
        }
        //底部的label 初始化
        textLab.font = .systemFont(ofSize: 12)
        textLab.textColor = .black
        textLab.textAlignment = .center
        self.addSubview(textLab)
        textLab.snp.makeConstraints { (make) -> Void in
            make.bottom.equalTo(self.snp.bottom).offset(-PublicFunc.setHeight(size:6))
            make.left.equalTo(0)
            make.width.equalTo(self)
        }
    }
}
