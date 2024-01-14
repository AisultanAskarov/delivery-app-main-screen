//
//  MenuModuleAssembler.swift
//  delivery-app-main-screen
//
//  Created by Aisultan Askarov on 14.01.2024.
//

import UIKit

class MenuModuleAssembler {
    static func assembleModule() -> UIViewController {
        // Create the VIPER components
        let view = MenuViewController()
        let interactor = MenuInteractor()
        let presenter = MenuPresenter(view: view, interactor: interactor, router: MenuRouter(view: view))
        
        // Connect the VIPER components
        view.presenter = presenter
        interactor.presenter = presenter
        
        return view
    }
}
