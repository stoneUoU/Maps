//
//  YNSearchVC.swift
//  Maps
//
//  Created by test on 2018/1/8.
//  Copyright © 2018年 com.youlu. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
class YNSearchVC:  YNSearchViewController, YNSearchDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate {
    let ynSearch = YNSearch()
    var demoSearchHistories:Array = [String]()
    var demoCategories = ["Menu", "Animation", "Transition", "TableView"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        if let _histories = UserDefaults.standard.object(forKey: "histories") as? [String] {
            self.demoSearchHistories = _histories
        }
        ynSearch.setCategories(value: demoCategories)
        ynSearch.setSearchHistories(value: self.demoSearchHistories)

        self.ynSearchInit()

        self.delegate = self

        let database1 = YNSearchModel(key: "YNDropDownMenu")
        let database2 = YNSearchModel(key: "YNSearchData")
        let database3 = YNSearchModel(key: "YNExpandableCell")
        let demoDatabase = [database1, database2, database3]

        self.initData(database: demoDatabase)
        //self.setYNCategoryButtonType(type:.background )
        self.view.addGestureRecognizer(UITapGestureRecognizer(target:self, action:#selector(YNSearchVC.handleTap(sender:))))

        //手势：
        let GesTar = self.navigationController?.interactivePopGestureRecognizer!.delegate
        let Ges = UIPanGestureRecognizer(target:GesTar,
                                         action:Selector(("handleNavigationTransition:")))
        Ges.delegate = self
        self.view.addGestureRecognizer(Ges)
        //同时禁用系统原先的侧滑返回功能
        self.navigationController?.interactivePopGestureRecognizer!.isEnabled = false
    }

    //对应方法
    func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            self.ynSearchTextfieldView.ynSearchTextField.resignFirstResponder()
        }
        sender.cancelsTouchesInView = false
    }
    override func viewWillAppear(_ animated: Bool) {

        self.navigationController?.setNavigationBarHidden(true, animated: false)
        CustomTabBarVC.hideBar(animated: true);
        IQKeyboardManager.sharedManager().enableAutoToolbar = false

        self.ynSearchView.ynSearchMainView.redrawSearchHistoryButtons()
        self.ynSearchTextfieldView.ynSearchTextField.becomeFirstResponder()
        //IQKeyboardManager.sharedManager().enable = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        IQKeyboardManager.sharedManager().enableAutoToolbar = true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func ynSearchListViewDidScroll() {
        self.ynSearchTextfieldView.ynSearchTextField.endEditing(true)
    }
    func ynSearchHistoryButtonClicked(text: String) {
        self.pushViewController(text: text)
        STLog(text)
    }

    func ynCategoryButtonClicked(text: String) {
        self.pushViewController(text: text)
        self.ynSearchView.ynSearchMainView.redrawSearchHistoryButtons()
    }

    func ynSearchListViewClicked(key: String) {
        self.pushViewController(text: key)
        STLog(key)
    }

//    func ynSearchListViewClicked(object: Any) {
//        STLog(object)
//    }
    override func ynSearchTextfieldTextChanged(_ textField: UITextField) {
        self.ynSearchView.ynSearchListView.ynSearchTextFieldText = textField.text
        STLog(textField.text)

        let database1 = YNSearchModel(key: "Swift")
        let database2 = YNSearchModel(key: "Objective-C")
        let database3 = YNSearchModel(key: "php")
        let demoDatabase = [database1, database2, database3]
        self.initData(database: demoDatabase)
        if textField.text?.characters.count != 0{
            UIView.animate(withDuration: 0.3, animations: {
                self.ynSearchView.ynSearchMainView.alpha = 0
                self.ynSearchTextfieldView.cancelButton.alpha = 1
                self.ynSearchView.ynSearchListView.alpha = 1
            }) { (true) in
                self.ynSearchView.ynSearchMainView.isHidden = true
                self.ynSearchView.ynSearchListView.isHidden = false
                self.ynSearchTextfieldView.cancelButton.isHidden = false

            }
        }
    }
    // 输入框按下键盘 return 收回键盘
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text?.characters.count != 0{
            STLog("\(textField.text),发送AjaX请求")
            self.ynSearchView.ynSearchListView.ynSearch.appendSearchHistories(value: textField.text!)
        }
        return true
    }
    func ynSearchListView(_ ynSearchListView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.ynSearchView.ynSearchListView.dequeueReusableCell(withIdentifier: YNSearchListViewCell.ID) as! YNSearchListViewCell
        if let ynmodel = self.ynSearchView.ynSearchListView.searchResultDatabase[indexPath.row] as? YNSearchModel {
            cell.searchLabel.text = ynmodel.key
        }
        return cell
    }

    func ynSearchListView(_ ynSearchListView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let ynmodel = self.ynSearchView.ynSearchListView.searchResultDatabase[indexPath.row] as? YNSearchModel, let key = ynmodel.key {
        self.ynSearchView.ynSearchListView.ynSearchListViewDelegate?.ynSearchListViewClicked(key: key)
            self.ynSearchView.ynSearchListView.ynSearchListViewDelegate?.ynSearchListViewClicked(object: self.ynSearchView.ynSearchListView.database[indexPath.row])
            self.ynSearchView.ynSearchListView.ynSearch.appendSearchHistories(value: key)
        }
    }

    func pushViewController(text:String) {
        //STLog("8888")
        let searchV = SearchDVC()
        searchV.someVals = ["text":text]
        PublicFunc.pushToNextCtrl(selfCtrl: self, otherCtrl: searchV)
    }
    //手势代码：
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if self.navigationController?.viewControllers.count == 1 {
            return false
        }
        return true
    }
}
