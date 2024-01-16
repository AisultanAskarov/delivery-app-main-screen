//
//  MenuVCHeaderView.swift
//  delivery-app-main-screen
//
//  Created by Aisultan Askarov on 15.01.2024.
//

import UIKit

class MenuVCHeaderView: UIView {
    private let categories: [String]
    weak var delegate: MenuViewHeaderViewCoordinating?
    
    private let colors = Colors()
    private let categoryCellId = "CategoryCell"
    private let adItemCellId = "AdItemCell"
    private var arrSelectedFilter: IndexPath? = nil

    private let adsBannerCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 18.5, bottom: 0, right: 18.5)
        layout.minimumLineSpacing = 18.5
        layout.estimatedItemSize = .zero

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = Colors().mainBgColor
        collectionView.isPagingEnabled = false
        collectionView.bounces = true
        return collectionView
    }()
    
    private let categorySelectorCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 20, left: 18.5, bottom: 20, right: 18.5)
        layout.minimumLineSpacing = 0
        layout.estimatedItemSize = .zero

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = Colors().mainBgColor
        collectionView.isPagingEnabled = false
        collectionView.bounces = true
        collectionView.allowsMultipleSelection = false
        return collectionView
    }()
    
    init(categories: [String]) {
        self.categories = categories
        super.init(frame: .zero)
        
        backgroundColor = .clear
        setupAdsBannerCollectionView()
        setupStickyCategorySelector()
        bringSubviewToFront(categorySelectorCollectionView)
    }
    
    private func setupAdsBannerCollectionView() {
        adsBannerCollectionView.register(AdItemCell.self, forCellWithReuseIdentifier: adItemCellId)
        adsBannerCollectionView.delegate = self
        adsBannerCollectionView.dataSource = self
        addSubview(adsBannerCollectionView)
        
        adsBannerCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            adsBannerCollectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 15.0),
            adsBannerCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            adsBannerCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            adsBannerCollectionView.heightAnchor.constraint(equalToConstant: 112.0)
        ])
    }
    
    private func setupStickyCategorySelector() {
        categorySelectorCollectionView.register(CategoryCell.self, forCellWithReuseIdentifier: categoryCellId)
        categorySelectorCollectionView.delegate = self
        categorySelectorCollectionView.dataSource = self
        addSubview(categorySelectorCollectionView)
        
        categorySelectorCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            categorySelectorCollectionView.topAnchor.constraint(equalTo: adsBannerCollectionView.safeAreaLayoutGuide.bottomAnchor),
            categorySelectorCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            categorySelectorCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            categorySelectorCollectionView.heightAnchor.constraint(equalToConstant: 74.0)
        ])
    }
    
    required init?(coder _: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
}

extension MenuVCHeaderView: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == adsBannerCollectionView {
            return 6
        } else if collectionView == categorySelectorCollectionView {
            return categories.count
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == adsBannerCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: adItemCellId, for: indexPath) as! AdItemCell
            return cell
        } else if collectionView == categorySelectorCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: categoryCellId, for: indexPath) as! CategoryCell
            cell.titleLabel.text = categories[indexPath.row]
            
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
            label.text = categories[indexPath.item]
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
            delegate?.categoryButtonTapped(category: categories[indexPath.row])
            collectionView.reloadData()
        }
    }
}
