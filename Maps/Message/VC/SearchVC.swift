//
//  SearchVC.swift
//  Maps
//
//  Created by test on 2017/11/3.
//  Copyright © 2017年 com.youlu. All rights reserved.

import UIKit

class SearchVC: UIViewController,UISearchBarDelegate,UIScrollViewDelegate ,UITextFieldDelegate,UITextViewDelegate,UIGestureRecognizerDelegate{
    //声明导航条
    var navigationBar = UIView()
    var bgView = UIView()
    var photoT = UILabel()
    var spaceV = UIView()
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: CGRect(x:0,y:UIDevice.isX() == true ? 88 : 64,width:ScreenInfo.width,height:ScreenInfo.height - (UIDevice.isX() == true ? 88 : 64)))
        scrollView.alwaysBounceVertical = true
        scrollView.backgroundColor = UIColor(red: 239 / 255.0, green: 239 / 255.0, blue: 239 / 255.0, alpha: 1)
        scrollView.delegate = self
        return scrollView
    }()

    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "请输入商品名称"
        searchBar.barTintColor =  UIColor(red: 239 / 255.0, green: 239 / 255.0, blue: 239 / 255.0, alpha: 1)
        searchBar.tintColor = UIColor.blue
        searchBar.searchBarStyle = .minimal
        searchBar.keyboardType = .default
        searchBar.delegate = self
        return searchBar
    }()

    //清空历史按钮
    lazy var cleanHistoryButton: UIButton = {
        let cleanHistoryButton = UIButton(type: .custom)
        cleanHistoryButton.setTitle("清 空 历 史", for: .normal)
        cleanHistoryButton.setTitleColor(UIColor(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        cleanHistoryButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        cleanHistoryButton.backgroundColor = UIColor(red: 255.0, green: 255.0, blue: 255.0, alpha: 1)
        cleanHistoryButton.layer.cornerRadius = 5
        cleanHistoryButton.layer.borderColor = UIColor(red: 200 / 255.0, green: 200 / 255.0, blue: 200 / 255.0, alpha: 1).cgColor
        cleanHistoryButton.layer.borderWidth = 0.5
        cleanHistoryButton.isHidden = true
        cleanHistoryButton.addTarget(self, action: #selector(cleanHistory), for: .touchUpInside)
        return cleanHistoryButton
    }()
    var hotSearchView: SearchView?
    //历史记录视图
    var historySearchView: SearchView?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.buildNavigationItem()
        self.setUp()
        self.setupHotSearchView()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target:self, action:#selector(SearchVC.handleTap(sender:))))
        if(UserDefaults.standard.object(forKey: HistorySearch) as? [String] != nil){
            setupHistorySearchView()
        }
        // Do any additional setup after loading the view.

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
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    func setUp() {
        self.view.backgroundColor = KGlobalBackgroundColor
        self.view.addSubview(scrollView)
        scrollView.addSubview(cleanHistoryButton)
    }
    func buildNavigationItem(){
        //设置状态栏颜色
        if UIDevice.isX() == true{
            navigationBar.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: 88)
        }else{
            navigationBar.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: 64)
        }

        navigationBar.backgroundColor = UIColor(red: 239 / 255.0, green: 239 / 255.0, blue: 239 / 255.0, alpha: 1)
        self.view.addSubview(navigationBar)

        //创建取消label
        photoT.text = "取消"
        photoT.textAlignment = .center
        photoT.textColor = .blue
        photoT.isUserInteractionEnabled = true
        let photoTGes = UITapGestureRecognizer(target: self, action: #selector(self.canCel(_:)))
        photoT.addGestureRecognizer(photoTGes)
        navigationBar.addSubview(photoT)
        photoT.snp.makeConstraints { (make) in
            make.top.equalTo(UIDevice.isX() == true ? CGFloat(44) : CGFloat(20))
            make.height.equalTo(CGFloat(44))
            make.right.equalTo(-16)
        }

        let bgView = UIView(frame: CGRect(x: 0 , y: UIDevice.isX() == true ? CGFloat(51) : CGFloat(27), width: UIScreenBounds.width * 0.2, height: 30))
        bgView.backgroundColor = UIColor.white
        bgView.layer.masksToBounds = true
        bgView.layer.cornerRadius = 6
        bgView.layer.borderColor = UIColor(red: 100 / 255.0, green: 100 / 255.0, blue: 100 / 255.0, alpha: 1).cgColor
        bgView.layer.borderWidth = 0.2
        UIGraphicsBeginImageContext(bgView.bounds.size)
        bgView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let bgImage = UIGraphicsGetImageFromCurrentImageContext()
        searchBar.setSearchFieldBackgroundImage(bgImage, for: .normal)
        navigationBar.addSubview(searchBar)
        searchBar.snp.makeConstraints { (make) in
            make.top.equalTo(UIDevice.isX() == true ? CGFloat(51) : CGFloat(27))
            make.height.equalTo(CGFloat(30))
            make.left.equalTo(0)
            make.right.equalTo(photoT.snp.left).offset(-12)
        }

        spaceV = UIView()
        spaceV.backgroundColor = .white
        navigationBar.addSubview(spaceV)
        spaceV.snp.makeConstraints { (make) in
            make.bottom.equalTo(navigationBar.snp.bottom).offset(-1)
            make.height.equalTo(CGFloat(1))
            make.width.equalTo(ScreenInfo.width)
        }

    }
    func setupHotSearchView() {
        //如果偏好设置为空写入一个空数组
        var historySearch = UserDefaults.standard.object(forKey: HistorySearch) as? [String]
        if historySearch == nil {
            historySearch = [String]()
            UserDefaults.standard.set(historySearch, forKey: HistorySearch)
        }
        //标签的标题 可以从服务器获得
        let arr = ["年货大集", "酸奶", "水", "车厘子", "洽洽瓜子", "维他", "香烟", "周黑鸭", "草莓", "星巴克", "卤味"]
        hotSearchView = SearchView(frame: CGRect(x: 10, y: 40, width: UIScreenBounds.width - 20, height: 100), titleLabelText: "热门搜索", btnTexts: arr, btnCallBackBlock: { [weak self](btn) in
            let str = btn.title(for: .normal)
            //将按钮文字显示到搜索框
            self?.searchBar.text = str
            //将按钮文字写入到偏好设置
            self?.writeHistorySearchToUserDefaults(str: str!)
            self?.searchBar.resignFirstResponder()
        })
        hotSearchView?.bounds.size.height = (hotSearchView?.searchViewHeight)!
        scrollView.addSubview(hotSearchView!)
    }

    //将历史搜索写入到偏好设置

    //将历史搜索写入偏好设置
    private func writeHistorySearchToUserDefaults(str: String) {
        //从偏好设置中读取
        var historySearch = UserDefaults.standard.object(forKey: HistorySearch) as? [String]
        //如果已经存在就不重复写入
        for text in historySearch! {
            if text == str {
                return
            }
        }
        historySearch!.append(str)
        UserDefaults.standard.set(historySearch, forKey: HistorySearch)
        setupHistorySearchView()
    }
    private func setupHistorySearchView() {
        if historySearchView != nil {
            historySearchView?.removeFromSuperview()
            historySearchView = nil
        }

        //从偏好设置中读取
        let arr = UserDefaults.standard.object(forKey: HistorySearch) as! [String]
        if arr.count > 0 {
            historySearchView = SearchView(frame: CGRect(x: 10, y: (hotSearchView?.frame.maxY)! + 20, width: UIScreenBounds.width - 20, height: 0), titleLabelText: "历史记录", btnTexts: arr, btnCallBackBlock: { [weak self](btn) in
                let str = btn.title(for: .normal)
                self?.searchBar.text = str
                self?.searchBar.resignFirstResponder()
            })
            historySearchView?.frame.size.height = (historySearchView?.searchViewHeight)!
            scrollView.addSubview(historySearchView!)
            updateCleanHistoryButton(hidden: false)
        }
    }
    //更新清空历史视图状态

    private func updateCleanHistoryButton(hidden: Bool) {
        if historySearchView != nil {
            cleanHistoryButton.frame = CGRect(x: 0.1 * UIScreenBounds.width, y: (historySearchView?.frame.maxY)! + 20, width: UIScreenBounds.width * 0.8, height: 40)
        }
        cleanHistoryButton.isHidden = hidden
    }
    //SearchBar代理方法
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if (searchBar.text?.characters.count)! > 0 {
            searchBar.resignFirstResponder()
            //将搜索框文字写入到偏好设置
            writeHistorySearchToUserDefaults(str: searchBar.text!)
        }
    }
    @objc private func cleanHistory() {
        var historys = UserDefaults.standard.object(forKey: HistorySearch) as? [String]
        historys?.removeAll()
        UserDefaults.standard.set(historys, forKey: HistorySearch)
        setupHistorySearchView()
        updateCleanHistoryButton(hidden: true)
    }
    //对应方法
    func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            searchBar.resignFirstResponder()
        }
        sender.cancelsTouchesInView = false
    }
    func textFieldShouldReturn(_ textField:UITextField) -> Bool
    {
        //收起键盘
        searchBar.resignFirstResponder()
        return true;

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    @objc func canCel(_ tapGes :UITapGestureRecognizer){
        self.searchBar.resignFirstResponder()
        self.navigationController?.popViewController(animated: true)
    }
    //手势代码：
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if self.navigationController?.viewControllers.count == 1 {
            return false
        }
        return true
    }

}

