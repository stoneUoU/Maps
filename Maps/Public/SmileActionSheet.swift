//
//  SmileActionSheet.swift
//  Maps
//
//  Created by test on 2018/1/11.
//  Copyright © 2018年 com.youlu. All rights reserved.
//

import UIKit
import Spring
class SmileActionSheet: UIView {

    let backGroundView = SpringView() //背景视图
    let tap = UITapGestureRecognizer() //手势

    //init 调用方法
    init(title: String?, cancelButtonTitle: String?, buttonTitles: [String]?) {
        super.init(frame: CGRect(x: 0, y: 0, width: ScreenW, height: ScreenH))
        if buttonTitles == nil || buttonTitles?.count == 0 {
            return
        }

        // 自定义一个actionsheet
        self.frame = CGRect(x: 0, y: 0, width: ScreenW, height: ScreenH)
        self.backgroundColor = UIColor.init(white: 0.0, alpha: 0.2)
        // 添加手势
        tap.addTarget(self, action: #selector(self.removeWindowsView(_:)))
        self.addGestureRecognizer(tap)

        backGroundView.frame = CGRect(x: ScreenW, y: 0, width: ScreenW , height: ScreenH)
        backGroundView.backgroundColor = UIColor.white
        backGroundView.layer.shadowColor = UIColor.lightGray.cgColor
        backGroundView.layer.borderColor = UIColor.groupTableViewBackground.cgColor

        self.addSubview(backGroundView)

        let UiV = UIView()
        UiV.backgroundColor = .cyan
        backGroundView.addSubview(UiV)
        UiV.snp.makeConstraints{
            (make) in
            make.width.equalTo(ScreenW/2)
            make.height.equalTo(sortH)
            make.top.equalTo(StatusBarAndNavigationBarH)
            make.left.equalTo(backGroundView)
        }


    }

    func removeWindowsView(_ thetap:UITapGestureRecognizer) {
        dismiss()
    }


    func show() {
        UIApplication.shared.windows[0].addSubview(self)
        SpringAnimation.spring(duration: 0.5, animations: {
            self.backGroundView.frame = CGRect(x: ScreenW -  self.backGroundView.frame.size.width+72, y:0, width: self.backGroundView.frame.size.width , height: ScreenH)
        })
    }
    func dismiss() {
        UIView.animateKeyframes(withDuration: 0.5, delay: 0.0, options: UIViewKeyframeAnimationOptions(), animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1/2.0, animations: {
                self.backGroundView.frame = CGRect(x: ScreenW, y: self.backGroundView.frame.origin.y, width: self.backGroundView.frame.size.width, height: self.backGroundView.frame.size.height)
            })
            UIView.addKeyframe(withRelativeStartTime: 1/2.0, relativeDuration: 1/2.0, animations: {
                self.backgroundColor = UIColor(white: 0, alpha: 0)
            })
        }) { (finished) in
            self.backGroundView.removeFromSuperview()
            self.removeFromSuperview()
            self.removeGestureRecognizer(self.tap)
            self.removeFromSuperview()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

