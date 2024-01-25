//
//  FoodItemCell.swift
//  delivery-app-main-screen
//
//  Created by Aisultan Askarov on 15.01.2024.
//

import UIKit

class FoodItemCell: UITableViewCell {
    
    var isLoading: Bool = true {
        didSet {
            updateLoadingState()
        }
    }
    
    func configure(with item: MenuItemModel?) {
        isLoading = false
        itemsNameLabel.text = item?.title ?? "Item"
        itemsIngredientsLabel.text = "Tomatos, letuce, onions, ground beef"
        itemsPriceLabel.text = "14.99 USD"
        itemsImageView.setImage(fromURL: item?.image ?? "", withId: String(item?.id ?? 0))
    }
    
    private func updateLoadingState() {
        itemsImageView.setTemplate(isLoading)
        itemsImageView.setShimmeringAnimation(isLoading, viewBackgroundColor: .systemBackground,
                                              animationSpeed: 1.5)
        
        itemsNameLabel.setTemplate(isLoading)
        itemsNameLabel.setShimmeringAnimation(isLoading, viewBackgroundColor: .systemBackground,
                                              animationSpeed: 1.5)
        itemsIngredientsLabel.setTemplate(isLoading)
        itemsIngredientsLabel.setShimmeringAnimation(isLoading, viewBackgroundColor: .systemBackground,
                                              animationSpeed: 1.5)
        itemsPriceLabel.setTemplate(isLoading)
        itemsPriceLabel.setShimmeringAnimation(isLoading, viewBackgroundColor: .systemBackground,
                                              animationSpeed: 1.5)
        
        if !isLoading {
            itemsIngredientsLabel.textColor = .gray
            addItemButton.backgroundColor = Colors().tabItemActive
        }
    }
    
    let itemsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10.0
        
        return imageView
    }()
    
    let roundedContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray.withAlphaComponent(0.2)
        view.clipsToBounds = false
        view.layer.cornerRadius = 10.0
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowRadius = 5
        view.layer.shadowOffset = .zero
        
        return view
    }()
    
    let itemsNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16.0, weight: .bold)
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 1
        label.clipsToBounds = true
        label.backgroundColor = .clear

        return label
    }()
    
    let itemsIngredientsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13.0)
        label.textColor = .clear
        label.textAlignment = .left
        label.numberOfLines = 4
        label.clipsToBounds = true
        label.text = "Tomatos, letuce, onions, ground beef"
        label.backgroundColor = .clear

        return label
    }()
    
    let itemsPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15.0)
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 4
        label.clipsToBounds = true
        label.backgroundColor = .clear

        return label
    }()
    
    let addItemButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 17.0, weight: .semibold)), for: .normal)
        button.tintColor = .white
        button.backgroundColor = .lightGray
        
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        setupCellLayout()
        updateLoadingState()
    }
    
    //MARK: - Appearence
    private func setupCellLayout() {
        addSubview(roundedContainer)
        roundedContainer.addSubview(itemsImageView)
        addSubview(itemsNameLabel)
        addSubview(itemsIngredientsLabel)
        addSubview(itemsPriceLabel)
        addSubview(addItemButton)
        
        roundedContainer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            roundedContainer.rightAnchor.constraint(equalTo: rightAnchor, constant: -20.0),
            roundedContainer.centerYAnchor.constraint(equalTo: centerYAnchor),
            roundedContainer.widthAnchor.constraint(equalToConstant: 120.0),
            roundedContainer.heightAnchor.constraint(equalToConstant: 120.0)
        ])
        
        itemsImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            itemsImageView.centerXAnchor.constraint(equalTo: roundedContainer.centerXAnchor),
            itemsImageView.centerYAnchor.constraint(equalTo: roundedContainer.centerYAnchor),
            itemsImageView.widthAnchor.constraint(equalTo: roundedContainer.widthAnchor),
            itemsImageView.heightAnchor.constraint(equalTo: roundedContainer.heightAnchor)
        ])
        
        itemsNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            itemsNameLabel.topAnchor.constraint(equalTo: roundedContainer.topAnchor, constant: 5.0),
            itemsNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            itemsNameLabel.trailingAnchor.constraint(equalTo: roundedContainer.leadingAnchor, constant: -20),
            itemsNameLabel.heightAnchor.constraint(equalToConstant: 20.0)
        ])
        
        itemsIngredientsLabel.translatesAutoresizingMaskIntoConstraints = false
        itemsIngredientsLabel.sizeToFit()
        NSLayoutConstraint.activate([
            itemsIngredientsLabel.topAnchor.constraint(equalTo: itemsNameLabel.bottomAnchor, constant: 5.0),
            itemsIngredientsLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            itemsIngredientsLabel.trailingAnchor.constraint(equalTo: roundedContainer.leadingAnchor, constant: -20),
        ])
        
        itemsPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            itemsPriceLabel.topAnchor.constraint(equalTo: itemsIngredientsLabel.bottomAnchor, constant: 15.0),
            itemsPriceLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            itemsPriceLabel.widthAnchor.constraint(equalToConstant: 100.0),
            itemsPriceLabel.heightAnchor.constraint(equalToConstant: 30.0)
        ])
        
        addItemButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addItemButton.bottomAnchor.constraint(equalTo: roundedContainer.bottomAnchor, constant: 7.5),
            addItemButton.rightAnchor.constraint(equalTo: roundedContainer.rightAnchor, constant: 7.5),
            addItemButton.heightAnchor.constraint(equalToConstant: 30.0),
            addItemButton.widthAnchor.constraint(equalToConstant: 30.0)
        ])
        addItemButton.layer.cornerRadius = 15
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
