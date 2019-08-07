//
//  BottomCard.swift
//  RealmToDoApp
//
//  Created by Spencer Hanley on 2019-08-04.
//  Copyright © 2019 Hanley Solid Solutions. All rights reserved.
//

import Foundation
import UIKit

class BottomCard: UIStoryboardSegue {
    private var selfRetainer: BottomCard? = nil
    
    override func perform() {
        destination.transitioningDelegate = self
        selfRetainer = self
        destination.modalPresentationStyle = .overCurrentContext
        source.present(destination, animated: true, completion: nil)
    }
    
    
}

extension BottomCard: UIViewControllerTransitioningDelegate {
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return Presenter()
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        selfRetainer = nil
        return Dismisser()
    }
}

private class Presenter: NSObject, UIViewControllerAnimatedTransitioning {
    var source:UIViewController!
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView
        let toView = transitionContext.view(forKey: .to)!
        let fromView = transitionContext.viewController(forKey: .from)!.view!
        let toViewController = transitionContext.viewController(forKey: .to)!
        let blackView = UIView(frame: fromView.frame)
        
        do {
            
            blackView.backgroundColor = .black
            blackView.alpha = 0
            fromView.addSubview(blackView)
            toView.translatesAutoresizingMaskIntoConstraints = false
            container.addSubview(toView)
            
            let bottom = max(20 - toView.safeAreaInsets.bottom, 0)
            container.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: toView.bottomAnchor, constant: bottom).isActive = true
            container.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: toView.leadingAnchor, constant: -20).isActive = true
            container.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: toView.trailingAnchor, constant: 20).isActive = true
            
            if toViewController.preferredContentSize.height > 0 {
                toView.heightAnchor.constraint(equalToConstant: toViewController.preferredContentSize.height).isActive = true
            }
        }
        
        do {
            toView.layer.masksToBounds = true
            toView.layer.cornerRadius = 20
        }
        
        do {
            container.layoutIfNeeded()
            
            let originalOriginY = toView.frame.origin.y
            toView.frame.origin.y += container.frame.height - toView.frame.minY
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
                toView.frame.origin.y = originalOriginY
                blackView.alpha = 0.7
            }) { (completed) in
                transitionContext.completeTransition(completed)
            }
        }
    }
}

private class Dismisser: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.2
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView
        let fromView = transitionContext.view(forKey: .from)!
        let toView = transitionContext.viewController(forKey: .to)!.view!
        UIView.animate(withDuration: 0.2, animations: {
            toView.subviews.last?.alpha = 0
            fromView.frame.origin.y += container.frame.height - fromView.frame.minY
        }) { (completed) in
            toView.subviews.last?.removeFromSuperview()
            transitionContext.completeTransition(completed)
        }
    }
}

