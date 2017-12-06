//
//  CustomLayout.swift
//  pureCode
//
//  Created by test on 2017/8/18.
//  Copyright © 2017年 com.youlu. All rights reserved.
//
import UIKit
class CustomLayout: UICollectionViewFlowLayout {
    //左右滚动视图
    //MARK:--- 布局之前的准备工作 初始化  这个方法只会调用一次
    override func prepare() {
        scrollDirection = UICollectionViewScrollDirection.horizontal
        minimumLineSpacing = 6
        sectionInset = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 6)
        super.prepare()
    }
    //（该方法默认返回false） 返回true  frame发生改变就重新布局  内部会重新调用prepare 和layoutAttributesForElementsInRect
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    /// <#Description#>
    ///
    /// - Parameter proposedContentOffset: 当手指滑动的时候 最终的停止的偏移量
    /// - Returns: 返回最后停止后的点
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        let visibleX = proposedContentOffset.x
        let visibleY = proposedContentOffset.y
        let visibleW = collectionView?.bounds.size.width
        let visibleH = collectionView?.bounds.size.height
        //获取可视区域
        let targetRect = CGRect(x: visibleX, y: visibleY, width: visibleW!, height: visibleH!)

        //中心点的值
        let centerX = proposedContentOffset.x + (collectionView?.bounds.size.width)!/2

        //获取可视区域内的attributes对象
        let attrArr = super.layoutAttributesForElements(in: targetRect)!
        //如果第0个属性距离最小
        var min_attr = attrArr[0]
        for attributes in attrArr {
            if (abs(attributes.center.x-centerX) < abs(min_attr.center.x-centerX)) {
                min_attr = attributes
            }
        }
        //计算出距离中心点 最小的那个cell 和整体中心点的偏移
        let ofsetX = min_attr.center.x - centerX
        return CGPoint(x: proposedContentOffset.x+ofsetX, y: proposedContentOffset.y)
    }


}

