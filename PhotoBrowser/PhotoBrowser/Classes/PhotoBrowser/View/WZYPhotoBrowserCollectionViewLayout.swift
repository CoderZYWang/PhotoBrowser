//
//  WZYPhotoBrowserCollectionViewLayout.swift
//  PhotoBrowser
//
//  Created by 王中尧 on 16/8/18.
//  Copyright © 2016年 wzy. All rights reserved.
//

import UIKit

class WZYPhotoBrowserCollectionViewLayout: UICollectionViewFlowLayout {
    override func prepareLayout() {
        super.prepareLayout()
        
        itemSize = (collectionView?.bounds.size)!
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        scrollDirection = .Horizontal
        
        // 虽然说下面两个属性是属于collectionView的，但是由于我们在布局参数的prepareLayout方法内能拿到当前的collectionView，所以说还是在这里设置比较合适
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.pagingEnabled = true
    }
}
