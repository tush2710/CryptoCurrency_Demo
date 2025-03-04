//
//  WrappedView.swift
//  EquityGroupTest_TusharZade
//
//  Created by Tushar Zade on 04/03/25.
//

import UIKit

class WrappedView: UIView {

    private(set) var view: UIView!

    init(view: UIView) {
        self.view = view
        super.init(frame: CGRect.zero)
        addSubview(view)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        view.frame = bounds
    }
}
