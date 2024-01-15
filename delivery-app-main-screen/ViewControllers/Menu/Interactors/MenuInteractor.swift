//
//  MenuInteractor.swift
//  delivery-app-main-screen
//
//  Created by Aisultan Askarov on 14.01.2024.
//

import UIKit

protocol MenuInteractorProtocol {
    func getCities() -> [UIAction]
    func didSelectCity(_ city: String)
    func getSelectedCity() -> String?
    func setSelectedCity(_ city: String)
}

public enum Cities: String {
    case Moscow = "Москва"
    case StPetersburg = "Санкт-Петербург"
    case Novosibirsk = "Новосибирск"
    case Yekaterinburg = "Екатеринбург"
    case NizhnyNovgorod = "Нижний Новгород"
    case Kazan = "Казань"
    case Chelyabinsk = "Челябинск"
    case Omsk = "Омск"
    case Samara = "Самара"
    case RostovOnDon = "Ростов-на-Дону"
}

class MenuInteractor: MenuInteractorProtocol {
    var presenter: MenuPresenterProtocol?
    
    func getCities() -> [UIAction] {
        return [
            .init(title: Cities.Moscow.rawValue) { [weak self] _ in self?.didSelectCity(Cities.Moscow.rawValue) },
            .init(title: Cities.StPetersburg.rawValue) { [weak self] _ in self?.didSelectCity(Cities.StPetersburg.rawValue) },
            .init(title: Cities.Novosibirsk.rawValue) { [weak self] _ in self?.didSelectCity(Cities.Novosibirsk.rawValue) },
            .init(title: Cities.Yekaterinburg.rawValue) { [weak self] _ in self?.didSelectCity(Cities.Yekaterinburg.rawValue) },
            .init(title: Cities.NizhnyNovgorod.rawValue) { [weak self] _ in self?.didSelectCity(Cities.NizhnyNovgorod.rawValue) },
            .init(title: Cities.Kazan.rawValue) { [weak self] _ in self?.didSelectCity(Cities.Kazan.rawValue) },
            .init(title: Cities.Chelyabinsk.rawValue) { [weak self] _ in self?.didSelectCity(Cities.Chelyabinsk.rawValue) },
            .init(title: Cities.Omsk.rawValue) { [weak self] _ in self?.didSelectCity(Cities.Omsk.rawValue) },
            .init(title: Cities.Samara.rawValue) { [weak self] _ in self?.didSelectCity(Cities.Samara.rawValue) },
            .init(title: Cities.RostovOnDon.rawValue) { [weak self] _ in self?.didSelectCity(Cities.RostovOnDon.rawValue) },
        ]
    }
    
    func didSelectCity(_ city: String) {
        presenter?.updateCityLabel(city)
        setSelectedCity(city)
    }
    
    func getSelectedCity() -> String? {
        return UserDefaults.standard.string(forKey: "selectedCity")
    }
    
    func setSelectedCity(_ city: String) {
        UserDefaults.standard.set(city, forKey: "selectedCity")
    }
}

