//
//
//                        _____
//                       / ___/____  ____  ____ _
//                       \__ \/ __ \/ __ \/ __ `/
//                      ___/ / /_/ / / / / /_/ /
//                     /____/\____/_/ /_/\__, /
//                                      /____/
//
//                .-~~~~~~~~~-._       _.-~~~~~~~~~-.
//            __.'              ~.   .~              `.__
//          .'//                  \./                  \\`.
//        .'//                     |                     \\`.
//      .'// .-~"""""""~~~~-._     |     _,-~~~~"""""""~-. \\`.
//    .'//.-"                 `-.  |  .-'                 "-.\\`.
//  .'//______.============-..   \ | /   ..-============.______\\`.
//.'______________________________\|/______________________________`.
//
//
//
//  MGHelpView_Extension.swift
//  Maps
//
//  Created by test on 2017/10/11.
//  Copyright © 2017年 com.youlu. All rights reserved.
//


import UIKit

let KEY_HelpView = "MGHelpView"

extension MGHelpView{
    
    /**
     添加通用的引导页 通过view确定位置*
     
     - displayView: 需要显示的View
     - spotlightType: 聚光灯类型
     - textImageName: 说明性文字图片名字
     - textLocationType: 显示的位置  不传的话会默认显示出来适合的位置
     - versionString: 标记  和版本做关联
     - completion: 取消显示后的回调
     */
    class  func addHelpViewWithDisplayView(_ displayView:UIView,
                                           spotlightType:SpotlightType?,
                                           textImageName:String,
                                           textLocationType:TextLocationType?,
                                           versionString:String,
                                           completion: (() -> Void)?){
        let rect = displayView.convert(displayView.bounds, to: UIApplication.shared.keyWindow)
        MGHelpView.addHelpViewWithDisplayView(rect, spotlightType: spotlightType, textImageName: textImageName, textLocationType: textLocationType, versionString: versionString, completion: completion)
    }
    
    /**
     添加通用的引导页 通过坐标确定位置*
     
     - displayView: 需要显示的View
     - spotlightType: 聚光灯类型
     - textImageName: 说明性文字图片名字
     - textLocationType: 显示的位置  不传的话会默认显示出来适合的位置
     - versionString: 标记
     - completion: 取消显示后的回调
     */
    class  func addHelpViewWithDisplayView(_ displayViewRect:CGRect,
                                           spotlightType:SpotlightType?,
                                           textImageName:String,
                                           textLocationType:TextLocationType?,
                                           versionString:String,
                                           completion: (() -> Void)?){
        if isShouldDisplayWithVersion(versionString) {
            let helpView = MGHelpView()
            if spotlightType != nil {
                helpView.spotlightType = spotlightType!
            }
            helpView.addMaskWithViewRect(displayViewRect)
            if let image = UIImage(named: textImageName) {
                helpView.textImageView.image = image
                helpView.textImageView.frame = helpView.rectForTextImage(displayViewRect, textLocationType: textLocationType)
            }
            helpView.selectCompletionBlock = completion
            setDisplayForVersion(versionString)
        }
    }
    
    //判断是否需要显示引导
    class  func isShouldDisplayWithVersion(_ version:String) -> Bool {
        let string = version.components(separatedBy: "_").first
        if let infoDictionary = Bundle.main.infoDictionary,
            let version = infoDictionary["CFBundleShortVersionString"] as? String
        {
            if !version.hasPrefix(string!) {
                return false;
            }
        }
        
        let key = KEY_HelpView + version
        return !UserDefaults.standard.bool(forKey: key)
    }
    
    //设置已经显示过引导
    class  func setDisplayForVersion(_ version:String) {
        let key = KEY_HelpView + version
        UserDefaults.standard.set(true, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    /**
     添加心愿中推荐房源的引导页 特殊处理的是聚光灯的大小*
     - displayView: 需要显示的View
     - completion: 取消显示后的回调
     */
    class  func addRecommendHelpViewWithDisplayView(_ displayView:UIView,completion: (() -> Void)?){
        let version = "3.0_Recomment"
        if isShouldDisplayWithVersion(version) {
            let helpView = MGHelpView()
            helpView.spotlightType = .spotlightTypeEllipse
            let rect = displayView.convert(displayView.bounds, to: helpView.superview)
            helpView.addMaskWithViewRect(CGRect(x: rect.minX, y: rect.minY - 2, width: rect.size.width, height: rect.size.height))
            let image = UIImage(named: "helpWish")
            helpView.textImageView.image = image
            helpView.textImageView.frame = CGRect(x: rect.minX - image!.size.width, y: rect.minY - 2 - image!.size.height, width: image!.size.width, height: image!.size.height)
            helpView.selectCompletionBlock = completion
            setDisplayForVersion(version)
        }
    }
    
}
