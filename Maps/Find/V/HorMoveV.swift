//
//  HorMoveV.swift
//  Maps
//
//  Created by test on 2017/10/24.
//  Copyright © 2017年 com.youlu. All rights reserved.
//
import UIKit
protocol HorMoveVDelegate: class {
    //去子页面
    func toDetail(horMoveV : HorMoveV)
    func toWhisper(horMoveV : HorMoveV)
}
class  HorMoveV: UIView {
    weak var horMoveVDelegate : HorMoveVDelegate?
    public var collectionView:UICollectionView?
    public var layout:CustomLayout?
    var oDatas : [UoUDatas]? {
        didSet {
            // 1.刷新collectionView
            collectionView?.reloadData()
            pageControl.numberOfPages = self.oDatas!.count / OnePageNum + (self.oDatas!.count % OnePageNum == 0 ? 0 : 1)
        }
    }
    lazy var pageControl: UIPageControl = { [unowned self] in
        let pageC = UIPageControl()
        pageC.currentPage = 0
        pageC.pageIndicatorTintColor = UIColor.lightGray
        pageC.currentPageIndicatorTintColor = UIColor.darkGray
        return pageC
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension HorMoveV{
    func setupUI(){
//        layout = CustomLayout()
//        layout?.itemSize = CGSize(width: (ScreenInfo.width-24)/4, height:PublicFunc.setHeight(size: 90))
//        let rect = CGRect(x: 0, y: 0, width:ScreenInfo.width, height: PublicFunc.setHeight(size: 90))
//        collectionView = UICollectionView(frame: rect, collectionViewLayout: layout!)
//        collectionView?.showsHorizontalScrollIndicator = false;
//        collectionView?.delegate = self
//        collectionView?.dataSource = self
//        addSubview(collectionView!)
//        collectionView?.alwaysBounceHorizontal = false
//        //collectionView?.register(HormoveCell.self, forCellWithReuseIdentifier: "identifier")
//        collectionView?.register(UINib(nibName: "HormoveCell", bundle: nil), forCellWithReuseIdentifier: "HormoveCell")
//        collectionView?.backgroundColor = UIColor.white
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width:ScreenInfo.width, height: PublicFunc.setHeight(size: 124)), collectionViewLayout: HorzionScrollLayout(column: CellNumberOfOneRow, row: CellRow,rowHeight:PublicFunc.setHeight(size: 124)/2))
        collectionView?.backgroundColor = .white
        collectionView?.isPagingEnabled = true
        collectionView?.delegate = self
        collectionView?.dataSource = self
        addSubview(collectionView!)
        addSubview(pageControl)
        pageControl.snp.makeConstraints{(make) in
            make.bottom.equalTo(collectionView!.snp.bottom).offset(PublicFunc.setHeight(size: 12))
            make.height.equalTo(PublicFunc.setHeight(size: 16))
            make.centerX.equalTo(collectionView!)
        }
        //collectionView?.register(UINib(nibName: "HormoveCell", bundle: nil), forCellWithReuseIdentifier: "HormoveCell")
        collectionView?.register(CollectVCell.self, forCellWithReuseIdentifier: "collectVcells")
    }
}
extension HorMoveV: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffset = scrollView.contentOffset.x
        let page = contentOffset / scrollView.frame.size.width + (Int(contentOffset) % Int(scrollView.frame.size.width) == 0 ? 0 : 1)
        pageControl.currentPage = Int(page)
    }
}
extension HorMoveV:
    UICollectionViewDelegate,
    UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout{

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.oDatas?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HormoveCell", for: indexPath as IndexPath) as! HormoveCell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectVcells", for: indexPath as IndexPath) as! CollectVCell
        let datas: UoUDatas = self.oDatas![indexPath.row] as UoUDatas
//        cell.iconImg.image = UIImage(named: "\(datas.png)")
//        cell.iconLab.text = "\(datas.vals)"
        cell.imgV.image = UIImage(named: "\(datas.png)")
        cell.textLab.text = "\(datas.vals)"
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (indexPath as NSIndexPath).row == 0{
            horMoveVDelegate?.toDetail(horMoveV: self)
        }else if (indexPath as NSIndexPath).row == 1{
            horMoveVDelegate?.toWhisper(horMoveV: self)
        }else if (indexPath as NSIndexPath).row == 2{
            STLog("我是打印信息")
        }else if (indexPath as NSIndexPath).row == 3{
            print("4")
        }else if (indexPath as NSIndexPath).row == 4{
            print("5")
        }else if (indexPath as NSIndexPath).row == 5{
            print("6")
        }else if (indexPath as NSIndexPath).row == 6{
            print("7")
        }else if (indexPath as NSIndexPath).row == 7{
            print("8")
        }else if (indexPath as NSIndexPath).row == 8{
            print("9")
        }else if (indexPath as NSIndexPath).row == 9{
            print("10")
        }else if (indexPath as NSIndexPath).row == 10{
            print("11")
        }else{
            print("12")
        }
    }
}

