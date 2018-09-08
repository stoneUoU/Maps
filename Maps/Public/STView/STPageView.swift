//
//  STPageView.swift
//  Maps
//
//  Created by test on 2018/1/10.
//  Copyright © 2018年 com.youlu. All rights reserved.
//

import UIKit

public protocol STPageViewDelegate: NSObjectProtocol {
    func numbersOfItemsInPageView(_ pageView: STPageView) -> Int
    func pageView(_ pageView: STPageView, cellForPageViewAtIndex index: Int) -> STPageViewCell
    func pageView(_ pageView: STPageView, didScrollToFloatIndex floatIndex: Float)
}

public class STPageView: UICollectionView {
    public weak var pageViewDelegate: STPageViewDelegate?
    public var currentIndex: Int = 0 {
        didSet{
            moveToIndex(currentIndex)
        }
    }

    override public var frame: CGRect {
        didSet{
            let layout = self.collectionViewLayout as! UICollectionViewFlowLayout
            if !layout.itemSize.equalTo(frame.size) {
                layout.itemSize = frame.size
                layout.invalidateLayout()
            }
        }
    }

    init(frame: CGRect) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = frame.size
        super.init(frame: frame, collectionViewLayout: layout)
        backgroundColor = UIColor.lightGray
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        bounces = true
        isPagingEnabled = true
        dataSource = self
        delegate = self
        register(STPageViewCell.self, forCellWithReuseIdentifier: "STPageViewCell")
    }
    convenience init() {
        self.init(frame: CGRect.zero)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func reloadItemsAtIndex(_ index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        reloadItems(at: [indexPath])
    }
    private func moveToIndex(_ index: Int) {
        let offsetX = frame.width * CGFloat(index)
        let offset = CGPoint(x: offsetX, y: 0)
        setContentOffset(offset, animated: false)
    }

}

extension STPageView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard pageViewDelegate != nil else {
            return 0
        }
        return pageViewDelegate!.numbersOfItemsInPageView(self)
    }
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard pageViewDelegate != nil else {
            return STPageViewCell()
        }
        return pageViewDelegate!.pageView(self, cellForPageViewAtIndex: indexPath.row)
    }
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard pageViewDelegate != nil else {
            return
        }
        let floatIndex = Float(scrollView.contentOffset.x / frame.width)
        pageViewDelegate!.pageView(self, didScrollToFloatIndex: floatIndex)
    }
}

public class STPageViewCell: UICollectionViewCell {
    var index: Int?
}
