//
//  MGHelpView.swift
//  Maps
//  聚光灯提示View
//  Created by test on 2017/10/11.
//  Copyright © 2017年 com.youlu. All rights reserved.
//

import UIKit

public enum SpotlightType {
    case spotlightTypeRect //长方形
    case spotlightTypeEllipse //椭圆形
}

public enum TextLocationType {
    case left //聚光灯左边
    case right //聚光灯右边
    case top //聚光灯上边
    case bottom//聚光灯下边
    case topLeft //聚光灯左上角
    case topRight //聚光灯右上角
    case bottomLeft //聚光灯左下角
    case bottomRight //聚光灯右下角
}

open class MGHelpView: UIView {
    
    /*! 聚光灯样式 */
    public var spotlightType:SpotlightType = .spotlightTypeEllipse
    
    /*! 黑色半透明背景 */
    public var shapeLayer:CAShapeLayer!
    /*! 显示的提示文字 */
    public var textImageView:UIImageView!
    
    let ScreenW = UIScreen.main.bounds.width
    let ScreenH = UIScreen.main.bounds.height
    
    /*! 聚光灯View */
    public var displayView:UIView?{
        didSet{
            let rect = displayView?.convert((displayView?.bounds)!, to: self.superview)
            addMaskWithViewRect(rect!)
        }
    }
    
    /*! 点击图片的回调 */
    public var selectCompletionBlock:(() ->())!
    
    
    public init()
    {
        super.init(frame: CGRect.zero)
        if let view = UIApplication.shared.keyWindow {
            self.frame = view.bounds
            view.addSubview(self)
        }
        isUserInteractionEnabled = true
        shapeLayer = CAShapeLayer();
        shapeLayer.fillColor = UIColor.black.cgColor;
        shapeLayer.fillRule = kCAFillRuleEvenOdd;
        shapeLayer.frame = self.bounds;
        shapeLayer.opacity = 0.6;
        layer.addSublayer(shapeLayer)
        textImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 10, height: 10));
        addSubview(textImageView)
        alpha = 0
        UIView.animate(withDuration: 0.5, animations: {
            self.alpha = 1
        })
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*! 添加聚光灯啦 */
    public func addMaskWithViewRect(_ rect:CGRect){
        self.shapeLayer.path = nil;
        let maskPath = CGMutablePath()
        let transform = CGAffineTransform.identity
        
        maskPath.addRect(bounds, transform: transform)
        switch spotlightType {
        case .spotlightTypeRect:
            //            maskPath.addRect(rect, transform: transform)
            maskPath.addRoundedRect(in: rect, cornerWidth: 3, cornerHeight: 3,transform:transform)//圆角
            break
        case .spotlightTypeEllipse:
            maskPath.addEllipse(in: rect, transform: transform)
            break
        }
        self.shapeLayer.path = maskPath;
    }
    
    
    /*! 获得文字提示显示的位置 */
    public func rectForTextImage(_ rect:CGRect, textLocationType:TextLocationType?) -> CGRect{
        var type = textLocationType
        var imageRect = CGRect.zero
        let image = self.textImageView.image!
        imageRect.size = CGSize(width: image.size.width, height: image.size.height)
        if type == nil
        {
            
            if rect.midX <= ScreenW/3
            {
                if rect.midY <= ScreenH/3
                {
                    type = .bottomRight
                }
                else if rect.midY >= ScreenH/3*2
                {
                    type = .topLeft
                }
                else
                {
                    type = .right
                }
            }
            else if rect.midX >= ScreenW/3*2
            {
                if rect.midY <= ScreenH/3
                {
                    type = .bottomLeft
                }
                else if rect.midY >= ScreenH/3*2
                {
                    type = .topLeft
                }
                else
                {
                    type = .left
                }
            }
            else
            {
                if rect.midY <= ScreenH/3
                {
                    type = .bottom
                }
                else if rect.midY >= ScreenH/3*2
                {
                    type = .top
                }
                else
                {
                    type = .bottomRight
                }
            }
        }
        switch type! {
        case .left:
            imageRect.origin = CGPoint(x: rect.minX - imageRect.size.width, y: rect.midY - imageRect.size.height/2)
            break
        case .right:
            imageRect.origin = CGPoint(x: rect.maxX, y: rect.midY - imageRect.size.height/2)
            break
        case .top:
            imageRect.origin = CGPoint(x: rect.midX - imageRect.size.width/2, y: rect.minY - imageRect.size.height)
            break
        case .bottom:
            imageRect.origin = CGPoint(x: rect.midX - imageRect.size.width/2, y: rect.maxY)
            break
        case .topLeft:
            imageRect.origin = CGPoint(x: rect.minX - imageRect.size.width, y: rect.minY - imageRect.size.height)
            break
        case .topRight:
            imageRect.origin = CGPoint(x: rect.maxX, y: rect.minY - imageRect.size.height)
            break
        case .bottomLeft:
            imageRect.origin = CGPoint(x: rect.minX - imageRect.size.width, y: rect.maxY)
            break
        case .bottomRight:
            imageRect.origin = CGPoint(x: rect.maxX, y: rect.maxY)
            break
        }
        return imageRect
    }
    
    /*! 点击取消显示 */
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.5, animations: {
            self.alpha = 0
        }, completion: { (finished) in
            self.removeFromSuperview()
            if (self.selectCompletionBlock != nil){
                self.selectCompletionBlock()
            }
        })
    }
}

extension MGHelpView{
    
    /**
     添加通用的引导页 通过view确定位置*
     
     - displayView: 需要显示的View
     - spotlightType: 聚光灯类型
     - textImageName: 说明性文字图片名字
     - textLocationType: 显示的位置  不传的话会默认显示出来适合的位置
     - tagString: 标记
     - completion: 取消显示后的回调
     */
    public class  func addHelpViewWithDisplayView(_ displayView:UIView,
                                                  spotlightType:SpotlightType?,
                                                  textImageName:String,
                                                  textLocationType:TextLocationType?,
                                                  tagString:String,
                                                  completion: (() -> Void)?){
        let rect = displayView.convert(displayView.bounds, to: UIApplication.shared.keyWindow)
        addHelpViewWithDisplayView(rect, spotlightType: spotlightType, textImageName: textImageName, textLocationType: textLocationType, tagString: tagString, completion: completion)
    }
    
    /**
     添加通用的引导页 通过坐标确定位置*
     
     - displayView: 需要显示的View
     - spotlightType: 聚光灯类型
     - textImageName: 说明性文字图片名字
     - textLocationType: 显示的位置  不传的话会默认显示出来适合的位置
     - tagString: 标记
     - completion: 取消显示后的回调
     */
    public class  func addHelpViewWithDisplayView(_ displayViewRect:CGRect,
                                                  spotlightType:SpotlightType?,
                                                  textImageName:String,
                                                  textLocationType:TextLocationType?,
                                                  tagString:String,
                                                  completion: (() -> Void)?){
        if !UserDefaults.standard.bool(forKey: tagString) {
            let helpView = MGHelpView()
            if spotlightType != nil {
                helpView.spotlightType = spotlightType!
            }
            let rect = displayViewRect
            helpView.addMaskWithViewRect(rect)
            if let image = UIImage(named: textImageName) {
                helpView.textImageView.image = image
                helpView.textImageView.frame = helpView.rectForTextImage(rect, textLocationType: textLocationType)
            }
            helpView.selectCompletionBlock = completion
            UserDefaults.standard.set(true, forKey: tagString)
        }
    }
}
