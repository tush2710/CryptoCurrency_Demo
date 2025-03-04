//
//  SwiftUIAdapter.swift
//  EquityGroupTest_TusharZade
//
//  Created by Tushar Zade on 04/03/25.
//

import SwiftUI

class SwiftUIAdapter<Content> where Content : View {

    private(set) var view: Content!
    weak private(set) var parent: UIViewController!
    private(set) var uiView : WrappedView
    private var hostingController: UIHostingController<Content>

    init(view: Content, parent: UIViewController) {
        self.view = view
        self.parent = parent
        hostingController = UIHostingController(rootView: view)
        parent.addChild(hostingController)
        hostingController.didMove(toParent: parent)
        uiView = WrappedView(view: hostingController.view)
    }

    deinit {
        hostingController.removeFromParent()
        hostingController.didMove(toParent: nil)
    }

}
