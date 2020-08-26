//
//  YYRefreshView.swift
//  Swift3Sum
//
//  Created by sihuan on 2016/8/28.
//  Copyright © 2016年 huan. All rights reserved.
//

import UIKit

extension YYRefresh {
    public final class DefaultView: UIView {
        // MARK: - Const

        let imageViewMargin: CGFloat = 5
        let imageViewWidth = 16
        let imageDown = "yy_arrow_down.png"
        let imageUp = "yy_arrow_up.png"

        // MARK: - Property

        let position: YYRefresh.Position

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
            var style = UIActivityIndicatorView.Style.gray
            if #available(iOS 13.0, *) {
                style = UIActivityIndicatorView.Style.medium
            }
            var refreshingView = UIActivityIndicatorView(style: style)
            refreshingView.hidesWhenStopped = true
            return refreshingView
        }()

        // MARK: - Initialization

        init(position: YYRefresh.Position) {
            self.position = position
            super.init(frame: CGRect.zero)
            setupUI()
        }

        public required init?(coder _: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        public override func layoutSubviews() {
            super.layoutSubviews()
            guard let superview = superview else { return }
            frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: superview.bounds.width, height: frame.height)
            updateLocation()
        }

        private func setupUI() {
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

            imageView.image = YYRefresh.imageFromBundle(named: imageName)
        }
    }
}

extension YYRefresh.DefaultView: YYRefreshView {
    ///
    public func show(_ state: YYRefresh.State, config: YYRefresh.Config, animated: Bool) {
        var action: (() -> Void)?
        let text: String
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
                self.imageView.transform = CGAffineTransform(rotationAngle: YYRefresh.degreesToRadians(180))
            }
            text = config.textReady
        case .refreshing:
            action = {
                self.imageView.transform = CGAffineTransform.identity
            }
            refreshingView.startAnimating()
            imageView.isHidden = true
            text = config.textRefreshing
        case .noMore:
            imageView.isHidden = true
            text = config.textNoMore
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

// MARK: - Private

private extension YYRefresh.DefaultView {
    func updateLocation() {
        var center = CGPoint(x: bounds.midX, y: bounds.midY)
        textLabel.sizeToFit()
        textLabel.center = center

        if !textLabel.isHidden {
            center.x -= textLabel.bounds.midX + imageView.bounds.midX + imageViewMargin
        }

        imageView.center = center
        refreshingView.center = center
    }

    func setText(_ text: String?) {
        textLabel.text = text
        textLabel.isHidden = (text?.isEmpty) ?? true
        if textLabel.isHidden {
            imageView.isHidden = true
        }
        updateLocation()
    }
}
