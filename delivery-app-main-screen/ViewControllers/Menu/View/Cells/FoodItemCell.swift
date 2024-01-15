//
//  FoodItemCell.swift
//  delivery-app-main-screen
//
//  Created by Aisultan Askarov on 15.01.2024.
//

import UIKit

class FoodItemCell: UITableViewCell {

    let viewForCell: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.20)
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        view.clipsToBounds = true
        
        return view
    }()
    
    let darkeningView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.05)
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        
        return view
    }()

    let exercisesImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.clear
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        
        return imageView
    }()

    let exerciseNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20.0, weight: .bold)
        label.allowsDefaultTighteningForTruncation = false
        label.sizeToFit()
        label.numberOfLines = 2
        label.textColor = UIColor.white.withAlphaComponent(1.0)
        label.backgroundColor = UIColor.clear
        label.textAlignment = .left
        
        return label
    }()
    
    let equipmentTypeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13.0)
        label.text = "Equipment: Dumbbell"
        label.textColor = UIColor.white.withAlphaComponent(0.95)
        label.backgroundColor = UIColor.clear
        label.textAlignment = .left
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let priorMuscleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13.0)
        label.text = "Prior Muscle: Upper Chest"
        label.textColor = UIColor.white.withAlphaComponent(0.95)
        label.backgroundColor = UIColor.clear
        label.textAlignment = .left
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.clear
        addSubview(viewForCell)
        viewForCell.addSubview(exercisesImageView)
        exercisesImageView.addSubview(darkeningView)
        viewForCell.addSubview(exerciseNameLabel)
        viewForCell.addSubview(equipmentTypeLabel)
        viewForCell.addSubview(priorMuscleLabel)
        
        viewForCell.translatesAutoresizingMaskIntoConstraints = false
        exercisesImageView.translatesAutoresizingMaskIntoConstraints = false
        darkeningView.translatesAutoresizingMaskIntoConstraints = false
        exerciseNameLabel.translatesAutoresizingMaskIntoConstraints = false
        equipmentTypeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        viewForCell.topAnchor.constraint(equalTo: topAnchor, constant: 7.0).isActive = true
        viewForCell.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -7.0).isActive = true
        viewForCell.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        viewForCell.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        
        exercisesImageView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        exercisesImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 5).isActive = true
        exercisesImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: -20).isActive = true
        exercisesImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 20).isActive = true
        
        darkeningView.topAnchor.constraint(equalTo: topAnchor, constant: 7.0).isActive = true
        darkeningView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -7.0).isActive = true
        darkeningView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        darkeningView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        
        exerciseNameLabel.leftAnchor.constraint(equalTo: viewForCell.leftAnchor, constant: 15).isActive = true
        exerciseNameLabel.bottomAnchor.constraint(equalTo: priorMuscleLabel.topAnchor, constant: -5).isActive = true
        exerciseNameLabel.widthAnchor.constraint(equalToConstant: (frame.width / 1.75)).isActive = true
        
        priorMuscleLabel.leadingAnchor.constraint(equalTo: viewForCell.leadingAnchor, constant: 15).isActive = true
        priorMuscleLabel.trailingAnchor.constraint(equalTo: viewForCell.trailingAnchor, constant: -15).isActive = true
        priorMuscleLabel.heightAnchor.constraint(equalToConstant: 19).isActive = true
        priorMuscleLabel.bottomAnchor.constraint(equalTo: equipmentTypeLabel.topAnchor, constant: 0).isActive = true
        
        equipmentTypeLabel.leadingAnchor.constraint(equalTo: viewForCell.leadingAnchor, constant: 15).isActive = true
        equipmentTypeLabel.trailingAnchor.constraint(equalTo: viewForCell.trailingAnchor, constant: -15).isActive = true
        equipmentTypeLabel.heightAnchor.constraint(equalToConstant: 19).isActive = true
        equipmentTypeLabel.bottomAnchor.constraint(equalTo: viewForCell.bottomAnchor, constant: -15).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
