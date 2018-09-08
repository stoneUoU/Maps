//
//  YNSearchViewController.swift
//  YNSearch
//
//  Created by YiSeungyoun on 2017. 4. 11..
//  Copyright © 2017년 SeungyounYi. All rights reserved.
//

import UIKit

open class YNSearchViewController: UIViewController, UITextFieldDelegate {
    open var delegate: YNSearchDelegate? {
        didSet {
            self.ynSearchView.delegate = delegate
        }
    }
    
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
    open var ynSearchTextfieldView: YNSearchTextFieldView!
    open var ynSearchView: YNSearchView!
    open var backV = UIImageView()
    
    open var ynSerach = YNSearch()

    override open func viewDidLoad() {
        super.viewDidLoad()
    }
    open func ynSearchInit() {
        self.backV = UIImageView(frame: CGRect(x: 10, y: StatusBarH, width: 60, height: NavigationBarH))
        self.backV.image = UIImage(named: "icon_return.png")
        self.backV.isUserInteractionEnabled = true
        let backVGes = UITapGestureRecognizer(target: self, action: #selector(self.gesBack(_:)))
        self.backV.addGestureRecognizer(backVGes)
        self.view.addSubview(backV)

        self.ynSearchTextfieldView = YNSearchTextFieldView(frame: CGRect(x: 50, y: StatusBarH, width: width-80, height: NavigationBarH))
        self.ynSearchTextfieldView.ynSearchTextField.delegate = self
        self.ynSearchTextfieldView.ynSearchTextField.addTarget(self, action: #selector(ynSearchTextfieldTextChanged(_:)), for: .editingChanged)
        self.ynSearchTextfieldView.cancelButton.addTarget(self, action: #selector(ynSearchTextfieldcancelButtonClicked), for: .touchUpInside)

        self.ynSearchTextfieldView.ynSearchTextField.clearButtonMode = UITextFieldViewMode.whileEditing

        self.view.addSubview(self.ynSearchTextfieldView)
        self.ynSearchView = YNSearchView(frame: CGRect(x: 0, y: StatusBarAndNavigationBarH, width: width, height: height-StatusBarAndNavigationBarH))
        self.view.addSubview(self.ynSearchView)
    }
    
    open func setYNCategoryButtonType(type: YNCategoryButtonType) {
        self.ynSearchView.ynSearchMainView.setYNCategoryButtonType(type: .colorful)
    }
    
    open func initData(database: [Any]) {
        self.ynSearchView.ynSearchListView.initData(database: database)
    }

    
    // MARK: - YNSearchTextfield
    @objc open func ynSearchTextfieldcancelButtonClicked() {
        self.ynSearchTextfieldView.ynSearchTextField.text = ""
        self.ynSearchTextfieldView.ynSearchTextField.endEditing(true)
        self.ynSearchView.ynSearchMainView.redrawSearchHistoryButtons()
        
        UIView.animate(withDuration: 0.3, animations: {
            self.ynSearchView.ynSearchMainView.alpha = 1
            self.ynSearchTextfieldView.cancelButton.alpha = 0
            self.ynSearchView.ynSearchListView.alpha = 0
        }) { (true) in
            self.ynSearchView.ynSearchMainView.isHidden = false
            self.ynSearchView.ynSearchListView.isHidden = true
            self.ynSearchTextfieldView.cancelButton.isHidden = true
        }
    }
    @objc open func ynSearchTextfieldTextChanged(_ textField: UITextField) {
        self.ynSearchView.ynSearchListView.ynSearchTextFieldText = textField.text
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
    
    // MARK: - UITextFieldDelegate
    open func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text else { return true }
        if !text.isEmpty {
            self.ynSerach.appendSearchHistories(value: text)
            STLog(text)
            self.ynSearchView.ynSearchMainView.redrawSearchHistoryButtons()
        }
        self.ynSearchTextfieldView.ynSearchTextField.endEditing(true)
        return true
    }
    @objc func gesBack(_ tapGes :UITapGestureRecognizer){
        PublicFunc.popToPrevCtrl(selfCtrl: self)
    }
    
//    open func textFieldDidBeginEditing(_ textField: UITextField) {
//
//    }
}
