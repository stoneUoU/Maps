//
//  HorzionScrollLayout.swift
//  Maps
//
//  Created by test on 2017/11/14.
//  Copyright © 2017年 com.youlu. All rights reserved.
//
import UIKit
class HorzionScrollLayout: UICollectionViewFlowLayout {
    // 保存所有item
    fileprivate var attributesArr: [UICollectionViewLayoutAttributes] = []
    fileprivate var col: Int = 0
    fileprivate var row: Int = 0
    fileprivate var rowHeight: CGFloat = 0
    init(column: Int, row: Int, rowHeight: CGFloat) {
        super.init()
        self.col = column
        self.row = row
        self.rowHeight = rowHeight
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK:- 重新布局
    override func prepare() {
        super.prepare()

        let itemWH: CGFloat = ScreenInfo.width / CGFloat(col)

        // 设置itemSize
        itemSize = CGSize(width: itemWH, height: rowHeight)
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        scrollDirection = .horizontal

        // 设置collectionView属性
        collectionView?.isPagingEnabled = true
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = true
        let insertMargin = (collectionView!.bounds.height - CGFloat(row) * itemWH) * 0.5
        collectionView?.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)

        var page = 0
        let itemsCount = collectionView?.numberOfItems(inSection: 0) ?? 0
        for itemIndex in 0..<itemsCount {
            let indexPath = IndexPath(item: itemIndex, section: 0)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)

            page = itemIndex / (col * row)
            // 通过一系列计算, 得到x, y值
            let x = itemSize.width * CGFloat(itemIndex % Int(col)) + (CGFloat(page) * ScreenInfo.width)
            let y = itemSize.height * CGFloat((itemIndex - page * row * col) / col)

            attributes.frame = CGRect(x: x, y: y, width: itemSize.width, height: itemSize.height)
            // 把每一个新的属性保存起来
            attributesArr.append(attributes)
        }

    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var rectAttributes: [UICollectionViewLayoutAttributes] = []
        _ = attributesArr.map({
            if rect.contains($0.frame) {
                rectAttributes.append($0)
            }
        })
        return rectAttributes
    }

    override var collectionViewContentSize: CGSize {
        let size: CGSize = super.collectionViewContentSize
        let collectionViewWidth: CGFloat = self.collectionView!.frame.size.width
        let nbOfScreen: Int = Int(ceil(size.width / collectionViewWidth))
        let newSize: CGSize = CGSize(width: collectionViewWidth * CGFloat(nbOfScreen), height: size.height)
        return newSize
    }
}
