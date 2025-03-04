//
//  MenuPresentable.swift
//  EquityGroupTest_TusharZade
//
//  Created by Tushar Zade on 03/03/25.
//

import UIKit

protocol MenuPresentable {}


extension MenuPresentable where Self: UIViewController {
    func createMenu(actions: [UIAction], title: String = "Sort By") -> UIMenu {
        return UIMenu(title: title, children: actions)
    }

    func setupMenuButton(
        title: String? = nil,
        image: UIImage? = nil,
        menu: UIMenu,
        in navigationItem: UINavigationItem
    ) {
        let menuButton = UIButton(type: .system)
        if let title {
            menuButton.setTitle(title, for: .normal)
        } else if let image {
            menuButton.setImage(image, for: .normal)
        } else {
            menuButton.setTitle("menu", for: .normal)
        }
        menuButton.menu = menu
        menuButton.tintColor = .white
        menuButton.showsMenuAsPrimaryAction = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: menuButton)
    }
}
