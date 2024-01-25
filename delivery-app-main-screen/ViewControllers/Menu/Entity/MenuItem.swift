//
//  MenuItems.swift
//  delivery-app-main-screen
//
//  Created by Aisultan Askarov on 15.01.2024.
//

import Foundation
import CoreData

public enum FoodCategory: CaseIterable {
    case burgers
    case desserts
    case drinks
    case pizzas
    case salads
    
    var listValue: String {
        switch self {
        case .burgers: return "Бургеры"
        case .desserts: return "Десерты"
        case .drinks: return "Напитки"
        case .pizzas: return "Пицца"
        case .salads: return "Салаты"
        }
    }
    
    var queryValue: String {
        switch self {
        case .burgers: return "burger"
        case .desserts: return "dessert"
        case .drinks: return "drink"
        case .pizzas: return "pizza"
        case .salads: return "salad"
        }
    }
}

struct MenuItemsResponseModel: Decodable {
    var type: String
    var menuItems: [MenuItemModel]
    let offset: Int
    let number: Int
    let totalMenuItems: Int
    let processingTimeMs: Int?
    
    init(type: String, menuItems: [MenuItemModel], offset: Int = 0, number: Int = 0, totalMenuItems: Int = 0, processingTimeMs: Int = 0) {
        self.type = type
        self.menuItems = menuItems
        self.offset = offset
        self.number = number
        self.totalMenuItems = totalMenuItems
        self.processingTimeMs = processingTimeMs
    }
}

struct MenuItemModel: Decodable {
    let id: Int
    let title: String
    let restaurantChain: String
    let image: String
    let imageType: String
    let servings: ServingsModel
    let type: String?
}

struct ServingsModel: Decodable {
    let number: Double
    let size: Double?
    let unit: String?
}

extension CodingUserInfoKey {
    static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")!
}
