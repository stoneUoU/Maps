//
//  HudTips.swift
//  Maps
//
//  Created by test on 2017/11/2.
//  Copyright © 2017年 com.youlu. All rights reserved.
//
import Foundation
import MBProgressHUD
class HudTips{
    static func showHUD(ctrl:UIViewController) {
        let hud = MBProgressHUD.showAdded(to: ctrl.view, animated: true)
        hud.mode = MBProgressHUDMode.indeterminate
    }
    static func hideHUD(ctrl:UIViewController) {
        MBProgressHUD.hideAllHUDs(for: ctrl.view, animated: true)
    }
}


