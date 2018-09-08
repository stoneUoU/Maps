//
//  STWebView.swift
//  Maps
//
//  Created by test on 2018/1/10.
//  Copyright © 2018年 com.youlu. All rights reserved.
//

import UIKit

class STWebView: UIWebView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        scrollView.delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var changeClosures: DidChangeClosures!

    func scrolldidChangeClosures(closures: @escaping DidChangeClosures) {
        changeClosures = closures
    }

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let changeClosures = changeClosures else {
            return
        }
        changeClosures(scrollView, false)
    }
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        changeClosures(scrollView, true)
    }


}
