//
//  NavigationController.swift
//  delivery-app-main-screen
//
//  Created by Aisultan Askarov on 14.01.2024.
//

import UIKit

final class NavigationController: UINavigationController {
    private let colors = Colors()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = colors.mainBgColor
        appearance.shadowColor = .clear
        appearance.shadowImage = UIImage()
        appearance.backgroundImage = UIImage()
        
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.isTranslucent = false
        navigationBar.barStyle = .default
        
        setNeedsStatusBarAppearanceUpdate()
    }
}
