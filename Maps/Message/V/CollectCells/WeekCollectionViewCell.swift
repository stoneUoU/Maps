//
//  WeekCollectionViewCell.swift
//  Maps
//
//  Created by test on 2017/11/21.
//  Copyright © 2017年 com.youlu. All rights reserved.
//

import UIKit

class WeekCollectionViewCell: UICollectionViewCell {


    lazy var timeLabel: UILabel = {
        let time = UILabel(frame: CGRect.zero)
        time.text = "一"
        time.textAlignment = .center
        return time
    }()
    lazy var lineV: UIView = {
        let view = UIView(frame: CGRect.zero)
        view.backgroundColor = UIColor.lightGray
        return view
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(timeLabel)
        self.addSubview(lineV)
        timeLabel.snp.makeConstraints{
            (make) in
            make.center.equalTo(self)
        }
        lineV.snp.makeConstraints{
            (make) in
            make.height.equalTo(1)
            make.width.equalTo(self)
            make.left.equalTo(self)
            make.bottom.equalTo(self.snp.bottom).offset(0)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
