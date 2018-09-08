//
//  LaunchAdView.swift
//  AppLaunchADExample
//
//  Created by 童星 on 2016/10/28.
//  Copyright © 2016年 童星. All rights reserved.
//

import UIKit
import Kingfisher

fileprivate let launchAdsImage = "LaunchAdsImage"


class LaunchAdView: UIView {

    fileprivate var bgImageDefault: UIImageView!
    fileprivate var bgImageView: LaunchImageView!
    fileprivate var timeButton: UIButton!
    fileprivate var isDownloadImage: Bool?
    fileprivate var timer: Timer?
    fileprivate var timeNum: Int?
    
    fileprivate var clickImageBlock: (() -> Void)? = {
    
        () -> Void in
    }
    
    fileprivate var adsViewComplete: ((LaunchAdView) -> Void)? = {
    
        (launchAdView: LaunchAdView) -> Void in
    }
    
    init(imageUrl: String, imageAction: @escaping (() -> Void)) {
        super.init(frame: UIScreen.main.bounds)
        
        isDownloadImage = false
        clickImageBlock = imageAction
        bgImageDefault = UIImageView.init(frame: UIScreen.main.bounds)
        bgImageDefault.contentMode = UIViewContentMode.scaleToFill
        bgImageDefault.image = LaunchController.loadLaunchImage()
        
        bgImageView = LaunchImageView.init(frame: UIScreen.main.bounds)
        bgImageView.alpha = 0.0
        bgImageView.contentMode = UIViewContentMode.scaleToFill
        bgImageView.addTarget(target: self, action: #selector(imageClick(sender:)))
        
        timeButton = UIButton(frame: CGRect.init(x: UIScreen.main.bounds.size.width - 13 - 52, y: 20, width: 52, height: 25))
        timeButton.layer.cornerRadius = 25 * 0.5
        timeButton.clipsToBounds = true
        timeButton.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        timeButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        timeButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        timeButton.addTarget(self, action: #selector(adsTimeBtnClick(sender:)), for: UIControlEvents.touchUpInside)
        
        addSubview(bgImageDefault!)
        addSubview(bgImageView!)
        addSubview(timeButton!)
        

        // 缓存图片
        let imageCahcePath = ImageCache.init(name: launchAdsImage, path: nil)
        let cacheResult = imageCahcePath.isImageCached(forKey: imageUrl)
        if cacheResult.cached  {
            timeButton.isHidden = false
//            imageCahcePath.retrieveImage(forKey: imageUrl, options: [.transition(ImageTransition.fade(1))], completionHandler: { (image: Image?, cacheType: CacheType) in
//                self.bgImageView.image = image
//            })
            
            bgImageView.kf.setImage(with:URL(string: imageUrl), placeholder: LaunchController.loadLaunchImage(), options: [.transition(ImageTransition.fade(1))], progressBlock: nil, completionHandler: nil)
            isDownloadImage = true
        }
        else{ 
        
            timeButton.isHidden = true
            bgImageView.image = LaunchController.loadLaunchImage()
            KingfisherManager.shared.retrieveImage(with: URL(string: imageUrl)!, options: [.targetCache(ImageCache.init(name: launchAdsImage, path: nil))], progressBlock: { (receivedSize, expectedSize) in
                
                }, completionHandler: nil)
            
            isDownloadImage = false
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func removeAdsView() {
        if (timer?.isValid)! {
            timer?.invalidate()
        }
        
        timer = nil
        UIView.animate(withDuration: 0.7, animations: { [weak self] in
            self?.bgImageView?.alpha = 0.0
            self?.bgImageView?.frame = CGRect(x: UIScreen.main.bounds.size.width/20, y: -(UIScreen.main.bounds.size.height/20), width: 1.1 * (UIScreen.main.bounds.size.width), height: 1.1 * UIScreen.main.bounds.size.height)
            self?.alpha = 0.0
            }, completion: { (finished: Bool) in
                self.removeFromSuperview()
            if self.adsViewComplete != nil {
            
                self.adsViewComplete!(self)
            }
        })
    }
    
    public class func launchAdWithImageUrl(url: String, imageActionBlock : @escaping () -> Void) -> Any {
        
        return LaunchAdView.init(imageUrl: url, imageAction: imageActionBlock)
    }
    
    func startAnimationTime(time: Int, completeBlock block: @escaping ((_ launchAdView:  LaunchAdView) -> Void)) -> Void {
        
        timeNum = time
        adsViewComplete = block
        UIApplication.shared.keyWindow?.addSubview(self)
        UIApplication.shared.keyWindow?.bringSubview(toFront: self)
        UIView.animate(withDuration: 0.5) { 
            self.bgImageView?.alpha = 1
        }
        
        timeButton?.setTitle("跳过\(timeNum!)", for: UIControlState.normal)
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timeAction(timer:)), userInfo: nil, repeats: true)
    }
    
    public class func downLoadLaunchImage(imageUrl: String) {
        
        let imageCahcePath = ImageCache.init(name: launchAdsImage, path: nil)
        let cacheResult = imageCahcePath.isImageCached(forKey: imageUrl)
        if cacheResult.cached  {
        } else{
            KingfisherManager.shared.retrieveImage(with: URL(string: imageUrl)!, options: [.targetCache(ImageCache.init(name: launchAdsImage, path: nil))], progressBlock: { (receivedSize, expectedSize) in
                
                }, completionHandler: nil)
        }
        
    }
    
    
    //MARK: -- action method
    func imageClick(sender: UIImageView) {
        STLog("1")
        if (self.clickImageBlock != nil) && isDownloadImage! {
            self.clickImageBlock!()
            //在此处打印

            STLog("imageClickimageClick")
            self.removeAdsView()
        }
    }
    
    func adsTimeBtnClick(sender: UIButton) {
        STLog("2")
        self.removeAdsView()
    }
    
    func timeAction(timer: Timer) {
        if timeNum == 0 {
            self.removeAdsView()
            return
        }
        
        timeNum = timeNum! - 1
        if isDownloadImage! {
            timeButton?.setTitle("跳过\(timeNum!)", for: UIControlState.normal)
        }
    }
    

}
