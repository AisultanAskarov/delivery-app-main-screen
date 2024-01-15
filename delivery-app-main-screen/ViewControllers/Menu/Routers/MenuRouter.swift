//
//  MenuRouter.swift
//  delivery-app-main-screen
//
//  Created by Aisultan Askarov on 14.01.2024.
//

import Foundation

protocol MenuRouterProtocol {
    // Define methods for navigation
}

class MenuRouter: MenuRouterProtocol {
    weak var view: MenuViewController?

    init(view: MenuViewController) {
        self.view = view
    }

    // Implement MenuRouterProtocol methods
    // ...
}
