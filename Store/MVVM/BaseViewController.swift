//
//  BaseViewController.swift
//  Store
//
//  Created by SCT on 31/05/24.
//

import UIKit

class BaseViewController: UIViewController {
    var loaderView: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    func displayActivityIndicator(onView : UIView) {
        let containerView = UIView.init(frame: onView.bounds)
        containerView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        let activityIndicator = UIActivityIndicatorView.init(style: .whiteLarge)
        activityIndicator.startAnimating()
        activityIndicator.center = containerView.center
        DispatchQueue.main.async {
            containerView.addSubview(activityIndicator)
            onView.addSubview(containerView)
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        loaderView = containerView
    }
    
    func removeActivityIndicator() {
        DispatchQueue.main.async {
            self.loaderView?.removeFromSuperview()
            self.loaderView = nil
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
}
