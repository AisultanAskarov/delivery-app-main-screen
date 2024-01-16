//
//  MenuViewController.swift
//  delivery-app-main-screen
//
//  Created by Aisultan Askarov on 14.01.2024.
//

import UIKit

protocol MenuViewProtocol: AnyObject {
    var presenter: MenuPresenterProtocol? { get set }
    func updateCityLabel(_ cityName: String)
    func update(with items: ItemsResponse)
    func update(with error: String)
}

protocol MenuViewHeaderViewCoordinating: AnyObject {
  func categoryButtonTapped(category: String)
}

class MenuViewController: UIViewController, MenuViewProtocol {
    
    var presenter: MenuPresenterProtocol?
    
    private let colors = Colors()
    private let categoriesList: [String] =  FoodCategory.allCases.map { $0.listValue }
    
    private let foodItemCellId = "FoodItemCell"
    
    private var menuItems: [ItemsResponse] = []
    
    private var cityOptionButton = UIBarButtonItem()
    private var citiesMenu: UIMenu?
    private var customItem: UIBarButtonItem?
    private var cityLabel: UILabel?
    
    private var foodItemsTableView = UITableView()
    private var headerViewHeight: CGFloat = 201.0
    
    private var headerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20.0
        view.clipsToBounds = true
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        presenter?.fetchMenuItems()
    }
    
    //MARK: - Protocol Methods
    func update(with items: ItemsResponse) {
        DispatchQueue.main.async {
            self.menuItems.append(items)
            self.foodItemsTableView.reloadData()
        }
    }
    
    func update(with error: String) {
        
    }
    
    func updateCityLabel(_ cityName: String) {
        self.cityLabel?.text = cityName
    }
    
}

//MARK: - Layout Functions
private extension MenuViewController {
    private func configureViews() {
        view.backgroundColor = colors.mainBgColor
        setupNavigationBar()
        layoutHeaderView()
        setupFoodItemsTableView()
        view.bringSubviewToFront(headerView)
    }
    
    private func setupFoodItemsTableView() {
        foodItemsTableView = UITableView(frame: CGRect.zero, style: .grouped)
        foodItemsTableView.delegate = self
        foodItemsTableView.dataSource = self
        foodItemsTableView.bounces = false
        foodItemsTableView.showsVerticalScrollIndicator = false
        foodItemsTableView.separatorStyle = .none
        foodItemsTableView.backgroundColor = .clear
        foodItemsTableView.contentInset = UIEdgeInsets(top: headerViewHeight, left: 0.0, bottom: 0.0, right: 0.0)
        foodItemsTableView.contentOffset = CGPoint(x: 0, y: -(headerViewHeight))
        foodItemsTableView.register(FoodItemCell.self, forCellReuseIdentifier: foodItemCellId)
        view.addSubview(backgroundView)
        view.addSubview(foodItemsTableView)
        
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: headerViewHeight),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: headerViewHeight)
        ])
        
        foodItemsTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            foodItemsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            foodItemsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            foodItemsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            foodItemsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func layoutHeaderView() {
        let tableHeaderView = MenuVCHeaderView(categories: categoriesList)
        tableHeaderView.delegate = self
        tableHeaderView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: headerViewHeight - 1)
        headerView = tableHeaderView
        view.addSubview(headerView)
    }
    
    func setupNavigationBar() {
        cityLabel = createCityLabel()
        customItem = UIBarButtonItem(customView: createCustomNavBarItem())
        presenter?.updateCityLabelWithStoredValue()
        self.navigationController?.navigationBar.topItem?.leftBarButtonItem = customItem
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
        let selectedCity = presenter?.getSelectedCity()
        guard let cities = presenter?.getCities() else { return button }
        
        let cityActions: [UIAction] = cities.map { cityAction in
            cityAction.state = cityAction.title == selectedCity ? .on : .off
            return cityAction
        }
        
        citiesMenu = UIMenu(options: [.displayInline, .singleSelection], children: cityActions)
        button.menu = citiesMenu
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
}

extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2//self.menuItems.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5//menuItems[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: foodItemCellId, for: indexPath) as! FoodItemCell
//        cell.itemsNameLabel.text = menuItems[indexPath.section].items[indexPath.row].title
        cell.selectionStyle = .none

        let separatorHeight: CGFloat = 1.0
        let separatorView = UIView(frame: CGRect(x: 0, y: cell.bounds.height - separatorHeight, width: cell.bounds.width, height: separatorHeight))
        separatorView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        cell.addSubview(separatorView)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
        
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 156 }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool { return false }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        let headerViewNavigationBarPinHeight: CGFloat = -70
        
        if offset >= -headerViewHeight {
            var rect = headerView.frame
            rect.origin.y = -headerViewHeight - (offset > headerViewNavigationBarPinHeight ? headerViewNavigationBarPinHeight : offset)
            headerView.frame = rect
        }
        
        if offset <= -52 {
            var backgroundRect = backgroundView.frame
            backgroundRect.origin.y = -offset
            
            backgroundView.frame = backgroundRect
        } else {
            var backgroundRect = backgroundView.frame
            backgroundRect.origin.y = 52
            
            backgroundView.frame = backgroundRect
        }
        
        toggleHeaderViewShadow(offset: offset, navigationBarPinHeight: headerViewNavigationBarPinHeight)
    }
    
    private func toggleHeaderViewShadow(offset: CGFloat, navigationBarPinHeight: CGFloat) {
        if offset > navigationBarPinHeight {
            headerView.layer.shadowColor = UIColor.black.cgColor
            headerView.layer.shadowOpacity = 0.1
            headerView.layer.shadowRadius = 5.0
            headerView.layer.shadowOffset = CGSize(width: 0, height: 4)
            headerView.layer.shouldRasterize = true
            headerView.layer.rasterizationScale = UIScreen.main.scale
        } else {
            headerView.layer.shadowOpacity = 0
            headerView.layer.shadowRadius = 0.0
        }
    }
}

extension MenuViewController: MenuViewHeaderViewCoordinating {
    func categoryButtonTapped(category: String) {
        
    }
}
