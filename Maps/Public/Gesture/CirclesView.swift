//
//  CirclesView.swift
//  Maps
//
//  Created by test on 2018/1/4.
//  Copyright © 2018年 com.youlu. All rights reserved.
//

import UIKit

//enum CirclesViewType {
//    case set, login, verify
//}

class CirclesView: UIView {

    private let sizeRatio: CGFloat = 0.68
    private let circleRadiusRatio: CGFloat = 0.25

    var circles: [Circle] = [Circle]()
    var selectedCircles: [Circle] = [Circle]()
    var currentPoint: CGPoint? = nil
    //    var type: CirclesViewType = .set
    var getPasswordClosure: ((String) -> Void)? = nil

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
        self.center = CGPoint(x: ScreenW / 2, y: ScreenH / 2 + 25.0)

        for i in 0...8 {
            let circle = Circle()
            circle.tag = i + 1
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

// MARK: - Draw
extension CirclesView {

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        drawLinesIn(rect)
    }

    func drawLinesIn(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext(), selectedCircles.count != 0 else {
            return
        }

        context.addRect(rect)
        for (_, circle) in selectedCircles.enumerated() {
            context.addEllipse(in: circle.frame)
        }
        context.clip(using: .evenOdd)


        for (index, circle) in selectedCircles.enumerated() {
            if index == 0 {
                context.move(to: circle.center)
            } else {
                context.addLine(to: circle.center)
            }
        }

        if let point = currentPoint {
            context.addLine(to: point)
        }

        var color: UIColor = UIColor.clear
        let circle = selectedCircles.first
        if circle != nil {
            color = (circle!.state == .warningTapped) || (circle!.state == .warningConnected) ? Color.destructiveColor : Color.normalColor
        }

        context.setLineCap(.round)
        context.setLineJoin(.round)
        context.setStrokeColor(color.cgColor)
        context.setLineWidth(2)
        context.strokePath()
    }
}

// MARK: - Event
extension CirclesView {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }

        clean()
        if let circle = touch.view as? Circle {
            circle.state = .normalTapped
            selectedCircles.append(circle)
        }
        setNeedsDisplay()
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }

        currentPoint = nil
        if let circle = hitTest(touch.location(in: self), with: event) as? Circle {
            if selectedCircles.contains(circle) == false {
                circle.state = .normalTapped
                selectedCircles.append(circle)

                if selectedCircles.count >= 2 {
                    let previousCircle = selectedCircles[selectedCircles.count - 2]
                    let lastCircle = selectedCircles.last!
                    calAngleBetween(previousCircle, and:lastCircle)
                    connectMiddleCircleBetween(previousCircle, and:lastCircle)
                }
            }
        } else {
            currentPoint = touch.location(in: self)
        }
        setNeedsDisplay()
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if selectedCircles.count == 0 {
            return
        }
        if let closure = getPasswordClosure {
            var password: String = ""
            for (_, circle) in selectedCircles.enumerated() {
                password = password + String(circle.tag)
            }
            closure(password)
        }
    }

    private func calAngleBetween(_ circle: Circle, and lastCircle: Circle) {
        guard selectedCircles.count >= 2 else {
            return
        }

        let angle = atan2(lastCircle.center.y - circle.center.y, lastCircle.center.x - circle.center.x) + CGFloat(M_PI_2)
        circle.angle = angle
        circle.state = .normalConnected
    }

    private func connectMiddleCircleBetween(_ previousCircle: Circle, and lastCircle: Circle) {
        let middleX = (previousCircle.center.x + lastCircle.center.x) / 2
        let middleY = (previousCircle.center.y + lastCircle.center.y) / 2
        for (_, circle) in circles.enumerated() {
            if (selectedCircles.contains(circle) == false) && (circle.center.equalTo(CGPoint(x: middleX, y: middleY))) {
                circle.angle = previousCircle.angle
                circle.state = .normalConnected
                selectedCircles.append(circle)
                break
            }
        }
    }
}

extension CirclesView {
    func clean() {
        selectedCircles.removeAll()
        currentPoint = nil
        for (_, circle) in circles.enumerated() {
            circle.state = .normal
        }
        self.setNeedsDisplay()
    }

    func showError() {
        for (index, circle) in selectedCircles.enumerated() {
            if index != selectedCircles.count - 1 {
                circle.state = .warningConnected
            } else {
                circle.state = .warningTapped
            }
        }
        self.setNeedsDisplay()
        self.perform(#selector(clean), with: nil, afterDelay: 1.0)
    }
}
