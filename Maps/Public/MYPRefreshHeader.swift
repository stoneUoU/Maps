//
//  MYPRefreshHeader.swift
//  Maps
//
//  Created by test on 2017/12/20.
//  Copyright © 2017年 com.youlu. All rights reserved.
//
import UIKit
import SnapKit

/**
 *  - none: 结束刷新
 *  - normal: 用户做了下拉刷新操作
 *  - willRefresh: 即将开始刷新
 *  - refreshing: 正在刷新
 */
enum MRefreshStatus {
    case none,normal,willRefresh,refreshing
}

protocol MYPRefreshHeaderDelegate: NSObjectProtocol {
    func mStartRefreshing(refreshHeader: MYPRefreshHeader)
    func mEndRefreshing(refreshHeader: MYPRefreshHeader)
}

class MYPRefreshHeader: UIView {

    private lazy var mRefreshImageView: UIImageView = {
        let tmp: UIImageView = UIImageView()
        tmp.animationDuration = 0.5

        return tmp
    }()

    private lazy var mRefreshMessageLabel: UILabel = {
        let tmp: UILabel = UILabel()
        tmp.textAlignment = .center
        tmp.font = UIFont.systemFont(ofSize: 14)

        return tmp
    }()

    var mRefreshStatus:MRefreshStatus = .normal {
        willSet(newValue) {

        }
        didSet(oldValue) {
            if self.mRefreshImageView.isAnimating {
                self.mRefreshImageView.stopAnimating()
            }
            self.mRefreshImageView.image = nil
            self.mRefreshImageView.animationImages = nil
            switch mRefreshStatus {
            case .none:
                weak var weakSelf = self
                // 代理结束刷新
                mDelegate?.mEndRefreshing(refreshHeader: weakSelf!)
            case .normal:
                self.mRefreshImageView.image = UIImage.init(named: "refresh_down")
                self.mRefreshMessageLabel.text = "下拉刷新"
            case .willRefresh:
                self.mRefreshImageView.image = UIImage.init(named: "refresh_up")
                self.mRefreshMessageLabel.text = "松开即可刷新"
            case .refreshing:
                self.mRefreshImageView.animationImages = [UIImage.init(named: "refresh1")!,UIImage.init(named: "refresh2")!,UIImage.init(named: "refresh3")!,UIImage.init(named: "refresh4")!]
                self.mRefreshImageView.startAnimating()
                self.mRefreshMessageLabel.text = "刷新中~"
                weak var weakSelf = self
                // 代理刷新
                mDelegate?.mStartRefreshing(refreshHeader: weakSelf!)
            }
        }
    }

    weak var mDelegate: MYPRefreshHeaderDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.addSubview(mRefreshImageView)
        self.addSubview(mRefreshMessageLabel)

        mRefreshImageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(10)
            make.size.equalTo(CGSize.init(width: 30, height: 30))
        }

        mRefreshMessageLabel.snp.makeConstraints { (make) in
            make.centerX.left.equalToSuperview()
            make.top.equalTo(mRefreshImageView.snp.bottom).offset(5)
            make.height.equalTo(15)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

