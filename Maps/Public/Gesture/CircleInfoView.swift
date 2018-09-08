//
//  CircleInfoView.swift
//  Maps
//
//  Created by test on 2018/1/4.
//  Copyright © 2018年 com.youlu. All rights reserved.
//
import UIKit

class CircleInfoView: UIView {

    private let sizeRatio: CGFloat = 0.08
    private let circleRadiusRatio: CGFloat = 0.3
    var circles: [Circle] = [Circle]()

    init() {
        super.init(frame: CGRect.zero)
        initCircles()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initCircles()
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        layoutCircles()
    }

    func initCircles() {
        self.backgroundColor = UIColor.white
        let ScreenW = UIScreen.main.bounds.size.width
        let ScreenH = UIScreen.main.bounds.size.height
        self.bounds = CGRect(x: 0, y: 0, width: ScreenW * sizeRatio, height: ScreenW * sizeRatio)
        self.center = CGPoint(x: ScreenW / 2, y: ScreenH / 6 + 50)

        for i in 0...8 {
            let circle = Circle()
            circle.tag = i + 1
            circle.type = .info
            circle.state = .normal
            circles.append(circle)
            self.addSubview(circle)
        }
    }

    func layoutCircles() {
        let circleWidth = self.bounds.size.width * circleRadiusRatio
        let marginValue = (self.bounds.size.width - circleWidth * 3) / 2
        for (index, circle) in circles.enumerated() {
            let row = index / 3
            let column = index % 3
            let originX = CGFloat(column) * (circleWidth + marginValue)
            let originY = CGFloat(row) * (circleWidth + marginValue)
            circle.frame = CGRect(x: originX, y: originY, width: circleWidth, height: circleWidth)
        }
    }
}

extension CircleInfoView {
    func fillCircles(withNumber numbers: String) {
        for (_, numString) in numbers.characters.enumerated() {
            for (_, circle) in self.circles.enumerated() {
                if Int(String(numString)) == circle.tag {
                    circle.state = .selected
                }
            }
        }
    }

    func clean() {
        for (_, circle) in self.circles.enumerated() {
            circle.state = .normal
        }
    }
}

