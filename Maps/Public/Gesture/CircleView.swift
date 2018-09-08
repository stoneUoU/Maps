//
//  CircleView.swift
//  Authentication
//
//  Created by Sim Jin on 2016/12/25.
//  Copyright © 2016年 UFunNetwork. All rights reserved.
//

import Foundation
import UIKit

enum CircleState {
    case normal
    case normalTapped
    case normalConnected
    case warningTapped
    case warningConnected
    case selected // Only use for info
}

enum CircleType {
    case patternLock
    case info
}

class Circle: UIView {
    private var outerCircleLineWidth: CGFloat = 0.5
    private let innerCircleRadius: CGFloat = 10

    var outerCircleColor = Color.normalColor
    var innerCircleColor = UIColor.clear
    var triangleColor = UIColor.clear
    var type: CircleType = .patternLock // Should set before state
    var state: CircleState = .normal {
        willSet {
            if newValue == .normal {
                outerCircleLineWidth = type == .info ? 1.0 : 0.5
                outerCircleColor = type == .info ? Color.grayColor : Color.normalColor
                innerCircleColor = UIColor.clear
                triangleColor = UIColor.clear
            } else if newValue == .normalConnected {
                outerCircleLineWidth = 1.0
                outerCircleColor = Color.normalColor
                innerCircleColor = Color.normalColor
                triangleColor = Color.normalColor
            } else if newValue == .normalTapped {
                outerCircleLineWidth = 1.0
                outerCircleColor = Color.normalColor
                innerCircleColor = Color.normalColor
                triangleColor = UIColor.clear
            } else if newValue == .warningConnected {
                outerCircleLineWidth = 1.0
                outerCircleColor = Color.destructiveColor
                innerCircleColor = Color.destructiveColor
                triangleColor = Color.destructiveColor
            } else if newValue == .warningTapped {
                outerCircleLineWidth = 1.0
                outerCircleColor = Color.destructiveColor
                innerCircleColor = Color.destructiveColor
                triangleColor = UIColor.clear
            } else if newValue == .selected {
                if type == .info {
                    outerCircleLineWidth = 0
                    outerCircleColor = UIColor.clear
                    innerCircleColor = Color.normalColor
                }
            }
            setNeedsDisplay()
        }
    }
    var angle: CGFloat = 0 {
        didSet {
            setNeedsDisplay()
        }
    }


    init() {
        super.init(frame: CGRect.zero)
        backgroundColor = UIColor.clear
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }

        rotate(rect, with: context)
        drawOuterCircle(rect, with: context)
        drawInnerCircle(rect, with: context)
        if type == .patternLock {
            drawTriangle(rect, with: context)
        }
    }

    private func rotate(_ rect: CGRect, with context: CGContext) {
        let newCenter = rect.size.width / 2
        context.translateBy(x: newCenter, y: newCenter)
        context.rotate(by: angle)
        context.translateBy(x: -newCenter, y: -newCenter)
    }

    private func drawOuterCircle(_ rect: CGRect, with context: CGContext) {
        let outerCircleFrame = CGRect(x: outerCircleLineWidth, y: outerCircleLineWidth, width: rect.size.width - outerCircleLineWidth * 2, height: rect.size.height - outerCircleLineWidth * 2)
        context.setStrokeColor(outerCircleColor.cgColor)
        context.setLineWidth(outerCircleLineWidth)
        context.addEllipse(in: outerCircleFrame)
        context.strokePath()
    }

    private func drawInnerCircle(_ rect: CGRect, with context: CGContext) {
        let innerCircleFrame = type == .info ? rect : CGRect(x: rect.size.width / 2 - innerCircleRadius, y: rect.size.height / 2 - innerCircleRadius, width: innerCircleRadius * 2, height: innerCircleRadius * 2)
        context.setFillColor(innerCircleColor.cgColor)
        context.fillEllipse(in: innerCircleFrame)
    }

    private func drawTriangle(_ rect: CGRect, with context: CGContext) {
        context.move(to: CGPoint(x: rect.size.width / 2, y: 12))
        context.addLine(to: CGPoint(x: rect.size.width / 2 - 4, y: 18))
        context.addLine(to: CGPoint(x: rect.size.width / 2 + 4, y: 18))
        context.setFillColor(triangleColor.cgColor)
        context.fillPath()
    }
}

