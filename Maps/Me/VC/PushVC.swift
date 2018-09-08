//
//  PushVC.swift
//  Maps
//
//  Created by test on 2017/10/13.
//  Copyright © 2017年 com.youlu. All rights reserved.
//

import UIKit
import WebKit
class PushVC: UIViewController,UIGestureRecognizerDelegate {
    //声明导航条
    var navigationBar:UINavigationBar?
    public var webView = WKWebView()
    public var progressView = UIProgressView()
    var open_url:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
        self.view.backgroundColor = UIColor.white

        //手势：
        let GesTar = self.navigationController?.interactivePopGestureRecognizer!.delegate
        let Ges = UIPanGestureRecognizer(target:GesTar,
                                         action:Selector(("handleNavigationTransition:")))
        Ges.delegate = self
        self.view.addGestureRecognizer(Ges)
        //同时禁用系统原先的侧滑返回功能
        self.navigationController?.interactivePopGestureRecognizer!.isEnabled = false
    }
    override func viewWillAppear(_ animated: Bool) {
        //self.tabBarController?.tabBar.isHidden = true
        self.navigationItem.setHidesBackButton(true, animated: true)
        navigationBar?.isTranslucent = false
        // 5.设置导航栏阴影图片
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //当前ViewController销毁前将其移除，否则会造成内存泄漏
        webView.configuration.userContentController.removeScriptMessageHandler(forName: "和web那边一样的方法名")
    }
    deinit {
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
        progressView.reloadInputViews()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension PushVC{
    func setUpUI(){
        //self.buildNavigationItem()
        navigationBar = UINavigationBar(frame: CGRect(x:0, y:UIDevice.isX() == true ? 44 : 20, width:ScreenInfo.width, height:44))
        
        let conf = WKWebViewConfiguration()
        conf.userContentController = WKUserContentController()
        conf.preferences.javaScriptEnabled = true
        conf.selectionGranularity = WKSelectionGranularity.character
        conf.userContentController.add(self, name: "和web那边一样的方法名")
        webView = WKWebView(frame: CGRect(x: 0, y: UIDevice.isX() == true ? 88 : 64, width: self.view.frame.size.width, height: self.view.frame.height - (UIDevice.isX() == true ? 88 : 64)),configuration:conf)
        webView.navigationDelegate = self
        webView.uiDelegate = self;
        let url = URL(string: open_url)
        let request = URLRequest(url: url!)
        webView.load(request)
        /**
         增加的属性：
         1.webView.estimatedProgress加载进度
         2.backForwardList 表示historyList
         3.WKWebViewConfiguration *configuration; 初始化webview的配置
         */
        self.view.addSubview(webView)
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        progressView = UIProgressView(frame: CGRect(x: 0, y: 44-2, width: UIScreen.main.bounds.size.width, height: 2))
        progressView.trackTintColor = UIColor.white
        progressView.progressTintColor = UIColor.orange
        navigationBar?.addSubview(progressView)
        
        self.view.addSubview(navigationBar!)
        onAdd()
    }
    
    func onAdd(){
        //给导航条增加导航项
        navigationBar?.pushItem(onMakeNavitem(), animated: true)
    }
    //创建一个导航项
    func onMakeNavitem()->UINavigationItem{
        var navigationItem = UINavigationItem()
        //创建左边按钮
        let button =   UIButton(type: .system)
        button.frame = CGRect(x:0, y:0, width:100, height:30)
        //button.backgroundColor = UIColor.cyan
        button.setImage(UIImage(named:"icon_fanhui_default"), for: .normal)
        button.imageView?.contentMode = .left
        button.addTarget(self, action: #selector(MineSubVC.goBack), for: .touchUpInside)
        let leftBarBtn = UIBarButtonItem(customView: button)
        //用于消除左边空隙，要不然按钮顶不到最前面
        let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil,
                                     action: nil)
        spacer.width = -48;
        //设置导航栏标题
        navigationItem.title = "拾頭网"
        navigationItem.leftBarButtonItems = [spacer,leftBarBtn]
        //取消iOS11返回按钮的bug
        if #available(iOS 11.0, *) {
            button.setTitle("\nbsp\nbsp\nbsp\nbsp\nbsp\nbsp\nbsp\nbsp\nbsp\nbsp\nbsp\nbsp我我我我", for: .normal)
        }
        return navigationItem
    }
    
}
extension PushVC:WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler{//用于与JS交互
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (keyPath == "estimatedProgress") {
            progressView.isHidden = webView.estimatedProgress == 1
            progressView.setProgress(Float(webView.estimatedProgress), animated: true)
            //print(webView.estimatedProgress)
        }
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        progressView.setProgress(0.0, animated: false)
        self.navigationItem.title = webView.title
    }
    // 页面加载失败时调用
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error){
        
        UIView.animate(withDuration: 0.5) {
            self.progressView.progress = 0.0
            self.progressView.isHidden = true
        }
        /// 弹出提示框点击确定返回
        let alertView = UIAlertController.init(title: "提示", message: "加载失败", preferredStyle: .alert)
        let okAction = UIAlertAction.init(title:"确定", style: .default) { okAction in
            _=self.navigationController?.popViewController(animated: true)
        }
        alertView.addAction(okAction)
        self.present(alertView, animated: true, completion: nil)
        
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        if(message.name == "和web那边一样的方法名") {
            print("JavaScript is sending a message \(message.body)")
        }
        
    }
    @objc func goBack() {
        DispatchQueue.main.async{
            if self.webView.canGoBack {
                self.webView.goBack()
            }else{
                //连续dismiss多个控制器
                self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
//                if let navBack = self.navigationController {
//                    navBack.popViewController(animated: true)
//                }
            }
        }
    }
    //手势代码：
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if self.navigationController?.viewControllers.count == 1 {
            return false
        }
        return true
    }
}

