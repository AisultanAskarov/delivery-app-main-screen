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
    func update(with users: [MenuItem])
    func update(with error: String)
}

class MenuViewController: UIViewController, MenuViewProtocol {
    
    var presenter: MenuPresenterProtocol?
    
    private let colors = Colors()
    private let categoriesList: [String] =  FoodCategory.allCases.map { $0.listValue }
    private let categoryCellId = "CategoryCell"
    private let adItemCellId = "AdItemCell"
    private var arrSelectedFilter: IndexPath? = nil
    
    private var cityOptionButton = UIBarButtonItem()
    private var citiesMenu: UIMenu?
    private var customItem: UIBarButtonItem?
    private var cityLabel: UILabel?
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = .clear
        view.isScrollEnabled = true
        return view
    }()
    
    private let adsBannerCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 18.5, bottom: 0, right: 18.5)
        layout.minimumLineSpacing = 18.5
        layout.estimatedItemSize = .zero

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = UIColor.clear
        collectionView.isPagingEnabled = false
        collectionView.bounces = true
        return collectionView
    }()
    
    private let categorySelectorCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 18.5, bottom: 0, right: 18.5)
        layout.minimumLineSpacing = 0
        layout.estimatedItemSize = .zero

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = UIColor.clear
        collectionView.isPagingEnabled = false
        collectionView.bounces = true
        collectionView.allowsMultipleSelection = false
        return collectionView
    }()
    
    private let foodItemsTableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        presenter?.fetchMenuItems()
    }
    
    //MARK: - Protocol Methods
    func update(with users: [MenuItem]) {
        
    }
    
    func update(with error: String) {
        
    }
    
    func updateCityLabel(_ cityName: String) {
        self.cityLabel?.text = cityName
    }
    
    //MARK: - Layout Functions
    private func configureViews() {
        view.backgroundColor = colors.mainBgColor
        setupNavigationBar()
        setupScrollView()
        setupAdsBannerCollectionView()
        setupStickyCategorySelector()
    }
    
    func setupNavigationBar() {
        cityLabel = createCityLabel()
        customItem = UIBarButtonItem(customView: createCustomNavBarItem())
        presenter?.updateCityLabelWithStoredValue()
        self.navigationController?.navigationBar.topItem?.leftBarButtonItem = customItem
    }
    
    func setupScrollView() {
        view.addSubview(scrollView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    private func setupAdsBannerCollectionView() {
        adsBannerCollectionView.register(AdItemCell.self, forCellWithReuseIdentifier: adItemCellId)
        adsBannerCollectionView.delegate = self
        adsBannerCollectionView.dataSource = self
        scrollView.addSubview(adsBannerCollectionView)
        
        adsBannerCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            adsBannerCollectionView.topAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.topAnchor, constant: 15.0),
            adsBannerCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            adsBannerCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            adsBannerCollectionView.heightAnchor.constraint(equalToConstant: 112.0)
        ])
    }
    
    private func setupStickyCategorySelector() {
        categorySelectorCollectionView.register(CategoryCell.self, forCellWithReuseIdentifier: categoryCellId)
        categorySelectorCollectionView.delegate = self
        categorySelectorCollectionView.dataSource = self
        scrollView.addSubview(categorySelectorCollectionView)
        
        categorySelectorCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            categorySelectorCollectionView.topAnchor.constraint(equalTo: adsBannerCollectionView.safeAreaLayoutGuide.bottomAnchor, constant: 20.0),
            categorySelectorCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            categorySelectorCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            categorySelectorCollectionView.heightAnchor.constraint(equalToConstant: 34.0)
        ])
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateFloatingCategorySelectorPosition()
    }

    private func updateFloatingCategorySelectorPosition() {
        
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


extension MenuViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == adsBannerCollectionView {
            return 6
        } else if collectionView == categorySelectorCollectionView {
            return categoriesList.count
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == adsBannerCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: adItemCellId, for: indexPath) as! AdItemCell
            return cell
        } else if collectionView == categorySelectorCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: categoryCellId, for: indexPath) as! CategoryCell
            cell.titleLabel.text = categoriesList[indexPath.row]
            
            cell.titleLabel.font = arrSelectedFilter == indexPath ? UIFont.systemFont(ofSize: 13.0, weight: .bold) : UIFont.systemFont(ofSize: 13.0, weight: .regular)
            cell.titleLabel.textColor = arrSelectedFilter == indexPath ? colors.categorySelectedTitleColor : colors.categoryUnSelectedColor
            cell.titleLabel.backgroundColor = arrSelectedFilter == indexPath ? colors.categorySelectedBgColor : .clear
            cell.titleLabel.layer.borderColor = arrSelectedFilter == indexPath ? UIColor.clear.cgColor : colors.categoryUnSelectedColor.cgColor
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == adsBannerCollectionView {
            return CGSize(width: 300.0, height: 112.0)
        } else if collectionView == categorySelectorCollectionView {
            let label = UILabel(frame: CGRect.zero)
            label.text = categoriesList[indexPath.item]
            label.sizeToFit()
            return CGSize(width: label.frame.width + 40.0, height: 34.0)
        }
        
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == categorySelectorCollectionView {
            if arrSelectedFilter == indexPath {
                arrSelectedFilter = nil
            }
            else {
                arrSelectedFilter = indexPath
            }
            
            collectionView.reloadData()
        }
    }
}

