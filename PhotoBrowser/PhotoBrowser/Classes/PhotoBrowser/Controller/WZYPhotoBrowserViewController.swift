//
//  WZYPhotoBrowserViewController.swift
//  PhotoBrowser
//
//  Created by 王中尧 on 16/8/18.
//  Copyright © 2016年 wzy. All rights reserved.
//

import UIKit

private let photoBrowserID = "photoBrowser"

class WZYPhotoBrowserViewController: UIViewController {
    
    var homeItemArr: NSMutableArray?
    var indexPath: NSIndexPath?
    
    // 将我们的collectionView作为一个属性记录，方便其他的地方修改它（frame先传一个zero即可）
    private var collectionView: UICollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: WZYPhotoBrowserCollectionViewLayout())

    override func viewDidLoad() {
        
        // 让控制器的view的宽度 +15
        view.frame.size.width += 15
        
//        view.backgroundColor = UIColor.redColor()
        
        setupUI()
        
        // 滚动到正确的位置
        collectionView.scrollToItemAtIndexPath(indexPath!, atScrollPosition: .CenteredHorizontally, animated: false)
        
    }
    
}

extension WZYPhotoBrowserViewController {
    
    private func setupUI() {
    
        setupCollectionView()
        setup2Btn()
        
    }
    
    private func setupCollectionView() {
        
//        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: WZYPhotoBrowserCollectionViewLayout())
        // 由于我们属性中使用了懒加载初始化collectionView，所以说在这里只需要修改collectionView的frame即可
        collectionView.frame = view.bounds
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerClass(WZYPhotoBrowserCollectionViewCell.self, forCellWithReuseIdentifier: photoBrowserID)
        
        view.addSubview(collectionView)
    }
    
    private func setup2Btn() {
        // 01 创建 保存/ 关闭 按钮
        let saveBtn = UIButton(title: "保 存", bgColor: UIColor.darkGrayColor(), fontSize: 14.0)
        let closeBtn = UIButton(title: "关 闭", bgColor: UIColor.darkGrayColor(), fontSize: 14.0)
        
        // 02 设置按钮的frame
        let margin: CGFloat = 10
        
        let btnW: CGFloat = 90
        let btnH: CGFloat = 35
        
        let closeBtnX = margin
        let saveBtnX = UIScreen.mainScreen().bounds.width - margin - btnW
        
        let btnY = UIScreen.mainScreen().bounds.height - margin - btnH
        
        saveBtn.frame = CGRectMake(saveBtnX, btnY, btnW, btnH)
        // 我们更建议使用下面这种方式去初始化frame，因为上面的frame写法是 OC 的
        closeBtn.frame = CGRect(x: closeBtnX, y: btnY, width: btnW, height: btnH)
        
        // 03 添加点击监听函数
        saveBtn.addTarget(self, action: #selector(WZYPhotoBrowserViewController.saveBtnClick), forControlEvents: .TouchUpInside)
        closeBtn.addTarget(self, action: #selector(WZYPhotoBrowserViewController.closeBtnClick), forControlEvents: .TouchUpInside)
        
        // 04 添加btn到view上
        view.addSubview(saveBtn)
        view.addSubview(closeBtn)
    }
    
}

// MARK: - 监听按钮点击函数
extension WZYPhotoBrowserViewController {
    @objc private func saveBtnClick() {
        let cell = collectionView.visibleCells().first as! WZYPhotoBrowserCollectionViewCell
//        let showImage = cell.imageView.image // 肯定不能在一个函数里面定义了两个同名的属性啊
        
        guard let showImage = cell.imageView.image else {
            return
        }
        
        UIImageWriteToSavedPhotosAlbum(showImage, nil, nil, nil)
    }
    
    @objc private func closeBtnClick() {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

// MARK: - 数据源
extension WZYPhotoBrowserViewController: UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // ?? : 系统先判断前面的可选链是否有值, 如果有值,解包并且获取对应的类型. 如果没有值直接去后面的值
        return homeItemArr?.count ?? 0
    }
    
    // 注意一点哈（方法名别改，返回值就是UICollectionViewCell。不会自动识别返回值的cell的类型，需要 as! 强转，并且肯定有值）
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(photoBrowserID, forIndexPath: indexPath) as! WZYPhotoBrowserCollectionViewCell
        
        let shop = homeItemArr![indexPath.item]
        cell.shop = shop as? WZYHomeItem
//        cell.backgroundColor = indexPath.item % 2 == 0 ? UIColor.blueColor() : UIColor.greenColor()
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension WZYPhotoBrowserViewController: UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        closeBtnClick()
    }
}


// MARK: - 遵守动画的消息协议,并且实现协议中的方法
extension WZYPhotoBrowserViewController : AnimatorDismissedDelegate {
    func getCurrentIndexPath() -> NSIndexPath {
        // 1.获取在屏幕中显示的cell
        let cell = collectionView.visibleCells().first
        
        // 2.获取cell对应的indexPath
        let indexPath = collectionView.indexPathForCell(cell!)!
        
        return indexPath
    }
    
    func getCurrentImageView() -> UIImageView {
        // 1.创建UIImageView
        let imageView = UIImageView()
        
        // 2.设置imageView属性
        let cell = collectionView.visibleCells()[0] as! WZYPhotoBrowserCollectionViewCell
        imageView.image = cell.imageView.image
        imageView.frame = calculateBigFrameWithSmallImage(imageView.image!)
        imageView.contentMode = .ScaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }
}







