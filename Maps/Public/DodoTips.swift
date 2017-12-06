//
//  DodoTips.swift
//  Maps
//
//  Created by test on 2017/10/11.
//  Copyright © 2017年 com.youlu. All rights reserved.
//

import UIKit
import Dodo
class DodoTips: NSObject {
    static  func showSuccTips(tipsView:UIView,message:String) {
        // Use a built-in icon
        tipsView.dodo.style.leftButton.icon = .close
        // Supply your image
        tipsView.dodo.style.leftButton.image = UIImage(named: "CloseIcon")
        
        // Change button's image color
        tipsView.dodo.style.leftButton.tintColor = DodoColor.fromHexString("#FFFFFF90")
        
        // Do something on tap
        tipsView.dodo.style.leftButton.onTap = { /* Button tapped */ }
        
        // Use existing animations
        tipsView.dodo.style.bar.animationShow = DodoAnimations.rotate.show
        tipsView.dodo.style.bar.animationHide = DodoAnimations.slideRight.hide
        
        // Turn off animation
        tipsView.dodo.style.bar.animationShow = DodoAnimations.noAnimation.show
        
        // Close the bar when the button is tapped
        tipsView.dodo.style.leftButton.hideOnTap = true
        
        tipsView.dodo.success(message)
    }
    
    static  func showInfoTips(tipsView:UIView,message:String) {
        // Use a built-in icon
        // Set the text color
        tipsView.dodo.style.label.color = UIColor.white
        
        // Set background color
        tipsView.dodo.style.bar.backgroundColor = DodoColor.fromHexString("#00000090")
        
        // Close the bar after 3 seconds
        tipsView.dodo.style.bar.hideAfterDelaySeconds = 8
        
        // Close the bar when it is tapped
        tipsView.dodo.style.bar.hideOnTap = true
        
        // Show the bar at the bottom of the screen
        tipsView.dodo.style.bar.locationTop = false
        
        // Do something on tap
        tipsView.dodo.style.bar.onTap = {
            print(message,"I am message")
        }
        tipsView.dodo.info(message)
    }
}
