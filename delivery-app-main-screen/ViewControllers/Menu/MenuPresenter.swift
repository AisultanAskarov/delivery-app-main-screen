//
//  MenuPresenter.swift
//  delivery-app-main-screen
//
//  Created by Aisultan Askarov on 14.01.2024.
//

import UIKit

protocol MenuPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didSelectCity(_ city: String)
    func setupNavigationBar()
    func getSelectedCity() -> String?
    func updateCityLabel(_ cityName: String)
}

class MenuPresenter: MenuPresenterProtocol {
    weak var view: MenuViewProtocol?
    var interactor: MenuInteractorProtocol
    var router: MenuRouterProtocol

    private var cityOptionButton = UIBarButtonItem()
    private var citiesMenu: UIMenu?
    private var customItem: UIBarButtonItem?
    private var cityLabel: UILabel?

    init(view: MenuViewProtocol, interactor: MenuInteractorProtocol, router: MenuRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.cityLabel = createCityLabel()
    }

    func viewDidLoad() {
        setupNavigationBar()
    }

    func setupNavigationBar() {
        customItem = UIBarButtonItem(customView: createCustomNavBarItem())
        view?.configureNavigationBar(with: customItem ?? UIBarButtonItem())
        updateCityLabelWithStoredValue()
    }

    func didSelectCity(_ city: String) {
        interactor.didSelectCity(city)
    }

    func getSelectedCity() -> String? {
        return interactor.getSelectedCity()
    }

    func updateCityLabel(_ cityName: String) {
        cityLabel?.text = cityName
    }

    private func updateCityLabelWithStoredValue() {
        if let selectedCity = getSelectedCity() {
            updateCityLabel(selectedCity)
        }
    }

    private func createCustomNavBarItem() -> UIView {
        let customView = UIView()
        guard let label = cityLabel else { return customView }
        let imageView = createChevronDownImageView()
        let button = createCitiesMenuButton()

        customView.addSubview(label)
        customView.addSubview(imageView)
        customView.addSubview(button)

        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: customView.leadingAnchor),
            label.centerYAnchor.constraint(equalTo: customView.centerYAnchor),

            imageView.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 7.5),
            imageView.trailingAnchor.constraint(equalTo: customView.trailingAnchor),
            imageView.centerYAnchor.constraint(equalTo: customView.centerYAnchor),

            button.leadingAnchor.constraint(equalTo: customView.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: customView.trailingAnchor),
            button.topAnchor.constraint(equalTo: customView.topAnchor),
            button.bottomAnchor.constraint(equalTo: customView.bottomAnchor)
        ])

        return customView
    }

    private func createCityLabel() -> UILabel {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 17.0, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

    private func createChevronDownImageView() -> UIImageView {
        let imageView = UIImageView(image: UIImage(systemName: "chevron.down", withConfiguration: UIImage.SymbolConfiguration(pointSize: 17.0)))
        imageView.tintColor = .black
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }

    private func createCitiesMenuButton() -> UIButton {
        let button = UIButton()
        button.showsMenuAsPrimaryAction = true
        let selectedCity = getSelectedCity()
        
        var cityActions: [UIAction] = interactor.getCities().map { cityAction in
            cityAction.state = cityAction.title == selectedCity ? .on : .off
            return cityAction
        }
        citiesMenu = UIMenu(options: [.displayInline, .singleSelection], children: cityActions)
        button.menu = citiesMenu
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
}
