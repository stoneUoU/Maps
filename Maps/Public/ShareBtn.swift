//
//  ShareBtn.swift
//  Maps
//
//  Created by test on 2017/10/11.
//  Copyright © 2017年 com.youlu. All rights reserved.
//

import UIKit

class ShareBtn: UIButton {
    var iconImageView : UIImageView!
    var nameLabel     : UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        iconImageView = UIImageView.init(frame: CGRect(x:0, y:10, width:80, height:80))
        iconImageView.layer.cornerRadius = 5
        self.addSubview(iconImageView)
        
        nameLabel = UILabel.init(frame: CGRect(x:0, y:55, width:60, height:20))
        nameLabel.textAlignment = NSTextAlignment.center
        self.addSubview(nameLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}

protocol YSJShareViewDelegate {
    func shareBtnClick(index:Int)
}


class YSJShareView: UIView {
    
    var shareViewHeight     :CGFloat!
    var _shareView          :UIView!
    var _sepWidth           :CGFloat!
    var _count              :Int = 0
    var _shareViewBackground :UIView!
    var _window             :UIWindow!
    
    var _delegate            :YSJShareViewDelegate!
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        _shareView = UIView.init(frame: CGRect(x:0, y:0, width:UIScreen.main.bounds.width, height:180))
        self.addSubview(_shareView)
        
        let shareBtn = UIButton.init(type: UIButtonType.custom)
        shareBtn.setTitle("分享至", for: UIControlState.normal)
        shareBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        shareBtn.setTitleColor(UIColor.black, for: .normal) //普通状态下文字的颜色
        shareBtn.frame = CGRect(x:0, y:0, width:UIScreen.main.bounds.width, height:40)
        shareBtn.addTarget(self, action: #selector(YSJShareView.hidden), for: UIControlEvents.touchUpInside)
        self.addSubview(shareBtn)
        
        let lineV = UIView()
        lineV.backgroundColor = UIColor.colorWithCustom(0,g:0,b:0,alpha: 0.05)
        lineV.frame = CGRect(x:0, y:40, width:UIScreen.main.bounds.width, height:1)
        self.addSubview(lineV)
        
        _shareViewBackground = UIView.init(frame: UIScreen.main.bounds)
        _shareViewBackground.backgroundColor = UIColor.clear
        _shareViewBackground.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(YSJShareView.dismiss)))
        
        let sparateV = UIView()
        sparateV.backgroundColor = UIColor.colorWithCustom(0,g:0,b:0,alpha: 0.05)
        sparateV.frame = CGRect(x:0, y:180 - 41, width:UIScreen.main.bounds.width, height:1)
        self.addSubview(sparateV)
        
        let cancenlBtn = UIButton.init(type: UIButtonType.custom)
        cancenlBtn.setTitle("取消分享", for: UIControlState.normal)
        cancenlBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        cancenlBtn.setTitleColor(UIColor.black, for: .normal) //普通状态下文字的颜色
        cancenlBtn.frame = CGRect(x:0, y:180 - 40, width:UIScreen.main.bounds.width, height:40)
        cancenlBtn.addTarget(self, action: #selector(YSJShareView.hidden), for: UIControlEvents.touchUpInside)
        self.addSubview(cancenlBtn)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addItem(title:String ,withImage:UIImage){
        print(title)
        _count += 1
        _sepWidth = 10 + ((UIScreen.main.bounds.width - 280)/3 + 60)*(CGFloat(_count - 1))
        let shareBtn = ShareBtn.init(type: UIButtonType.custom)
        shareBtn.frame = CGRect(x:0 + _sepWidth, y:40, width:60, height:80)
        shareBtn.nameLabel.text = title
        shareBtn.iconImageView.image = withImage
        shareBtn.addTarget(self, action: #selector(YSJShareView.share(btn:)), for: UIControlEvents.touchUpInside)
        shareBtn.tag = 1000+_count
        if _count > 4{
            _sepWidth = 10 + ((UIScreen.main.bounds.width - 280)/3 + 60)*(CGFloat(_count - 5))
            shareBtn.frame = CGRect(x:0 + _sepWidth, y:90, width:60, height:80)
        }
        
        _shareView.addSubview(shareBtn)
        
        
    }
    
    func show() {
        _window = UIWindow.init(frame: UIScreen.main.bounds)
        _window.windowLevel = UIWindowLevelAlert+1
        _window.backgroundColor = UIColor.clear
        _window.isHidden = true
        _window.isUserInteractionEnabled = true
        _window.addSubview(_shareViewBackground)
        _window.addSubview(self)
        
        _window.isHidden = false
        UIView.animate(withDuration: 0.2, animations: {
            self._shareViewBackground.backgroundColor = UIColor.init(white: 0.0, alpha: 0.2)
            self.frame = CGRect(x:0, y:UIScreen.main.bounds.size.height - 180, width:UIScreen.main.bounds.width, height:180)
        })
        
    }
    
    
    @objc func hidden() {
        UIView.animate(withDuration: 0.2, animations: {
            self._shareViewBackground.backgroundColor = UIColor.init(white: 0.0, alpha: 0.0)
            self.frame = CGRect(x:0, y:UIScreen.main.bounds.size.height , width:UIScreen.main.bounds.width, height:180)
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
    
    
    
}
