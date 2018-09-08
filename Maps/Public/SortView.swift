//
//  SortView.swift
//  Maps
//
//  Created by test on 2018/1/11.
//  Copyright © 2018年 com.youlu. All rights reserved.
//
import UIKit

class SortView: UIButton {
    var nameLabel     : UILabel!
    override init(frame: CGRect) {
        super.init(frame: frame)
        nameLabel = UILabel.init(frame: CGRect(x:0, y:0, width:ScreenW, height:39))
        nameLabel.backgroundColor = .white
        nameLabel.textAlignment = NSTextAlignment.center
        self.addSubview(nameLabel)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
protocol STSortViewDelegate {
    func shareBtnClick(index:Int)
    //func closeView()
}
class STSortView: UIView {
    var frameH : CGFloat!
    var shareViewHeight     :CGFloat!
    var _shareView          :UIView!
    var _sepWidth           :CGFloat!
    var _count              :Int = 0
    var _shareViewBackground :UIView!
    var _window             :UIWindow!
    var _delegate            :STSortViewDelegate!
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.frameH = frame.height
        _shareView = UIView.init(frame: CGRect(x:0, y:0, width:UIScreen.main.bounds.width, height:self.frameH))
        self.addSubview(_shareView)

        _shareViewBackground = UIView.init(frame: CGRect(x:0, y:0, width:UIScreen.main.bounds.width, height:StatusBarAndNavigationBarH + CGFloat(sortH)))
        _shareViewBackground.backgroundColor = UIColor.clear
        _shareViewBackground.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(YSJShareView.dismiss)))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addItem(title:String){
        _count += 1
        _sepWidth = (40)*(CGFloat(_count - 1))
        let shareBtn = SortView.init(type: UIButtonType.custom)
        shareBtn.frame = CGRect(x:0, y:0 + _sepWidth, width:UIScreen.main.bounds.width, height:40)
        shareBtn.nameLabel.text = title
        shareBtn.addTarget(self, action: #selector(YSJShareView.share(btn:)), for: UIControlEvents.touchUpInside)
        shareBtn.tag = 1000+_count
        _shareView.addSubview(shareBtn)
    }
    func show() {
        _window = UIWindow.init(frame: UIScreen.main.bounds)
        _window.windowLevel = UIWindowLevelAlert+1
        _window.backgroundColor = UIColor.clear
        _window.isHidden = true
        _window.isUserInteractionEnabled = true
        _window.addSubview(_shareViewBackground)
        _window.isUserInteractionEnabled = true
        let subGes = UITapGestureRecognizer(target: self, action: #selector(self.subJump(_:)))
        _window.addGestureRecognizer(subGes)
        _window.addSubview(self)

        _window.isHidden = false
        UIView.animate(withDuration: 0.2, animations: {
            self._shareViewBackground.backgroundColor = UIColor.init(white: 0.0, alpha: 0.2)
            self.frame = CGRect(x:0, y:StatusBarAndNavigationBarH + CGFloat(sortH), width:UIScreen.main.bounds.width, height:self.frameH)
        })

    }
    func hidden() {
        UIView.animate(withDuration: 0.2, animations: {
            self._shareViewBackground.backgroundColor = UIColor.init(white: 0.0, alpha: 0.0)
            self.frame = CGRect(x:0, y:-self.frameH , width:UIScreen.main.bounds.width, height:self.frameH)
        }) { (finished) in
            self._window = nil
        }

    }
    @objc func dismiss() {
        hidden()
    }
    @objc func share(btn:UIButton) {
        _delegate.shareBtnClick(index: btn.tag - 1001)
        hidden()
    }
    @objc func subJump(_ tapGes :UITapGestureRecognizer){
        //shareView.show()
        hidden()
    }
}
