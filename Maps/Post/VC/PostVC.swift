//
//  PostVC.swift
//  Centers
//
//  Created by test on 2017/9/29.
//  Copyright © 2017年 com.youlu. All rights reserved.
//

import UIKit
import SnapKit
class PostVC: UIViewController {
    
    lazy var postV: PostV = {[weak self] in
        let Frame = CGRect(x: 0, y: 0, width: ScreenInfo.width, height: ScreenInfo.height)
        let postV = PostV(frame: Frame)
        postV.postVDelegate = self
        return postV
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension PostVC:PostVDelegate,UIScrollViewDelegate{
    func setupUI(){
        self.view.addSubview(postV)
        // 设置代理
        postV.scrollV.delegate = self
    }
    func toClose(postV: PostV) {
        self.dismiss(animated: false, completion: nil)
    }
    // MARK: - UIScrollViewDelegate
    //视图滚动中一直触发
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("x:\(scrollView.contentOffset.x) y:\(scrollView.contentOffset.y)")
    }
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if velocity.y > 0 {
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        } else if velocity.y < 0 {
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }
}
