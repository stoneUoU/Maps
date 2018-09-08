//
//  API.swift
//  Maps
//
//  Created by test on 2017/11/6.
//  Copyright © 2017年 com.youlu. All rights reserved.
//
import Moya
import SwiftyJSON
let httpRequestClosure = { (endpoint: Endpoint<GfoodsAPI>, done: @escaping MoyaProvider<GfoodsAPI>.RequestResultClosure) in

    guard var request: URLRequest = try? endpoint.urlRequest() else {return}
    request.timeoutInterval = timeOutTime   //设置请求超时时间
    done(.success(request))
}
struct Network {
    static func request(
        Authos:String,
        _ target: GfoodsAPI,
        success successCallback: @escaping (JSON) -> Void,
        error errorCallback: @escaping (Int) -> Void,
        failure failureCallback: @escaping (MoyaError) -> Void
        ) {
        MoyaProvider<GfoodsAPI>(requestClosure:httpRequestClosure,plugins: [AuthPlugin(token: Authos)]).request(target) { result in
            switch result {
            case let .success(response):
                do {
                    //如果数据返回成功则直接将结果转为JSON
                    try response.filterSuccessfulStatusCodes()
                    let json = try JSON(response.mapJSON())
                    successCallback(json)
                }
                catch let error {
                    //如果数据获取失败，则返回错误状态码
                    errorCallback((error as! MoyaError).response!.statusCode)
                }
            case let .failure(error):
                //如果连接异常，则返回错误信息（必要时还可以将尝试重新发起请求）
                failureCallback(error)
            }
        }
    }
}
