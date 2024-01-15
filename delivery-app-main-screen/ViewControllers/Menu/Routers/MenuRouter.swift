//
//  MenuRouter.swift
//  delivery-app-main-screen
//
//  Created by Aisultan Askarov on 14.01.2024.
//

import UIKit

typealias EntryPoint = MenuViewProtocol & UIViewController

protocol MenuRouterProtocol {
    var entry: EntryPoint? { get }
    static func start() -> MenuRouterProtocol
}

class MenuRouter: MenuRouterProtocol {
    var entry: EntryPoint?
    
    static func start() -> MenuRouterProtocol {
        let router = MenuRouter()
        let decoder = JSONDecoder()
        
        let view: MenuViewProtocol = MenuViewController()
        let presenter: MenuPresenterProtocol = MenuPresenter()
        var interactor: MenuInteractorProtocol = MenuInteractor()
        let itemsNetworkService: MenuItemsNetworkService = MenuItemsNetworkService(jsonDecoder: decoder)
        
        view.presenter = presenter
        
        interactor.presenter = presenter
        interactor.itemsNetworkService = itemsNetworkService
        
        presenter.router = router
        presenter.view = view
        presenter.interactor = interactor

        router.entry = view as? EntryPoint
        
        return router
    }
    
}
