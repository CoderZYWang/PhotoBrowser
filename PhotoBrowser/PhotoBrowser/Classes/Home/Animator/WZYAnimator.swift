//
//  WZYAnimator.swift
//  PhotoBrowser
//
//  Created by 王中尧 on 16/8/18.
//  Copyright © 2016年 wzy. All rights reserved.
//

import UIKit

// 声明动画弹出的一份协议
protocol AnimatorPresentedDelegate : class {
    // 声明协议中的代理方法（代理方法如果不用optional修饰，那么就必须实现）
    
    // 获得弹出动画开始时的frame（同时也是消失动画的结束frame）
    func startRect(indexPath : NSIndexPath) -> CGRect
    
    // 根据外界传来的indexPath，获得我们展示大图的imageView及其展示的image
    func imageView(indexPath : NSIndexPath) -> UIImageView
    
    // 获得弹出动画结束时的frame（同时也是消失动画的起始frame）
    func endRect(indexPath : NSIndexPath) -> CGRect
}

// 声明动画消失的一份协议
protocol AnimatorDismissedDelegate : class {
    
    // 获得当前显示的大图的image的indexPath
    func getCurrentIndexPath() -> NSIndexPath
    
    // 获得当前imageView
    func getCurrentImageView() -> UIImageView
}

class WZYAnimator: NSObject {
    // 是否弹出（false 时执行 消失动画）
    private var isPresented = true
    // 外界传来的image的indexPath（确定image）
    var indexPath: NSIndexPath?
    
    // 声明一个弹出动画代理对象
    weak var presentedDelegate: AnimatorPresentedDelegate?
    // 声明一个消失动画代理对象
    weak var dismissedDelegate: AnimatorDismissedDelegate?
    
}

/*
 我们在写扩展的时候，扩展一般写一类方法。比如说下面两个对 转场代理 和 转场动画 的扩展，我们要在这两个扩展里面实现相应的方法，所以说实现什么方法就在相应的扩展下遵守该方法的协议就可以了
 */
// MARK: - 遵守转场代理协议，和实现相应的方法
extension WZYAnimator: UIViewControllerTransitioningDelegate {
    
    // 为 弹出控制器 这个操作 做一个动画
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        // 正在弹出操作
        isPresented = true
        
        // 此处是返回一个遵守该动画协议的对象(让这个对象去帮我们完成弹出/消失动画操作)
        return self
    }
    
    // 为 消失控制器 这个操作 做一个动画
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        // 正在消失操作
        isPresented = false
        
        return self
    }
    
}

// MARK: - 遵守转场动画协议，和实现相应的方法
extension WZYAnimator: UIViewControllerAnimatedTransitioning {
    
    // 返回动画执行的时间
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        
        return 1.0
    }
    
    // transitionContext : 转场上下文
    // 作用 : 可以通过上下文获取到弹出的View和消失的View
    // UITransitionContextFromViewKey : 获取消失的View
    // UITransitionContextToViewKey : 获取弹出的View
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        if isPresented {
            
            // 判断代理是否有值
            guard let presentedDelegate = presentedDelegate else {
                return
            }
            // 判断是否有图片
            guard let indexPath = indexPath else {
                return
            }
            
            // 获取弹出的View
            let presentedView = transitionContext.viewForKey(UITransitionContextToViewKey)!
            transitionContext.containerView()?.addSubview(presentedView)
            
            // 修改View alpha值
            presentedView.alpha = 0.0
            transitionContext.containerView()?.backgroundColor = UIColor.blackColor()

            // 获取动画所需要的元素
            // 获取UIImageView（代理对象调用代理方法，返回设置好image的imageView）
            let imageView : UIImageView = presentedDelegate.imageView(indexPath)
            transitionContext.containerView()?.addSubview(imageView)
            
            // 获取起始位置（代理对象调用代理方法，返回弹出时的起始位置，也就是collectionViewCell开始弹出时的位置）
            let startRect : CGRect = presentedDelegate.startRect(indexPath)
            imageView.frame = startRect
            
            // 执行动画
            UIView.animateWithDuration(transitionDuration(transitionContext), animations: {
                // 获取终点位置（代理对象调用代理方法，返回弹出结束时的位置）
                let endRect : CGRect = presentedDelegate.endRect(indexPath)
                imageView.frame = endRect
                print(endRect)
                
            }) { (isFinished : Bool) in
                imageView.removeFromSuperview()
                presentedView.alpha = 1.0
                transitionContext.containerView()?.backgroundColor = UIColor.clearColor()
                // 调用下面的方法，系统会帮忙完成一些 finished 之后需要完成的一些操作
                transitionContext.completeTransition(isFinished)
            }
            
        } else {
            
            // 0.对可选类型进行校验
            guard let dismissedDelegate = dismissedDelegate else {
                return
            }
            
            guard let presentedDelegate = presentedDelegate else {
                return
            }
            
            // 1.获取消失的View
            let dismissedView = transitionContext.viewForKey(UITransitionContextFromViewKey)!
            dismissedView.removeFromSuperview()
            
            // 获取消失动画执行所需的动画的元素
            // 获取最新的indexPath（代理对象调用代理方法）
            let indexPath = dismissedDelegate.getCurrentIndexPath()
            
            // 获取UIImageView对象（代理对象调用代理方法）
            let imageView = dismissedDelegate.getCurrentImageView()
            transitionContext.containerView()?.addSubview(imageView)
            
            // 2.执行动画
            UIView.animateWithDuration(transitionDuration(transitionContext), animations: {
                let endRect = presentedDelegate.startRect(indexPath)
                
                if endRect == CGRectZero {
                    imageView.alpha = 0.0
                } else  {
                    imageView.frame = endRect
                }
                
                }, completion: { (isFinished : Bool) in
                    
                    // 调用下面的方法，系统会帮忙完成一些 finished 之后需要完成的一些操作
                    transitionContext.completeTransition(isFinished)
            })
        }
    }
    
    
}
