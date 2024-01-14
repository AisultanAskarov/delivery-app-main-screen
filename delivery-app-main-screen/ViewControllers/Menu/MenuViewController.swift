//
//  MenuViewController.swift
//  delivery-app-main-screen
//
//  Created by Aisultan Askarov on 14.01.2024.
//

import UIKit

protocol MenuViewProtocol: AnyObject {
    func configureNavigationBar(with customItem: UIBarButtonItem)
}

class MenuViewController: UIViewController, MenuViewProtocol {
    var presenter: MenuPresenterProtocol?

    private let colors = Colors()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        presenter?.viewDidLoad()
    }

    private func configureUI() {
        view.backgroundColor = colors.mainBgColor
    }

    func configureNavigationBar(with customItem: UIBarButtonItem) {
        self.navigationController?.navigationBar.topItem?.leftBarButtonItem = customItem
    }
}
