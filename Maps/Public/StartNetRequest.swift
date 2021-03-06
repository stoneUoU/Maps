//
//  startNetRequest.swift
//  Gfoods
//
//  Created by 林磊 on 2017/8/25.
//  Copyright © 2017年 com.youlu. All rights reserved.

import UIKit
import Alamofire
import AFNetworking
import SwiftyJSON
// Swift的枚举支持任意数据类型,不需要,分隔
enum STHTTPMethod{
    case GET
    case POST
}
/// 网络管理工具   同步请求
class SynchronousNetWork: AFHTTPSessionManager {
    // 单例
    static let shared = SynchronousNetWork()
    // MARK:- get请求
    func getWithPath(options: String,paras: String?,token:String?,success: @escaping ((_ result: Any) -> ()),failure: @escaping ((_ error: Error) -> ())) {
        let Urls = URL.init(string: GfoodsUrl+options)
        let request = NSMutableURLRequest.init(url: Urls!)
        request.timeoutInterval = 30
        request.httpMethod = "\(STHTTPMethod.GET)"
        request.httpBody = paras?.data(using: String.Encoding.utf8)
        if(token != nil || token != ""){
            request.setValue(token, forHTTPHeaderField: "token")
        }
        // 3、响应对象
        var response:URLResponse?
        do {
            // 4、发出请求
            let  received =  try NSURLConnection.sendSynchronousRequest(request as URLRequest, returning: &response)
            if let result = try? JSONSerialization.jsonObject(with: received, options: .allowFragments){
                success(result)
            }
        } catch let error{
            failure(error)
        }
    }
    // MARK:- post请求
    func postWithPath(options: String,paras: Dictionary<String, Any>?,token:String?,success: @escaping ((_ result: Any) -> ()),failure: @escaping ((_ error: Error) -> ())) {
        let Urls = URL.init(string: GfoodsUrl+options)
        let data = try! JSONSerialization.data(withJSONObject: paras, options: JSONSerialization.WritingOptions.prettyPrinted)
        var str = ""
        let Str = String(data: data, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
        str = str + Str!
        let request = NSMutableURLRequest.init(url: Urls!)
        request.timeoutInterval = 30
        request.httpMethod = "\(STHTTPMethod.POST)"
        request.httpBody = str.data(using: String.Encoding.utf8)
        if(token != nil || token != ""){
            request.setValue(token, forHTTPHeaderField: "token")
        }
        // 5、响应对象
        var response:URLResponse?
        do {
            // 4、发出请求
            let  received =  try NSURLConnection.sendSynchronousRequest(request as URLRequest, returning: &response)
            if let result = try? JSONSerialization.jsonObject(with: received, options: .allowFragments){
                success(result)
            }
        } catch let error{
            failure(error)
        }
    }
}
/// 网络管理工具   异步请求
class AsynchronousNetWork: AFHTTPSessionManager  {
    // 单例
    static let shared = AsynchronousNetWork()
    // MARK:- get请求
    func getWithPath(options: String,paras: String?,token:String?,success: @escaping ((_ result: Any) -> ()),failure: @escaping ((_ error: Error) -> ())) {
        let Urls = URL.init(string: GfoodsUrl+options)
        let request = NSMutableURLRequest.init(url: Urls!)
        request.timeoutInterval = 30
        request.httpMethod = "\(STHTTPMethod.GET)"
        request.httpBody = paras?.data(using: String.Encoding.utf8)
        if(token != nil || token != ""){
            request.setValue(token, forHTTPHeaderField: "token")
        }
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest) { (data, respond, error) in
            if let data = data {
                if let result = try? JSONSerialization.jsonObject(with: data, options: .allowFragments){
                    success(result)
                }
            }else {
                failure(error!)
            }
        }
        dataTask.resume()
    }
    // MARK:- post请求
    func postWithPath(options: String,paras: Dictionary<String, Any>?,token:String?,success: @escaping ((_ result: Any) -> ()),failure: @escaping ((_ error: Error) -> ())) {
        let Urls = URL.init(string: GfoodsUrl+options)
        let data = try! JSONSerialization.data(withJSONObject: paras, options: JSONSerialization.WritingOptions.prettyPrinted)
        var str = ""
        let Str = String(data: data, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
        str = str + Str!
        let request = NSMutableURLRequest.init(url: Urls!)
        request.timeoutInterval = 30
        request.httpMethod = "\(STHTTPMethod.POST)"
        request.httpBody = str.data(using: String.Encoding.utf8)
        if(token != nil || token != ""){
            request.setValue(token, forHTTPHeaderField: "token")
        }
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest) { (data, respond, error) in
            if let data = data {
                if let result = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) {
                    success(result)
                }
            }else {
                failure(error!)
            }
        }
        dataTask.resume()
    }
}
let netSyStart=SynchronousNetWork()     //同步请求对象
let netAsyStart=AsynchronousNetWork()   //异步请求对象

