//
//  Colors.swift
//  delivery-app-main-screen
//
//  Created by Aisultan Askarov on 14.01.2024.
//

import UIKit

struct Colors {
    let tabItemActive: UIColor
    let tabItemInActive: UIColor
    let mainBgColor: UIColor
    let navBarBgColor: UIColor
    let tabBarBgColor: UIColor
    let categorySelectedBgColor: UIColor
    let categorySelectedTitleColor: UIColor
    let categoryUnSelectedColor: UIColor

    private static func getColor(named name: String, defaultColor: UIColor) -> UIColor {
        return UIColor(named: name) ?? defaultColor
    }

    init() {
        self.tabItemActive = Colors.getColor(named: "item_active", defaultColor: .systemBlue)
        self.tabItemInActive = Colors.getColor(named: "item_inactive", defaultColor: .systemBlue)
        self.mainBgColor = Colors.getColor(named: "main_bg_color", defaultColor: .systemBlue)
        self.navBarBgColor = Colors.getColor(named: "nav_bar_bg_color", defaultColor: .systemBlue)
        self.tabBarBgColor = Colors.getColor(named: "tab_bar_bg_color", defaultColor: .systemBlue)
        self.categorySelectedBgColor = Colors.getColor(named: "category_selected_bg_color", defaultColor: .systemBlue)
        self.categoryUnSelectedColor = Colors.getColor(named: "category_unselected_color", defaultColor: .systemBlue)
        self.categorySelectedTitleColor = Colors.getColor(named: "category_selected_title_color", defaultColor: .systemBlue)
    }
}
