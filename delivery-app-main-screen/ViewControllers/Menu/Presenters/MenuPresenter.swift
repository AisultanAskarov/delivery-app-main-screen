//
//  MenuPresenter.swift
//  delivery-app-main-screen
//
//  Created by Aisultan Askarov on 14.01.2024.
//

import UIKit

protocol MenuPresenterProtocol: AnyObject {
    var view: MenuViewProtocol? { get set }
    var interactor: MenuInteractorProtocol? { get set }
    var router: MenuRouterProtocol? { get set }

    func getCities() -> [UIAction]
    func getSelectedCity() -> String?
    func didSelectCity(_ city: String)
    func updateCityLabel(_ cityName: String)
    func updateCityLabelWithStoredValue()
    
    func fetchMenuItems()
    func interactorDidFetchMenuItems(with result: Result<[[MenuItemModel]], Error>)
}

class MenuPresenter: MenuPresenterProtocol {
    
    var view: MenuViewProtocol?
    var interactor: MenuInteractorProtocol?
    var router: MenuRouterProtocol?
    
    func didSelectCity(_ city: String) {
        interactor?.didSelectCity(city)
    }
    
    func getCities() -> [UIAction] {
        return interactor?.getCities() ?? []
    }
    
    func getSelectedCity() -> String? {
        return interactor?.getSelectedCity()
    }
    
    func updateCityLabel(_ cityName: String) {
        view?.updateCityLabel(cityName)
    }
    
    func updateCityLabelWithStoredValue() {
        if let selectedCity = getSelectedCity() {
            updateCityLabel(selectedCity)
        }
    }
    
    func fetchMenuItems() {
        interactor?.getMenuItems()
    }
    
    func interactorDidFetchMenuItems(with result: Result<[[MenuItemModel]], Error>) {
        switch result {
        case let .success(items):
            view?.update(with: items)
        case let .failure(error):
            view?.update(with: error.localizedDescription)
        }
    }
}
