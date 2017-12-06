//
//  AuthPlugin.swift
//  Maps
//
//  Created by test on 2017/11/6.
//  Copyright © 2017年 com.youlu. All rights reserved.
//

import Foundation
import Moya
protocol AuthorizedTargetType: TargetType {
    //返回是否需要授权
    var needsAuth: Bool { get }
}
struct AuthPlugin: PluginType {
    //令牌字符串
    let token: String
    //准备发起请求
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        //判断该请求是否需要授权
        guard
            let target = target as? AuthorizedTargetType,
            target.needsAuth
            else {
                print(request)
                return request
        }
        var request = request
        request.addValue(token, forHTTPHeaderField: "Authorization")
        return request
    }
}
