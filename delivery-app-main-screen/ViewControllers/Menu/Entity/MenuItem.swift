//
//  MenuItems.swift
//  delivery-app-main-screen
//
//  Created by Aisultan Askarov on 15.01.2024.
//

///https://api.spoonacular.com/food/menuItems/search?query=burger&number=2

import Foundation

public enum FoodCategory: CaseIterable {
    case burgers
    case desserts
    case drinks
    case pizzas
    case salads
    case steaks
    case ramen
    
    var listValue: String {
        switch self {
        case .burgers: return "Пицца"
        case .desserts: return "Десерты"
        case .drinks: return "Напитки"
        case .pizzas: return "Пицца"
        case .salads: return "Салаты"
        case .steaks: return "Стейки"
        case .ramen: return "Рамен"
        }
    }
    
    var queryValue: String {
        switch self {
        case .burgers: return "burger"
        case .desserts: return "dessert"
        case .drinks: return "drink"
        case .pizzas: return "pizza"
        case .salads: return "salad"
        case .steaks: return "steak"
        case .ramen: return "ramen"
        }
    }
}

struct MenuItem: Decodable {
    let id: Int
    let title: String
    let restaurantChain: String
    let image: String
    let imageType: String
    let servings: Servings
}

struct Servings: Decodable {
    let number: Int
    let size: Int
    let unit: String
}

struct MenuItemsResponse: Decodable {
    let menuItems: [MenuItem]
    let totalMenuItems: Int
    let type: String
    let offset: Int
    let number: Int
}
