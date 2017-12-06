//
//  PostV.swift
//  Centers
//
//  Created by test on 2017/9/29.
//  Copyright © 2017年 com.youlu. All rights reserved.
//
import UIKit
import SnapKit
protocol PostVDelegate: class {
    //关闭本View
    func toClose(postV : PostV)
}
class PostV: UIView {
    weak var postVDelegate : PostVDelegate?
    var scrollV:UIScrollView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension PostV:UITextFieldDelegate{
    func setupUI(){
        
        // 返回按钮
        let btnClose = UIButton(type: .custom)
        btnClose.setImage(UIImage(named:"btnClose.png"), for: .normal)
        btnClose.addTarget(self, action: #selector(self.smsClick(_:)), for: .touchUpInside)
        addSubview(btnClose);
        btnClose.snp_makeConstraints { (make) in
            make.top.equalTo(PublicFunc.setHeight(size: 27))
            make.left.equalTo(0)
            make.width.equalTo(ScreenInfo.width/5)
            make.height.equalTo(30)
        }
        
        //短信验证码登录
        let titleTag = UILabel()
        titleTag.text = "短信验证码登录"
        titleTag.textColor = UIColor.colorWithCustom(242,g:72,b:28)
        titleTag.font=UIFont.UiBoldFontSize(size: 18)
        titleTag.textAlignment = .center
//        //将label用户交互设为true
//        titleTag.isUserInteractionEnabled = true
//        let smsGes = UITapGestureRecognizer(target: self, action: #selector())
//        titleTag.addGestureRecognizer(smsGes)
        addSubview(titleTag);
        titleTag.snp_makeConstraints { (make) in
            make.top.equalTo(PublicFunc.setHeight(size: 20))
            make.left.equalTo(0)
            make.width.equalTo(ScreenInfo.width)
            make.height.equalTo(44)
        }
        
        scrollV = UIScrollView()
        // 添加到父视图
        addSubview(scrollV)
        scrollV.snp_makeConstraints { (make) in
            make.top.equalTo(titleTag.snp.bottom).offset(0)
            make.left.equalTo(0)
            make.width.equalTo(ScreenInfo.width)
            make.height.equalTo(ScreenInfo.height - CGFloat(44) - PublicFunc.setHeight(size: 20))
        }
        // 添加子视图label
        var originY:CGFloat = 10.0
        for number in 1...10
        {
            let label = UILabel(frame: CGRect(x:10.0, y:originY, width:ScreenInfo.width - 20, height:200.0))
            scrollV.addSubview(label)
            label.backgroundColor = UIColor(red: CGFloat(CGFloat(arc4random()) / CGFloat(RAND_MAX)), green: CGFloat(CGFloat(arc4random()) / CGFloat(RAND_MAX)), blue: CGFloat(CGFloat(arc4random()) / CGFloat(RAND_MAX)), alpha: 1.0)
            label.textColor = UIColor.red
            label.textAlignment = .center
            label.text = String(format: "scrollView add 第 %ld 个 label", arguments: [number]);
            
            originY = (label.frame.minY + label.frame.height + 10.0)
        }
        
        // 背景颜色
        scrollV.backgroundColor = UIColor(red: CGFloat(CGFloat(arc4random()) / CGFloat(RAND_MAX)), green: CGFloat(CGFloat(arc4random()) / CGFloat(RAND_MAX)), blue: CGFloat(CGFloat(arc4random()) / CGFloat(RAND_MAX)), alpha: 1.0)
        // 自适应父视图
        scrollV.autoresizingMask = UIViewAutoresizing.flexibleHeight
        // 其他属性
        scrollV.isScrollEnabled = true // 可以上下滚动
        scrollV.scrollsToTop = true // 点击状态栏时，可以滚动回顶端
        scrollV.bounces = true // 反弹效果，即在最顶端或最底端时，仍然可以滚动，且释放后有动画返回效果
        scrollV.isPagingEnabled = false // 分页显示效果
        scrollV.showsHorizontalScrollIndicator = true // 显示水平滚动条
        scrollV.showsVerticalScrollIndicator = true // 显示垂直滚动条
        scrollV.indicatorStyle = UIScrollViewIndicatorStyle.white // 滑动条的样式
        // 设置内容大小
        scrollV.contentSize = CGSize(width:ScreenInfo.width, height:originY)
    }
}
extension PostV{
    @objc func smsClick(_ :UIButton){
        postVDelegate?.toClose(postV : self)
    }
    
}

