//
//  DateCollectionViewCell.swift
//  Maps
//
//  Created by test on 2017/11/21.
//  Copyright © 2017年 com.youlu. All rights reserved.
//

import UIKit

class DateCollectionViewCell: UICollectionViewCell {
    lazy var timeLabel: UILabel = {
        let time = UILabel(frame: CGRect.zero)
        return time
    }()
    lazy var lineV: UIView = {
        let view = UIView(frame: CGRect.zero)
        view.backgroundColor = UIColor.lightGray
        view.isHidden = true
        return view
    }()
    //是否是最后一个单元格
    var isLastCell = false

    open override func draw(_ rect: CGRect) {
        super.draw(rect)

        //线宽
        let lineWidth = 1 / UIScreen.main.scale

        //线偏移量
        let lineOffset = 1 / UIScreen.main.scale / 2

        //获取绘图上下文
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }

        //创建一个矩形，它的下方右方内缩固定的偏移量
        let drawingRect = CGRect(x: self.bounds.minX, y: self.bounds.minY,
                                 width: self.bounds.width - (isLastCell ? 0:lineOffset),
                                 height: self.bounds.height - lineOffset)

        //创建并设置路径(单元格下方和右侧的线条)
        let path = CGMutablePath()
        path.move(to: CGPoint(x: drawingRect.minX, y: drawingRect.maxY))
        path.addLine(to: CGPoint(x: drawingRect.maxX, y: drawingRect.maxY))
        //最后一个单元格不画右侧的线
        if !isLastCell {
            path.addLine(to: CGPoint(x: drawingRect.maxX, y: drawingRect.minY))
        }

        //添加路径到图形上下文
        context.addPath(path)

        //设置笔触颜色
        context.setStrokeColor(UIColor.lightGray.cgColor)
        //设置笔触宽度
        context.setLineWidth(lineWidth)

        //绘制路径
        context.strokePath()
    }
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
            make.height.equalTo(self)
            make.width.equalTo(1)
            make.left.equalTo(self)
            make.top.equalTo(self)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
