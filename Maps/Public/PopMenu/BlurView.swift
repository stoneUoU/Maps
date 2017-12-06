//
//  BlurView.swift
//  Maps
//
//  Created by test on 2017/10/16.
//  Copyright © 2017年 com.youlu. All rights reserved.
//

import UIKit

@objc protocol BlurViewProtocol: class{
    @objc optional func willShowBlurView();
    @objc optional func didShowBlurView();
    @objc optional func willDismissBlurView();
    @objc optional func didDismissBlurView();
}

class BlurView: UIView{
    enum BlurType{
        //white translucent background like UIToolbar
        case BlurTypeTranslucent;
        //black translucent background like UIToolbar
        case BlurTypeTranslucentWhite;
        //black translucent background, Default.
        case BlurTypeTranslucentBlack;
        //white background
        case BlurTypeWhite
    };
    
    var blurType:BlurType = .BlurTypeTranslucentBlack;
    var showed:Bool = false;
    var showDuration:Float = 0.3;
    var dismissDuration:Float = 0.3;
    
    var guestureEnable:Bool = false;
    
    weak var delegate:BlurViewProtocol?;
    
    //if the tap gesture is enabled.
    var hasTapGustureEnable:Bool{
        set(newValue){
            self.guestureEnable = newValue;
            self.setupTapGesture();
        }
        get{
            return self.guestureEnable;
        }
    }
    
    var backgroundView:UIView{
        get{
            switch self.blurType {
            case .BlurTypeTranslucent:
                return self.blurBackgroundView;
            case .BlurTypeTranslucentWhite:
                return self.blurWhiteBackgroundView;
            case .BlurTypeTranslucentBlack:
                return self.blackTranslucentBackgroundView;
            case .BlurTypeWhite:
                return self.whiteBackgroundView;
            }
        }
    }
    
    lazy var blurBackgroundView:UIToolbar = {
        var temp = UIToolbar(frame:self.bounds);
        temp.barStyle = .black;
        return temp;
    }();
    
    lazy var blurWhiteBackgroundView:UIToolbar = {
        var toolbar = UIToolbar(frame:self.bounds);
        toolbar.barStyle = .default;
        return toolbar;
    }();
    
    lazy var blackTranslucentBackgroundView:UIView = {
        var view = UIView(frame:self.bounds);
        view.backgroundColor = UIColor(white: 0.000, alpha: 0.500);
        return view;
    }();
    
    lazy var whiteBackgroundView:UIView = {
        var view = UIView(frame:self.bounds);
        view.backgroundColor = UIColor(white: 0.2, alpha: 1.0);
        return view;
    }();
    
    override init(frame: CGRect) {
        super.init(frame: frame);
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func showBlurViewAtView(currentView: UIView){
        self.showAnimationAtContinerView(containerView: currentView);
    }
    
    //method to dismiss the blur view.
    func dismiss(){
        self.hiddenAnimation();
    }
    
    /**
     show blur view at specified container view with animation.
     - parameter containerView: superView of the blur view
     */
    func showAnimationAtContinerView(containerView:UIView){
        if(self.showed){
            self.dismiss();
            return;
        }
        else{
            self.delegate?.willShowBlurView?();
        }
        
        self.alpha = 0.0;
        containerView.insertSubview(self, at: 0);
        
        UIView.animate(withDuration: Double(self.showDuration), delay: 0, options: .curveEaseInOut, animations: {
            self.alpha = 1.0;
        })
        { (finished) in
            self.showed = true;
            self.delegate?.didShowBlurView?();
        };
    }
    
    /**
     hide the blur view with animation.
     */
    func hiddenAnimation(){
        self.delegate?.willDismissBlurView?();
        
        UIView.animate(withDuration: Double(self.dismissDuration), delay: 0, options: .curveEaseInOut, animations: {
            self.alpha = 0.0;
        })
        { (finished) in
            self.showed = false;
            self.delegate?.didDismissBlurView?();
            self.removeFromSuperview();
        };
    }
    
    //if the super view of current blur view is changed, this method will be called.
    override func willMove(toSuperview newSuperview: UIView?) {
        if(newSuperview != nil){
            let backgroundView = self.backgroundView;
            backgroundView.isUserInteractionEnabled = false;
            self.addSubview(backgroundView);
        }
    }
    
    func setupTapGesture(){
        if(self.hasTapGustureEnable){
            let tap:UIGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTapGesture(ges:)));
            self.addGestureRecognizer(tap);
        }
    }
    
    @objc func handleTapGesture(ges:UIGestureRecognizer){
        self.dismiss();
    }
}

