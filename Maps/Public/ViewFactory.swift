//
//  ViewFactory.swift
//  Maps
//
//  Created by test on 2017/11/15.
//  Copyright © 2017年 com.youlu. All rights reserved.
//

import UIKit
import SDWebImage
class ViewFactory
{
    /**
     * 创建按钮控件
     * 使用方法：ViewFactory.createBtn(title: "点击函数",bgColor:UIColor.black,titleColor:UIColor.white, action: .btnConfirm, sender: self)
     */
    class func createBtn(title:String,bgColor:UIColor,titleColor:UIColor,action:Selector, sender:UIViewController,size:CGFloat = 12,radiusSize:CGFloat = 0)
        -> UIButton {
            let btn = UIButton()
            btn.backgroundColor = bgColor
            btn.setTitle(title, for:.normal)
            btn.titleLabel!.textColor = titleColor
            btn.titleLabel!.font = UIFont.UiFontSize(size: size)
            btn.addTarget(sender, action:action, for:.touchUpInside)
            btn.layer.cornerRadius = radiusSize
            btn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
            return btn
    }

    /**
     * 创建文本输入框控件
     * 使用方法：ViewFactory.createTextField(placeHolder: "工厂方法创建样式", tintColor: .blue, sender: self)
     */
    class func createTextField(placeHolder:String,size:CGFloat = 12,tintColor:UIColor = .black,textColor:UIColor = .black,placeColor:UIColor = .black,borderStyle:UITextBorderStyle = .none, returnKeyType:UIReturnKeyType = .done,keyboardType:UIKeyboardType = .default,clearButtonMode:UITextFieldViewMode = .never,isSecureTextEntry:Bool = false,sender:UITextFieldDelegate)
        -> UITextField
    {
        let textField = UITextField()
        textField.backgroundColor = UIColor.clear
        textField.font=UIFont.UiFontSize(size: size)
        textField.setValue(placeColor, forKeyPath: "_placeholderLabel.textColor") //设置placeholder的字体颜色
        textField.attributedPlaceholder = NSAttributedString(string:placeHolder,attributes:[NSForegroundColorAttributeName:placeColor ])
        textField.tintColor  = tintColor //光标颜色
        textField.textColor  = textColor //字体颜色
        textField.placeholder = placeHolder
        textField.borderStyle = borderStyle  //边框样式
        textField.returnKeyType = returnKeyType  //完成键样式
        textField.keyboardType = keyboardType  //键盘样式
        textField.clearButtonMode = clearButtonMode  //编辑时出现清除按钮
        textField.isSecureTextEntry = isSecureTextEntry  //是否为安全输入
        textField.adjustsFontSizeToFitWidth = true
        textField.delegate = sender
        return textField
    }
    /**
     * 创建文本标签控件
     * 使用方法：ViewFactory.createLabel(title:"我是林磊,可以点击",bgColor:UIColor.cyan,titleColor:UIColor.red,pos:.center,size:16)
     */
    class func createLabel(title:String,bgColor:UIColor,titleColor:UIColor,pos:NSTextAlignment,size:CGFloat = 12) -> UILabel
    {
        let label = UILabel()
        label.textColor = titleColor;
        label.backgroundColor = bgColor;
        label.text = title;
        label.textAlignment = pos
        label.font = UIFont.systemFont(ofSize: size)
        return label
    }
    /**
     * 创建图片标签
     * 使用方法：ViewFactory.createImage(imgName: "https://www.365greenlife.com//static_file/uploads/10006/5d362cdec45e11e7a1076c0b849ba396.png", bgColor: .white,ifCircle:true,circleTax: 36)
     */
    class func createImage(imgName:String,bgColor:UIColor,ifCircle:Bool = false,circleTax:CGFloat = 0) -> UIImageView
    {
        let imgV = UIImageView()
        imgName.hasPrefix("http") == true ? imgV.sd_setImage(with: NSURL(string: imgName) as! URL, placeholderImage: UIImage(named: "png.png")) : (imgV.image = UIImage(named: imgName))
        imgV.backgroundColor = bgColor;
        imgV.clipsToBounds = true
        ifCircle == true ? (imgV.layer.cornerRadius = circleTax) : (imgV.layer.cornerRadius = 0)
        return imgV
    }
}
