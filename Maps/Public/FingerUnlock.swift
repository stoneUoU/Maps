//
//  FingerUnlock.swift
//  Maps
//
//  Created by test on 2017/11/14.
//  Copyright © 2017年 com.youlu. All rights reserved.
//
import LocalAuthentication
class TouchIdManager {
    /// 指纹解锁
    ///
    /// - Parameters:
    ///  - fallBackTitle: Allows fallback button title customization. A default title "Enter Password" is used when
    ///       this property is left nil. If set to empty string, the button will be hidden
    ///  - succeed: 解锁成功的回调
    ///  - failed: 解锁失败的回调
    class func touchIdWithHand(fallBackTitle: String?, succeed: @escaping () -> (), failed: @escaping (_ error: LAError) -> ()) {
        guard self.IsSupportTouchID else {
            print("设备不支持TouchID 或未开启TouchID ")
            return
        }
        let context = LAContext()
        context.localizedFallbackTitle = fallBackTitle
        let reason = "验证指纹，打开应用"
        context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason, reply: { (isSuccess, err) in
            OperationQueue.main.addOperation({
                guard isSuccess == true, err == nil else {
                        let laerror = err as! LAError
                        failed(laerror)
                      switch laerror.code {
                      case LAError.authenticationFailed:
                        print("连续三次输入错误，身份验证失败。")
                      case LAError.userCancel:
                        print("用户点击取消按钮。")
                      case LAError.userFallback:
                        print("用户点击输入密码。")
                      case LAError.systemCancel:
                        print("系统取消")
                      case LAError.passcodeNotSet:
                        print("用户未设置密码")
                      case LAError.touchIDNotAvailable:
                        print("touchID不可用")
                      case LAError.touchIDNotEnrolled:
                        print("touchID未设置指纹")
                      default: break
                      }

                    return
                }
                succeed()
            })
        })
    }
    /// 检查手机 TouchID 功能是否开启或可以使用
    class var IsSupportTouchID: Bool {
        get {
            let context = LAContext()
            var error :NSError?
            let isSupport = context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &error)
            return isSupport
        }
    }
}
