//
//  UITableViewController+Extension.swift
//  EquityGroupTest_TusharZade
//
//  Created by Tushar Zade on 03/03/25.
//

import UIKit

extension UITableView {

    func makeActivityIndicator(size: CGSize) -> UIActivityIndicatorView {
        let style: UIActivityIndicatorView.Style
        if #available(iOS 12.0, *) {
            if self.traitCollection.userInterfaceStyle == .dark {
                style = .white
            } else {
                style = .gray
            }
        } else {
            style = .gray
        }

        let activityIndicator = UIActivityIndicatorView(style: style)
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        activityIndicator.frame = .init(origin: .zero, size: size)

        return activityIndicator
    }
}

