//
//  PopupVC.swift
//  Maps
//
//  Created by test on 2017/10/10.
//  Copyright © 2017年 com.youlu. All rights reserved.
//
import UIKit
import MIBlurPopup

class PopupVC: UIViewController {
    
    // MARK: - IBOutlets
    
    weak var dismissButton: UIButton! {
        didSet {
            dismissButton.layer.cornerRadius = dismissButton.frame.height/2
        }
    }
    
    weak var popupContentContainerView: UIView!
    weak var popupMainView: UIView! {
        didSet {
            popupMainView.layer.cornerRadius = 10
        }
    }
    
    var customBlurEffectStyle: UIBlurEffectStyle!
    var customInitialScaleAmmount: CGFloat!
    var customAnimationDuration: TimeInterval!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return customBlurEffectStyle == .dark ? .lightContent : .default
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target:self, action:#selector(PopupVC.handleTap(sender:))))
    }
    // MARK: - IBActions
    
    @objc func dismissButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
}

// MARK: - MIBlurPopupDelegate

extension PopupVC: MIBlurPopupDelegate {
    func setupUI(){
        popupContentContainerView = UIView()
        popupContentContainerView.backgroundColor = UIColor.white
        popupContentContainerView.layer.cornerRadius = PublicFunc.setHeight(size: 47.5)
        //实现效果
        popupContentContainerView.clipsToBounds = true
        self.view.addSubview(popupContentContainerView)
        popupContentContainerView.snp_makeConstraints { (make) in
            //make.centerY.equalTo(topPic)
            make.top.equalTo(PublicFunc.setHeight(size: 120))
            make.left.equalTo(ScreenInfo.width/6)
            make.width.equalTo(PublicFunc.setHeight(size: ScreenInfo.width*2/3))
            make.height.equalTo(PublicFunc.setHeight(size: ScreenInfo.height*2/3))
        }
        
        popupMainView = UIView()
        popupMainView.backgroundColor = UIColor.white
        popupMainView.layer.cornerRadius = PublicFunc.setHeight(size: 47.5)
        //实现效果
        popupMainView.clipsToBounds = true
        self.view.addSubview(popupMainView)
        popupMainView.snp_makeConstraints { (make) in
            //make.centerY.equalTo(topPic)
            make.top.equalTo(0)
            make.left.equalTo(ScreenInfo.width/6)
            make.width.equalTo(PublicFunc.setHeight(size: ScreenInfo.width*2/3))
            make.height.equalTo(PublicFunc.setHeight(size: ScreenInfo.height*2/3)-PublicFunc.setHeight(size: 120))
        }
        
        //关闭
        dismissButton =  UIButton()
        dismissButton.setTitle("关闭", for:.normal)
        dismissButton.backgroundColor = UIColor.colorWithCustom(0, g: 111, b: 255,alpha: 1)
        dismissButton.addTarget(self, action:#selector(dismissButtonTapped(_:)),for: .touchUpInside)
        dismissButton.setTitleColor(UIColor.colorWithCustom(242, g: 71, b: 30,alpha: 1), for: .normal) //普通状态下文字的颜色
        dismissButton.isUserInteractionEnabled = true
        dismissButton.layer.cornerRadius = 20
        dismissButton.layer.masksToBounds = true
        self.view.addSubview(dismissButton)
        dismissButton.snp_makeConstraints { (make) in
            make.bottom.equalTo(popupContentContainerView.snp.bottom).offset(-PublicFunc.setHeight(size: 36))
            make.centerX.equalTo(popupContentContainerView)
            make.width.equalTo(ScreenInfo.width/2)
            make.height.equalTo(PublicFunc.setHeight(size: 40))
        }
    }
    var popupView: UIView {
        return popupContentContainerView ?? UIView()
    }
    var blurEffectStyle: UIBlurEffectStyle {
        return customBlurEffectStyle
    }
    var initialScaleAmmount: CGFloat {
        return customInitialScaleAmmount
    }
    var animationDuration: TimeInterval {
        return customAnimationDuration
    }
    
    
    //对应方法
    @objc func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            dismiss(animated: true)
        }
        sender.cancelsTouchesInView = false
    }
    
}
