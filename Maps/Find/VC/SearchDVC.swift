//
//  SearchDVC.swift
//  Maps
//
//  Created by test on 2018/1/12.
//  Copyright © 2018年 com.youlu. All rights reserved.
//

import UIKit

class SearchDVC: YNSearchViewController ,UIScrollViewDelegate,UIGestureRecognizerDelegate{
    var someVals:[String : Any] = [String : Any]()
    var whichFlag = Int()
    var shareView:STSortView!
    var renqiView:STSortView!
    var totalV = UIView()
    var pSort = UIButton()
    var xSort = UIButton()
    var rSort = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.setUp(centerVals: "搜索详情", rightVals: "")
        self.setUpUI()
        self.view.backgroundColor = .white
        //STLog(someVals["text"])
        self.ynSearchView.ynSearchMainView.alpha = 0
        self.ynSearchTextfieldView.cancelButton.alpha = 1
        self.ynSearchView.ynSearchListView.alpha = 1
        self.delegate = self

        self.view.addGestureRecognizer(UITapGestureRecognizer(target:self, action:#selector(SearchDVC.handleTap(sender:))))

        //手势：
        let GesTar = self.navigationController?.interactivePopGestureRecognizer!.delegate
        let Ges = UIPanGestureRecognizer(target:GesTar,
                                         action:Selector(("handleNavigationTransition:")))
        Ges.delegate = self
        self.view.addGestureRecognizer(Ges)
        //同时禁用系统原先的侧滑返回功能
        self.navigationController?.interactivePopGestureRecognizer!.isEnabled = false

        if let some = someVals["text"]{
            self.ynSearchTextfieldView.ynSearchTextField.placeholder = some as! String
        }
    }
    func setUpUI(){
        self.ynSearchInit()
        shareView = STSortView.init(frame: CGRect(x:0, y:-120, width:UIScreen.main.bounds.width, height:120))
        shareView.backgroundColor = UIColor.lightGray
        shareView.addItem(title: "销量最高")
        shareView.addItem(title: "销量适中")
        shareView.addItem(title: "销量最低")
        shareView._delegate = self

        renqiView = STSortView.init(frame: CGRect(x:0, y:-80, width:UIScreen.main.bounds.width, height:80))
        renqiView.backgroundColor = UIColor.lightGray
        renqiView.addItem(title: "人气最高")
        renqiView.addItem(title: "人气适中")
        renqiView._delegate = self

        totalV.backgroundColor = .cyan
        totalV.isUserInteractionEnabled = true
        self.view.addSubview(totalV)
        totalV.snp.makeConstraints{
            (make) in
            make.width.equalTo(ScreenInfo.width)
            make.height.equalTo(sortH)
            make.top.equalTo(StatusBarAndNavigationBarH)
            make.left.equalTo(self.view)
        }
        pSort.frame = CGRect.zero
        pSort.setTitle("价格排序", for: .normal)
        pSort.setTitleColor(.white, for: .normal)
        pSort.backgroundColor = UIColor.red
        pSort.tag = 0
        pSort.addTarget(self, action: #selector(self.click(btn:)), for: .touchUpInside)
        totalV.addSubview(pSort)
        pSort.snp.makeConstraints{
            (make) in
            make.centerY.equalTo(totalV)
            make.left.equalTo(0)
            make.width.equalTo(ScreenInfo.width/3)
            make.height.equalTo(sortH)
        }

        xSort.frame = CGRect.zero
        xSort.setTitle("销量排序", for: .normal)
        xSort.setTitleColor(.white, for: .normal)
        xSort.backgroundColor = UIColor.cyan
        xSort.tag = 1
        xSort.addTarget(self, action: #selector(self.click(btn:)), for: .touchUpInside)
        totalV.addSubview(xSort)
        xSort.snp.makeConstraints{
            (make) in
            make.centerY.equalTo(totalV)
            make.left.equalTo(pSort.snp.right).offset(0)
            make.width.equalTo(ScreenInfo.width/3)
            make.height.equalTo(sortH)
        }

        rSort.frame = CGRect.zero
        rSort.setTitle("人气排序", for: .normal)
        rSort.setTitleColor(.white, for: .normal)
        rSort.backgroundColor = UIColor.green
        rSort.tag = 2
        rSort.addTarget(self, action: #selector(self.click(btn:)), for: .touchUpInside)
        totalV.addSubview(rSort)
        rSort.snp.makeConstraints{
            (make) in
            make.centerY.equalTo(totalV)
            make.left.equalTo(xSort.snp.right).offset(0)
            make.width.equalTo(ScreenInfo.width/3)
            make.height.equalTo(sortH)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

extension SearchDVC:YNSearchDelegate{
    override func ynSearchTextfieldTextChanged(_ textField: UITextField) {
        STLog("9999")
        self.ynSearchView.ynSearchListView.ynSearchTextFieldText = textField.text
        let database1 = YNSearchModel(key: "demo")
        let database2 = YNSearchModel(key: "val-C")
        let database3 = YNSearchModel(key: "python")
        let demoDatabase = [database1, database2, database3]
        self.initData(database: demoDatabase)
        if textField.text?.characters.count != 0{
            UIView.animate(withDuration: 0.3, animations: {
                self.totalV.alpha = 0
                self.ynSearchTextfieldView.cancelButton.alpha = 1
                self.ynSearchView.ynSearchListView.alpha = 1
            }) { (true) in
                self.totalV.isHidden = true
                self.ynSearchView.ynSearchListView.isHidden = false
                self.ynSearchTextfieldView.cancelButton.isHidden = false
            }
        }
    }
    override func ynSearchTextfieldcancelButtonClicked() {
        self.ynSearchTextfieldView.ynSearchTextField.text = ""
        self.ynSearchTextfieldView.ynSearchTextField.endEditing(true)
        UIView.animate(withDuration: 0.3, animations: {
            self.totalV.alpha = 1
            self.ynSearchTextfieldView.cancelButton.alpha = 0
            self.ynSearchView.ynSearchListView.alpha = 0
        }) { (true) in
            self.totalV.isHidden = false
            self.ynSearchView.ynSearchListView.isHidden = true
            self.ynSearchTextfieldView.cancelButton.isHidden = true
        }
    }
    // 输入框按下键盘 return 收回键盘
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text?.characters.count != 0{
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

    func ynCategoryButtonClicked(text: String) {
        STLog(text)
    }

    func ynSearchHistoryButtonClicked(text: String) {
        STLog(text)
    }

    func ynSearchListViewClicked(key: String) {
        STLog(key)
    }
    //对应方法
    func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            self.ynSearchTextfieldView.ynSearchTextField.resignFirstResponder()
        }
        sender.cancelsTouchesInView = false
    }
}

extension SearchDVC:STSortViewDelegate{
    func shareBtnClick(index: Int) {
        switch self.whichFlag {
        case 0:
            STLog("价格排序，\(index)")
        default:
            STLog("人气排序，\(index)")
        }
        STLog(index)
    }
    func click(btn:UIButton){
        switch btn.tag {
        case 0:
            self.whichFlag = 0

            shareView.show()
        case 1:
            STLog("价格排序")
        default:
            self.whichFlag = 1
            let sheetView = SmileActionSheet(title: "SmileLive", cancelButtonTitle: "取消", buttonTitles: ["1", "2", "3"])
            sheetView.show()

        }
    }
}
