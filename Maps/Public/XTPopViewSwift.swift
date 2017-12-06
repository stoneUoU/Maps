//
//  XTPopViewSwift.swift
//  Maps
//
//  Created by test on 2017/10/19.
//  Copyright © 2017年 com.youlu. All rights reserved.
//
//带有箭头的弹窗：
import UIKit
import SnapKit
//protocol XtpopDelegate: class {
//    //去订单列表
//    func toClose(xTPopViewSwift : XTPopViewSwift)
//}

enum ArrowOfDirection {
    case XTUpCenter
}
class XTPopViewSwift: UIView {
    var bgView = UIView()
    var closeIcon = UIImageView()
    var tips = UILabel()
    var originV = CGPoint()
    var XTPopHeight = 0.0
    var XTPopWidth = 0.0
    var arrow = ArrowOfDirection.XTUpCenter
    // 初始化方法
    required init(originV: CGPoint, XTPopWidth: Double, XTPopHeight: Double) {
        super.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.height))
        self.backgroundColor = UIColor.clear
        self.originV = originV
        self.XTPopWidth = Double(XTPopWidth)
        self.XTPopHeight = Double(XTPopHeight)
        let x = Double(originV.x)
        let y = Double(originV.y)
        bgView = UIView.init(frame: CGRect.init(x: x, y: y, width: XTPopWidth, height: XTPopHeight))
        self.addSubview(self.bgView)
        tips = UILabel.init() // placeholderLabel是全局属性
        tips.font = UIFont.systemFont(ofSize: 13)
        tips.text = "“呱呱豆”是呱呱购APP发行的一种虚拟货币，仅限在APP内使用。每天完成一笔订单就消耗一颗呱呱豆。"
        tips.numberOfLines = 4
        tips.lineBreakMode = NSLineBreakMode.byTruncatingTail
        tips.textColor = UIColor.white
        self.bgView.addSubview(tips)
        //此段代码只负责调节页面的UI
        switch UIScreen.main.bounds.height {
        case 0 ... 667:
            tips.snp_makeConstraints { (make) in
                make.left.equalTo(self.bgView.snp.left).offset(13.5)
                make.right.equalTo(self.bgView.snp.right).offset(-13.5)
                make.height.equalTo(PublicFunc.setHeight(size: 72))
                make.top.equalTo(self.bgView.snp.top).offset(PublicFunc.setHeight(size: 8.5))
            }
        default:
            tips.snp_makeConstraints { (make) in
                make.left.equalTo(self.bgView.snp.left).offset(13.5)
                make.right.equalTo(self.bgView.snp.right).offset(-13.5)
                make.height.equalTo(PublicFunc.setHeight(size: 48))
                make.top.equalTo(self.bgView.snp.top).offset(PublicFunc.setHeight(size: 8.5))
            }
        }
        closeIcon = UIImageView.init()
        closeIcon.image = UIImage(named: "icon_guaguadou_help_guanbi.png")
        closeIcon.isUserInteractionEnabled = true
        let infoGes = UITapGestureRecognizer(target: self, action: #selector(self.Close(_:)))
        closeIcon.addGestureRecognizer(infoGes)
        self.bgView.addSubview(closeIcon)
        //此段代码只负责调节页面的UI
        switch UIScreen.main.bounds.height {
        case 0 ... 667:
            closeIcon.snp_makeConstraints { (make) in
                make.top.equalTo(self.tips.snp.top).offset(PublicFunc.setHeight(size: 8))
                make.right.equalTo(self.bgView.snp.right).offset(-8)
            }
        default:
            closeIcon.snp_makeConstraints { (make) in
                make.top.equalTo(self.tips.snp.top).offset(PublicFunc.setHeight(size: 9))
                make.right.equalTo(self.bgView.snp.right).offset(-8)
            }
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        
        let startX = self.originV.x
        let startY = self.originV.y
        
        context?.move(to: CGPoint.init(x: startX + PublicFunc.setHeight(size:15), y: startY))
        // 画出两条线
        context?.addLine(to: CGPoint.init(x: startX + PublicFunc.setHeight(size:15) + 5.0, y: startY + 5.0))
        context?.addLine(to: CGPoint.init(x: startX + PublicFunc.setHeight(size:15) - 5.0, y: startY + 5.0))
        
        context?.closePath()
        // 填充颜色
        self.bgView.backgroundColor?.setFill()
        self.backgroundColor?.setStroke()
        context?.drawPath(using: CGPathDrawingMode.fillStroke)
    }
    
    func popView()->Void{
        // 创建keyWindow
        let window = UIApplication.shared.keyWindow
        window?.addSubview(self)
        self.bgView.frame = CGRect.init(x: self.originV.x, y: self.originV.y + 5.0, width: 0, height: 0)
        // 类型CGFloat -> Double
        let originVX = Double(self.originV.x) - self.XTPopWidth / 2
        let originVY = Double(self.originV.y) + 5.0
        let XTPopWidth = self.XTPopWidth
        let XTPopHeight = self.XTPopHeight
        // 这里为什么抽出一个方法呢, 如果有很多类型箭头就方便很多, 可以看看OC版本
        self.updateFrame(x: originVX - Double(PublicFunc.setHeight(size: 30)), y: originVY, width: XTPopWidth, height: XTPopHeight)
        
    }
    
    func updateFrame(x: Double, y: Double, width: Double, height: Double){
        self.bgView.frame = CGRect.init(x: x, y: y, width: XTPopWidth, height: XTPopHeight)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 这里遍历包含UITouch的集合, 从中找到黑色View
        for touch: AnyObject in touches {
            let t:UITouch = touch as! UITouch
            if(!(t.view?.isEqual(self.bgView))!){
                self.dismiss()
            }
        }
    }
    
    func dismiss()->Void{
        let delay = DispatchTime.now() + DispatchTimeInterval.seconds(0)
        DispatchQueue.main.asyncAfter(deadline: delay) {
            // 延迟执行
            let res = self.subviews
            for view in res {
                view.removeFromSuperview()
            }
            self.removeFromSuperview()
        }
    }
    @objc func Close(_ tapGes :UITapGestureRecognizer){
        self.dismiss()
        //mineViewDelegate?.toInfos(mineView : self)
    }}

