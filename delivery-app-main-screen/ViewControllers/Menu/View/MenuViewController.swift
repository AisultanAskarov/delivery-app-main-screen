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
    func update(with items: [[MenuItemModel]])
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
    
    private var menuItems: [[MenuItemModel]] = []
    
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

    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.tintColor = .black
        indicator.backgroundColor = .clear
        indicator.hidesWhenStopped = true
        
        return indicator
    }()
    
    private lazy var refreshItemsButton: UIButton = {
       let button = UIButton()
        button.backgroundColor = .clear
        button.tintColor = .black
        button.setImage(UIImage(systemName: "arrow.clockwise", withConfiguration: UIImage.SymbolConfiguration(pointSize: 16.0, weight: .medium)), for: .normal)
        button.addTarget(self, action: #selector(refreshMenuItems), for: .touchUpInside)

        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        activityIndicator.startAnimating()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        presenter?.fetchMenuItems()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: refreshItemsButton)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationItem.rightBarButtonItem = nil
    }
    
    //MARK: - Protocol Methods
    func update(with items: [[MenuItemModel]]) {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            
            self.menuItems = items.sorted { (response1, response2) -> Bool in
                let category1 = response1.first?.type
                let category2 = response2.first?.type
                
                guard let index1 = FoodCategory.allCases.firstIndex(where: { $0.queryValue == category1 }),
                      let index2 = FoodCategory.allCases.firstIndex(where: { $0.queryValue == category2 }) else {
                    return false
                }
                return index1 < index2
            }
            
            self.foodItemsTableView.reloadData()
            self.headerView.isUserInteractionEnabled = true
        }
    }
    
    func update(with error: String) {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.headerView.isUserInteractionEnabled = false
        }
    }
    
    func updateCityLabel(_ cityName: String) {
        self.cityLabel?.text = cityName
    }
    
}

//MARK: - Appearence
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
        backgroundView.addSubview(activityIndicator)
        view.addSubview(foodItemsTableView)
        
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: headerViewHeight),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: headerViewHeight)
        ])
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: headerViewHeight),
            activityIndicator.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            activityIndicator.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            activityIndicator.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
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
        headerView.isUserInteractionEnabled = false
        view.addSubview(headerView)
    }
    
    func setupNavigationBar() {
        cityLabel = createCityLabel()
        customItem = UIBarButtonItem(customView: createCustomNavBarItem())
        presenter?.updateCityLabelWithStoredValue()
        self.navigationController?.navigationBar.topItem?.leftBarButtonItem = customItem
    }
    
    @objc private func refreshMenuItems() {
        presenter?.fetchMenuItems()
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
        return self.menuItems.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: foodItemCellId, for: indexPath) as! FoodItemCell
        cell.configure(with: menuItems[indexPath.section][indexPath.row])
        cell.selectionStyle = .none
        
        let separatorHeight: CGFloat = 1.0
        let separatorView = UIView(frame: CGRect(x: 0, y: cell.bounds.height - separatorHeight, width: cell.bounds.width, height: separatorHeight))
        separatorView.backgroundColor = .lightGray.withAlphaComponent(0.2)
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
        guard let section = FoodCategory.allCases.firstIndex(where: { $0.listValue == category }) else {
            return
        }
        
        let indexPath = IndexPath(row: 0, section: section)
        foodItemsTableView.scrollToRow(at: indexPath, at: .middle, animated: true)
    }
}
