//
//  WZYPhotoBrowserCollectionViewCell.swift
//  PhotoBrowser
//
//  Created by 王中尧 on 16/8/18.
//  Copyright © 2016年 wzy. All rights reserved.
//

import UIKit

import SDWebImage

class WZYPhotoBrowserCollectionViewCell: UICollectionViewCell {
    
    // 对imageView属性进行懒加载
    lazy var imageView: UIImageView = UIImageView()
    
    var shop: WZYHomeItem? {
        didSet {
            // 必须进行是否为nil的判断
            guard let shop = shop else {
                return
            }
            
            // 从磁盘缓存中（沙盒中）获取我们在沙盒中存放的值，这样就不用重复下载了，因为我们在homeCell设置image的时候已经用SDWebImage下载过一次了，而那次下载也将小图存放到了硬盘缓存中
            var smallImage = SDWebImageManager.sharedManager().imageCache.imageFromDiskCacheForKey(shop.q_pic_url)
            
            // 必须进行是否为nil的判断
            if smallImage == nil {
                smallImage = UIImage(named: "empty_picture")
            }
            
            // 根据小图的宽高比计算出弹出大图的宽高比（也就是显示图片的imageView的宽高比）
//            imageView.frame = calculateBigFrameWithSmallImage(smallImage)
            
            // 设置高清大图
            imageView.sd_setImageWithURL(NSURL(string: shop.z_pic_url), placeholderImage: smallImage) { (image: UIImage!, error: NSError!, type: SDImageCacheType, url: NSURL!) in
                
                // 根据小图的宽高比计算出弹出大图的宽高比（也就是显示图片的imageView的宽高比）
                self.imageView.frame = calculateBigFrameWithSmallImage(smallImage)
            }
            
        }
    }
    
    // MARK: - 重写构造函数（我们一般都是在该方法中进行添加UI子控件）
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    // required : 如果一个构造函数前有required,那么重写了其他构造函数时,那么该构造函数也必须被重写
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension WZYPhotoBrowserCollectionViewCell {
    private func setupUI() {
        // 只有一个子控件（虽然代码不多，但是也要按照这种格式抽取来写）
        contentView.addSubview(imageView)
    }
}

