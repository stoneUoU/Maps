//
//  GfoodsAPI.swift
//  Maps
//
//  Created by test on 2017/11/6.
//  Copyright © 2017年 com.youlu. All rights reserved.
//

import Moya

//请求分类
public enum GfoodsAPI {
    case mineAPI([String : Any]) //请求个人中心数据
    case toLogin([String : Any]) //请求登录数据
    case toType //请求呱呱天地栏目分类
}

//请求配置
extension GfoodsAPI: AuthorizedTargetType {
    //服务器地址
    public var baseURL: URL {
        return URL(string: GfoodsUrl)!
    }

    //各个请求的具体路径
    public var path: String {
        switch self {
        case .mineAPI(_):
            return "/account/info"
        case .toLogin(_):
            return "/account/login"
        case .toType:
            return "/app/news/type/list"
        }
    }

    //请求类型
    public var method: Moya.Method {
        switch self {
        case .mineAPI(_) :
            return .post
        case .toLogin(_):
            return .post
        case .toType:
            return .post
        default:
            return .get
        }
    }
    //请求任务事件（这里附带上参数）
    public var task: Task {
        switch self {
        case .mineAPI(let  paras):
            var params: [String: Any] = [:]
            params = paras
            return .requestParameters(parameters: params,
                                      encoding: JSONEncoding.default)
        default:
            return .requestPlain
        }
    }

    //是否执行Alamofire验证
    public var validate: Bool {
        return false
    }

    //这个就是做单元测试模拟的数据，只会在单元测试文件中有作用
    public var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }

    //请求头
    public var headers: [String: String]? {
        return nil
    }

    //是否需要授权
    public var needsAuth: Bool {
        switch self {
        case .mineAPI(let paras):
            return true
        case .toLogin(let paras):
            print(paras,"paras")
            return false
        case .toType:
            return false
        }
    }
}
