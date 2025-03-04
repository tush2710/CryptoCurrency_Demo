//
//  AppAppearance.swift
//  EquityGroupTest_TusharZade
//
//  Created by Tushar Zade on 01/03/25.
//

import UIKit

final class AppAppearance {
    static func setupAppearance(){
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.backgroundColor = #colorLiteral(red: 0.0834152922, green: 0.0834152922, blue: 0.0834152922, alpha: 1)
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
}

extension UINavigationController {
    @objc override open var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
