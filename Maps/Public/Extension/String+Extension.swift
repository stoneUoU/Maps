//
//  String+Extension.swift
//  Maps
//
//  Created by test on 2017/11/10.
//  Copyright © 2017年 com.youlu. All rights reserved.
//
import UIKit
extension String{

    //MARK:获得string内容高度

    func stringHeightWith(fontSize:CGFloat,width:CGFloat)->CGFloat{

        let font = UIFont.systemFont(ofSize: fontSize)

        let size = CGSize(width:width,height:CGFloat.greatestFiniteMagnitude)

        let paragraphStyle = NSMutableParagraphStyle()

        paragraphStyle.lineBreakMode = .byWordWrapping;

        let attributes = [NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy()]

        let text = self as NSString

        let rect = text.boundingRect(with: size, options:.usesLineFragmentOrigin, attributes: attributes, context:nil)

        return rect.size.height
    }
}
