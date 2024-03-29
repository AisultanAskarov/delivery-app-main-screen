//
//  TabBarController.swift
//  delivery-app-main-screen
//
//  Created by Aisultan Askarov on 14.01.2024.
//

import UIKit

public enum TabBarControllerIndex: Int {
    case menu
    case contacts
    case userProfile
    case cart
}

private enum TabBarItem: String {
    case menu
    case contacts
    case userProfile
    case cart
    
    var image: UIImage {
        return UIImage(named: self.rawValue + "_icon") ?? UIImage()
    }
    
    var title: String {
        switch self {
        case .menu:
            return "Меню"
            
        case .contacts:
            return "Контакты"
            
        case .userProfile:
            return "Профиль"
            
        case .cart:
            return "Корзина"
        }
    }
}

final class TabBarController: UITabBarController {
    //MARK: - Properties
    private var menusNav: UINavigationController?
    private var contactsNav: UINavigationController?
    private var userProfilesNav: UINavigationController?
    private var cartsNav: UINavigationController?
    
    private let colors = Colors()
    
    // MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateTabBarAppearance()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateTabBarAppearance()
    }
    
    // MARK: - Appearence
    func updateTabBarAppearance() {
        self.tabBar.tintColor = colors.tabItemActive
        self.tabBar.unselectedItemTintColor = colors.tabItemInActive
        self.tabBar.backgroundColor = .white
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: colors.tabItemInActive], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: colors.tabItemActive], for: .selected)
        
        self.tabBar.layer.shadowColor = UIColor.black.cgColor
        self.tabBar.layer.shadowOpacity = 0.1
        self.tabBar.layer.shadowRadius = 5.0
        self.tabBar.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.tabBar.layer.shouldRasterize = true
        self.tabBar.layer.rasterizationScale = UIScreen.main.scale
    }
    
    // MARK: - Tab Bar Setup
    private func setupTabBar() {
        initializeTabs()
        setViewControllers([menusNav, contactsNav, userProfilesNav, cartsNav].compactMap { $0 }, animated: false)
        self.tabBar.itemPositioning = .centered
        self.tabBar.itemSpacing = 20
    }
    
    private func initializeMenuTab() {
        guard let menuVC = MenuModuleAssembler.assembleModule() else { return }
        menuVC.tabBarItem = UITabBarItem(title: TabBarItem.menu.title,
                                         image: TabBarItem.menu.image,
                                         selectedImage: TabBarItem.menu.image)
        menuVC.title = menuVC.tabBarItem.title
        menuVC.navigationItem.title = ""
        menusNav = NavigationController(rootViewController: menuVC)
    }
    
    private func initializeContactsTab() {
        let contactsVC = ContactsViewController()
        contactsVC.tabBarItem = UITabBarItem(title: TabBarItem.contacts.title,
                                         image: TabBarItem.contacts.image,
                                         selectedImage: TabBarItem.contacts.image)
        contactsVC.title = contactsVC.tabBarItem.title
        contactsNav = NavigationController(rootViewController: contactsVC)
    }
    
    private func initializeUserProfileTab() {
        let userProfileVC = UserProfileViewController()
        userProfileVC.tabBarItem = UITabBarItem(title: TabBarItem.userProfile.title,
                                         image: TabBarItem.userProfile.image,
                                         selectedImage: TabBarItem.userProfile.image)
        userProfileVC.title = userProfileVC.tabBarItem.title
        userProfilesNav = NavigationController(rootViewController: userProfileVC)
    }
    
    private func initializeCartTab() {
        let cartVC = CartViewController()
        cartVC.tabBarItem = UITabBarItem(title: TabBarItem.cart.title,
                                         image: TabBarItem.cart.image,
                                         selectedImage: TabBarItem.cart.image)
        cartVC.title = cartVC.tabBarItem.title
        cartsNav = NavigationController(rootViewController: cartVC)
    }
    
    private func initializeTabs() {
        if viewControllers?.isEmpty ?? true {
            initializeMenuTab()
            initializeContactsTab()
            initializeUserProfileTab()
            initializeCartTab()
        }
    }
    
}

extension UIImage {
    static func gradientImageWithBounds(bounds: CGRect, colors: [CGColor]) -> UIImage {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors
        
        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
