//
//  YYRefreshView.swift
//  Swift3Sum
//
//  Created by sihuan on 2016/8/28.
//  Copyright © 2016年 huan. All rights reserved.
//

import UIKit

// MARK: - Public
extension YYRefreshView: YYRefreshViewProtocol {
    
    public func show(_ state: YYRefreshState, config: YYRefreshConfig, animated: Bool) {
        var action: (() -> Void)?
        var text: String?
        switch state {
        case .idle:
            action = {
                self.imageView.transform = CGAffineTransform.identity
            }
            refreshingView.stopAnimating()
            imageView.isHidden = false
            text = config.textIdle
        case .ready:
            action = {
                self.imageView.transform = CGAffineTransform(rotationAngle: degreesToRadians(180))
            }
            text = config.textReady
        case .refreshing:
            action = {
                self.imageView.transform = CGAffineTransform.identity
            }
            refreshingView.startAnimating()
            imageView.isHidden = true
            text = config.textRefreshing
        }
        
        setText(text)
        if let action = action {
            if animated {
                UIView.animate(withDuration: config.animationDurationSlow, animations: action)
            } else {
                action()
            }
        }
    }
}


public class YYRefreshView: UIView {
    
    // MARK: - Const
    let imageViewMargin: CGFloat = 5
    let imageViewWidth = 16
    let imageDown = "yy_arrow_down.png"
    let imageUp = "yy_arrow_up.png"
    
    // MARK: - Property
    var position: YYRefreshPosition
    
    lazy var imageView: UIImageView = {
        var imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.imageViewWidth, height: self.imageViewWidth))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var textLabel: UILabel = {
        var label = UILabel(frame: CGRect.zero)
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = UIColor(white: 0.4, alpha: 1.0)
        label.textAlignment = .center
        label.backgroundColor = UIColor.clear
        return label
    }()
    
    lazy var refreshingView: UIActivityIndicatorView = {
        var refreshingView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        refreshingView.hidesWhenStopped = true
        return refreshingView
    }()
    
    // MARK: - Initialization
    init(position: YYRefreshPosition) {
        self.position = position
        super.init(frame: CGRect.zero)
        setupUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        addSubview(textLabel)
        addSubview(imageView)
        addSubview(refreshingView)
        
        var imageName = ""
        switch position {
        case .left, .bottom:
            imageName = imageUp
        default:
            imageName = imageDown
        }
        
        imageView.image = imageFromBundle(named: imageName)
    }
}

// MARK: - Override
extension YYRefreshView {
    open override func layoutSubviews() {
        super.layoutSubviews()
        updateLocation()
    }
}

// MARK: - Private
extension YYRefreshView {
    func updateLocation() {
        var center = CGPoint(x: bounds.midX, y: bounds.midY)
        textLabel.sizeToFit()
        textLabel.center = center
        
        center.x -= textLabel.bounds.midX + imageView.bounds.midX + imageViewMargin
        imageView.center = center
        refreshingView.center = center
    }
    
    func setText(_ text: String?) {
        textLabel.text = text
        updateLocation()
    }
}


















