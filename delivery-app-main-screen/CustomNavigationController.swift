//
//  CustomNavigationController.swift
//  delivery-app-main-screen
//
//  Created by Aisultan Askarov on 14.01.2024.
//

import UIKit

class CustomNavigationController: UINavigationController {
    private let colors = Colors()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.barTintColor = colors.navBarBgColor
        navigationBar.shadowImage = UIImage()
        navigationBar.setBackgroundImage(UIImage(), for: .default)
    }
}
