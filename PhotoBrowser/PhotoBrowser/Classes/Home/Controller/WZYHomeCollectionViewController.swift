//
//  WZYHomeCollectionViewController.swift
//  PhotoBrowser
//
//  Created by 王中尧 on 16/8/15.
//  Copyright © 2016年 wzy. All rights reserved.
//

import UIKit

import MJExtension
import AFNetworking

private let homeReuseIdentifier = "homeCell"

class WZYHomeCollectionViewController: UICollectionViewController {
    
//    var homeItemArr : NSMutableArray? // 一定要懒加载，不然会出错！！！
    private lazy var homeItemArr: NSMutableArray = NSMutableArray()
    // 懒加载一定要说明animator的类型，有时不能 类型推导（当控制器对象作为属性进行懒加载时不能类型推导）
    private lazy var animator: WZYAnimator = WZYAnimator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
         // 是不是该框架的 download 操作有问题
        let progress = { (progress : NSProgress) in
                print("213")
        };
        
        let completionHandler = { (response:NSURLResponse, url:NSURL?, error:NSError?) in
            print("完成")
        };
        
        let resquest = NSURLRequest(URL: NSURL(string: "http://image2.90e.com/image/1024x768/12764.jpg")!)
 
        
        WZYHTTPTools.shareSessionManager.downloadTaskWithRequest(resquest, progress:progress , destination: nil, completionHandler:completionHandler );
 */
        
        /*
        WZYHTTPTools.shareSessionManager.download("http://image2.90e.com/image/1024x768/12764.jpg", progress: { (progressResult) in
            print("123123")
            print((progressResult?.completedUnitCount)! / (progressResult?.totalUnitCount)!)
            
            }, destination: { (targetPath, response) -> (NSURL) in
//                let fullPath = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true).last?.stringByAppendingString(response?.suggestedFilename) // 如果写成一行，那么就会不停的提示解包，分开写则不会
                
                let path = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true).last
                let fullPath = path?.stringByAppendingString((response?.suggestedFilename)!)
                
                return NSURL(fileURLWithPath: fullPath!)
                
            }) { (response, filePath, errorResult) in
                print(filePath)
        }
        */
        
    
        
        // 请求数据
        loadData(0)
        
    }
    
}

// MARK:- 请求数据
extension WZYHomeCollectionViewController {
    
    private func loadData(offset: Int) {
        let urlString = "http://mobapi.meilishuo.com/2.0/twitter/popular.json"
        let parameters = [
            "offset" : "\(offset)",
            "limit" : "30",
            "access_token" : "b92e0c6fd3ca919d3e7547d446d9a8c2"
        ]
        
        WZYHTTPTools.shareSessionManager.request(.GET, urlString: urlString, parameters: parameters, progress: { (progressResult) in
            
            }, success: { (successResult) in
//            print(successResult)
//                (successResult as! NSDictionary).writeToFile("/Users/wangzhongyao/Desktop/lalala.plist", atomically: true)
                
//                print(self.homeItemArr)
                let itemArr : NSMutableArray = WZYHomeItem.mj_objectArrayWithKeyValuesArray((successResult as! NSDictionary)["data"])
                
                // 要对 homeItemArr 进行懒加载
//                print(itemArr as [AnyObject])
                self.homeItemArr.addObjectsFromArray(itemArr as [AnyObject])
                
                self.collectionView?.reloadData()
                
            }) { (errorResult) in
                print(errorResult)
        }
    }
    
}


// MARK:- collectionView 数据源方法
extension WZYHomeCollectionViewController {
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homeItemArr.count ?? 0
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> WZYHomeCollectionViewCell {
        
        let cell = collectionView .dequeueReusableCellWithReuseIdentifier(homeReuseIdentifier, forIndexPath: indexPath) as! WZYHomeCollectionViewCell
        
        cell.homeItem = homeItemArr[indexPath.item] as? WZYHomeItem
    
        
        if indexPath.item == (homeItemArr.count) - 1 {
            loadData(homeItemArr.count)
        }
        
        return cell
    }
    
}

// MARK:- collectionView 代理方法
extension WZYHomeCollectionViewController {
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let photoBrowserViewController = WZYPhotoBrowserViewController()
        photoBrowserViewController.homeItemArr = homeItemArr
        photoBrowserViewController.indexPath = indexPath
        
        // 设置转场动画delegate对象
        photoBrowserViewController.transitioningDelegate = animator
        animator.indexPath = indexPath
        animator.presentedDelegate = self
        animator.dismissedDelegate = photoBrowserViewController
        
        // modal除了将当前modal出来的控制器的view添加到window上，另外还会将屏幕上的东西移除（消失的时候一片黑，那其实是屏幕的颜色。如果不想这样子，那么执行下面的代码）
        // 让系统不要将原有的View移除掉
        photoBrowserViewController.modalPresentationStyle = .Custom
        
//        photoBrowserViewController.modalTransitionStyle = .PartialCurl
        presentViewController(photoBrowserViewController, animated: true, completion: nil)
    }
    
}


// MARK:- 遵守弹出动画的协议,并且实现协议中的方法
extension WZYHomeCollectionViewController : AnimatorPresentedDelegate {
    func startRect(indexPath: NSIndexPath) -> CGRect {
        // 1.获取cell
        guard let cell = collectionView?.cellForItemAtIndexPath(indexPath) else {
            return CGRectZero
        }
        
        // 2.获取cell的frame
        let cellFrame = cell.frame
        
        // 3.将cell的frame转化成相对屏幕的坐标(window)
        let startRect = collectionView!.convertRect(cellFrame, toCoordinateSpace: UIApplication.sharedApplication().keyWindow!)
        
        return startRect
    }
    
    func endRect(indexPath: NSIndexPath) -> CGRect {
        // 1.获取cell
        guard let cell = collectionView?.cellForItemAtIndexPath(indexPath) as? WZYHomeCollectionViewCell else {
            return CGRectZero
        }
        
        // 2.获取image
        guard let image = cell.imageView.image else {
            return CGRectZero
        }
        
        // 3.计算image放大之后的frame
        return calculateBigFrameWithSmallImage(image)
    }
    
    func imageView(indexPath: NSIndexPath) -> UIImageView {
        // 0.创建UIImageView对象
        let imageView = UIImageView()
        
        // 1.获取cell
        guard let cell = collectionView?.cellForItemAtIndexPath(indexPath) as? WZYHomeCollectionViewCell else {
            return imageView
        }
        
        // 2.获取image
        guard let image = cell.imageView.image else {
            return imageView
        }
        
        // 3.设置imageView的属性
        imageView.image = image
        imageView.contentMode = .ScaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }
}








