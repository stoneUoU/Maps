//
//  StaticVar.swift
//  Centers
//
//  Created by test on 2017/9/29.
//  Copyright © 2017年 com.youlu. All rights reserved.
//

import UIKit
import KeychainSwift
import Moya
import RxSwift
//判断是真机还是模拟器的方法
struct Platform {
    static let isSimulator: Bool = {
        var isSim = false
        #if arch(i386) || arch(x86_64)
            isSim = true
        #endif
        return isSim
    }()
}
// MARK:- 自定义打印方法
func STLog<T>(_ message : T, file : String = #file, funcName : String = #function, lineNum : Int = #line) {

    #if DEBUG

        let fileName = (file as NSString).lastPathComponent

        print("\(fileName):(\(lineNum))-\(message)")

    #endif
}
//这样就是在建立宏
let kIOS8 = Double(UIDevice.current.systemVersion)! >= 8.0 ? 1 : 0
let UIScreenBounds: CGRect = UIScreen.main.bounds
let KNavigationBarBackgroundColor = UIColor(red: 249 / 255.0, green: 250 / 255.0, blue: 253 / 255.0, alpha: 1)
let KGlobalBackgroundColor = UIColor(red: 239 / 255.0, green: 239 / 255.0, blue: 239 / 255.0, alpha: 1)
let HistorySearch = "HistorySearch"
public let ScreenInfo = UIScreen.main.bounds;
public let ScreenWidth:CGFloat = UIScreen.main.bounds.size.width
public let ScreenHeight:CGFloat = UIScreen.main.bounds.size.height
public let ScreenBounds:CGRect = UIScreen.main.bounds
let keychain = KeychainSwift()
let mapKey = "d13a05877093182752451253685bb626"

let IUrl = "http://139.199.169.203/func/"
let pos = StToastShowType.top


//生产环境
let GfoodsUrl = "https://www.365greenlife.com/api/tiptop/v1"
let picUrl = "https://www.365greenlife.com/"
let LQYIP = "https://www.365greenlife.com/"

//ssid
let ssid = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6IjE1NzE3OTE0NTA1IiwidXNlcl9pZCI6IjEwMDA2Iiwicm9sZV9uYW1lIjoiXHU2NjZlXHU5MDFhXHU3NTI4XHU2MjM3IiwiZXhwIjoxNTEzMTU2MDk0LjM4MjY3NSwiaWF0IjoxNTEwNTY0MDk0LjM4MjY3NSwidHlwZSI6IjMifQ.hw8HO486y9OaUZ2PbrXTuz6NcIBLSpUlDOC-OS6VK5w"

//token 失效时后台返回相应的状态码
let OutCode = 403
let missNetTips = "没网络"
//水平滚动
let CellNumberOfOneRow = 5
let CellRow = 2
let OnePageNum = CellRow*CellNumberOfOneRow
//StToast的位置：
let Pos = StToastShowType.top
//状态栏高度信息
public let StatusBarH:CGFloat = (UIDevice.isX() ? 44 : 20)
//导航栏高度信息
public let NavigationBarH:CGFloat = 44
//tabbar高度信息
public let TabBarH:CGFloat = (UIDevice.isX() ? (49+34) : 49)
//IOS11底部安全区域的间距
public let TabbarSafeBotM:CGFloat = (UIDevice.isX() ? (34) : 0)
//状态栏.导航栏总高度信息
public let StatusBarAndNavigationBarH:CGFloat = (UIDevice.isX() ? (88) : 64)

//初始化请求的provider（并使用自定义插件）
let HttpbinProvider = MoyaProvider<GfoodsAPI>(plugins: [
    AuthPlugin(token: ssid)
    ])
//新闻界面常量
let FreshID = 666
//初始化请求的provider（并使用自定义插件）
//let RxHttpProvider = RxMoyaProvider<GfoodsAPI>(plugins: [
//    AuthPlugin(token: ssid)
//    ])

