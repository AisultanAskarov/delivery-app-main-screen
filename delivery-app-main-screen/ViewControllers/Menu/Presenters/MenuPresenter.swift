//
//  MenuPresenter.swift
//  delivery-app-main-screen
//
//  Created by Aisultan Askarov on 14.01.2024.
//

import UIKit

protocol MenuPresenterProtocol: AnyObject {
    func getCities() -> [UIAction]
    func getSelectedCity() -> String?
    func didSelectCity(_ city: String)
    func updateCityLabel(_ cityName: String)
    func updateCityLabelWithStoredValue()
}

class MenuPresenter: MenuPresenterProtocol {
    weak var view: MenuViewProtocol?
    var interactor: MenuInteractorProtocol
    var router: MenuRouterProtocol
    
    init(view: MenuViewProtocol, interactor: MenuInteractorProtocol, router: MenuRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    func didSelectCity(_ city: String) {
        interactor.didSelectCity(city)
    }
    
    func getCities() -> [UIAction] {
        return interactor.getCities()
    }
    
    func getSelectedCity() -> String? {
        return interactor.getSelectedCity()
    }
    
    func updateCityLabel(_ cityName: String) {
        view?.updateCityLabel(cityName)
    }
    
    func updateCityLabelWithStoredValue() {
        if let selectedCity = getSelectedCity() {
            updateCityLabel(selectedCity)
        }
    }
}
