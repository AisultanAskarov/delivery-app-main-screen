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
        itemsImageView.setImage(fromURL: item?.image ?? "", withId: String(item?.id ?? 0))
    }
    
    private func updateLoadingState() {
        if isLoading {
            itemsImageView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
            itemsImageView.layer.cornerRadius = 10.0
            
            itemsNameLabel.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
            itemsNameLabel.layer.cornerRadius = 10.0
            
            itemsIngredientsLabel.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
            itemsIngredientsLabel.layer.cornerRadius = 10.0
            
            purchaseButon.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
            purchaseButon.layer.cornerRadius = 10.0
        } else {
            itemsImageView.backgroundColor = .clear
            itemsImageView.layer.cornerRadius = 0.0
            
            itemsNameLabel.backgroundColor = .clear
            itemsNameLabel.layer.cornerRadius = 0.0
            
            itemsIngredientsLabel.backgroundColor = .clear
            itemsIngredientsLabel.layer.cornerRadius = 0.0
            
            purchaseButon.backgroundColor = .clear
            purchaseButon.layer.cornerRadius = 5.0
        }
    }
    
    
    let itemsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .lightGray.withAlphaComponent(0.2)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        
        return imageView
    }()
    
    let roundedContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray.withAlphaComponent(0.2)
        view.clipsToBounds = true
        view.layer.cornerRadius = 10.0
        
        return view
    }()
    
    let infoContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.clipsToBounds = true
        
        return view
    }()
    
    let itemsNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17.0, weight: .semibold)
        label.textColor = .black
        label.backgroundColor = .clear
        label.textAlignment = .left
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let itemsIngredientsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13.0)
        label.text = "Ветчина, шапиньоны, увеличенная порция моцареллы, томатный соус"
        label.textColor = .gray
        label.backgroundColor = .clear
        label.textAlignment = .left
        label.numberOfLines = 4
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let purchaseButon: UIButton = {
        let button = UIButton()
        button.setTitle("от 345 р", for: .normal)
        button.setTitleColor(Colors().tabItemActive, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13.0)
        button.backgroundColor = .clear
        button.layer.borderWidth = 1
        button.layer.borderColor = Colors().tabItemActive.cgColor
        
        return button
    }()
    
    let separatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        setupCellLayout()
        bringSubviewToFront(separatorLine)
    }
    
    //MARK: - Appearence
    private func setupCellLayout() {
        addSubview(roundedContainer)
        roundedContainer.addSubview(itemsImageView)
        addSubview(infoContainer)
        infoContainer.addSubview(itemsNameLabel)
        infoContainer.addSubview(itemsIngredientsLabel)
        infoContainer.addSubview(purchaseButon)
        addSubview(separatorLine)
        
        roundedContainer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            roundedContainer.leftAnchor.constraint(equalTo: leftAnchor, constant: 20.0),
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
        
        infoContainer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            infoContainer.centerYAnchor.constraint(equalTo: itemsImageView.centerYAnchor),
            infoContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20.0),
            infoContainer.leadingAnchor.constraint(equalTo: itemsImageView.trailingAnchor, constant: 10.0),
            infoContainer.heightAnchor.constraint(equalToConstant: 136.0),
        ])
        
        itemsNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            itemsNameLabel.topAnchor.constraint(equalTo: infoContainer.topAnchor, constant: 5.0),
            itemsNameLabel.leadingAnchor.constraint(equalTo: infoContainer.leadingAnchor),
            itemsNameLabel.trailingAnchor.constraint(equalTo: infoContainer.trailingAnchor),
            itemsNameLabel.heightAnchor.constraint(equalToConstant: 20.0)
        ])
        
        itemsIngredientsLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            itemsIngredientsLabel.topAnchor.constraint(equalTo: itemsNameLabel.bottomAnchor, constant: 5.0),
            itemsIngredientsLabel.leadingAnchor.constraint(equalTo: infoContainer.leadingAnchor),
            itemsIngredientsLabel.trailingAnchor.constraint(equalTo: infoContainer.trailingAnchor),
            itemsIngredientsLabel.bottomAnchor.constraint(equalTo: purchaseButon.topAnchor, constant: -5.0),
        ])
        
        purchaseButon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            purchaseButon.bottomAnchor.constraint(equalTo: infoContainer.bottomAnchor, constant: -5.0),
            purchaseButon.rightAnchor.constraint(equalTo: infoContainer.rightAnchor),
            purchaseButon.heightAnchor.constraint(equalToConstant: 30.0),
            purchaseButon.widthAnchor.constraint(equalToConstant: 90.0)
        ])
        purchaseButon.layer.cornerRadius = 5
        
        separatorLine.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            separatorLine.bottomAnchor.constraint(equalTo: bottomAnchor),
            separatorLine.leadingAnchor.constraint(equalTo: leadingAnchor),
            separatorLine.trailingAnchor.constraint(equalTo: leadingAnchor),
            separatorLine.heightAnchor.constraint(equalToConstant: 1.0)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
