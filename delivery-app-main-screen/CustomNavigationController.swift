//
//  CustomNavigationController.swift
//  delivery-app-main-screen
//
//  Created by Aisultan Askarov on 14.01.2024.
//

import UIKit

final class CustomNavigationController: UINavigationController {
    private let colors = Colors()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set navigation bar appearance
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = colors.mainBgColor
        appearance.shadowColor = .clear
        appearance.shadowImage = UIImage()
        appearance.backgroundImage = UIImage()
        
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        
        // Other configurations
        navigationBar.isTranslucent = false
        navigationBar.barStyle = .default
        
        setNeedsStatusBarAppearanceUpdate()
    }
}
