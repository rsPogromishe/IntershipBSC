//
//  LoadingView.swift
//  Notes(Internship)
//
//  Created by Снытин Ростислав on 31.05.2022.
//

import UIKit

class LoadingView: UIView {
    static var loadingView: UIView?

    private let contentView = UIView()
    private let activityIndicator = UIActivityIndicatorView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLoadingView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLoadingView()
    }

    deinit {
        print("LoadingView deinited")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = bounds
    }

    private func setupLoadingView() {
        contentView.backgroundColor = UIColor(named: Constant.screenBackgroundColor)
        activityIndicator.style = .large

        contentView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        contentView.addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            contentView.leftAnchor.constraint(equalTo: leftAnchor),
            contentView.rightAnchor.constraint(equalTo: rightAnchor),
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),

            activityIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    class func startAnimating(mainView: UIView) {
        let view = LoadingView()
        view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        mainView.addSubview(view)
        view.layer.zPosition = 1
        view.isHidden = false
        view.activityIndicator.startAnimating()
        self.loadingView = view
    }

    class func stopAnimating() {
        loadingView?.removeFromSuperview()
        loadingView = nil
    }
}
