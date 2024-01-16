//
//  AdItemCell.swift
//  delivery-app-main-screen
//
//  Created by Aisultan Askarov on 15.01.2024.
//

import UIKit

class AdItemCell: UICollectionViewCell {
    
    let viewForCell: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 10.0
        
        return view
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "first_ad")!
        imageView.backgroundColor = .clear
        imageView.contentMode = .center
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(viewForCell)
        viewForCell.addSubview(imageView)
        
        viewForCell.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewForCell.topAnchor.constraint(equalTo: topAnchor),
            viewForCell.leadingAnchor.constraint(equalTo: leadingAnchor),
            viewForCell.trailingAnchor.constraint(equalTo: trailingAnchor),
            viewForCell.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: viewForCell.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: viewForCell.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: viewForCell.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: viewForCell.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
