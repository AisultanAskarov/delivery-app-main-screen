//
//  MenuItemsNetworkService.swift
//  delivery-app-main-screen
//
//  Created by Aisultan Askarov on 15.01.2024.
//

import Foundation

protocol MenuItemsNetworkServiceProtocol {
    func getItemsForCategory(_ category: FoodCategory, completion: @escaping (Result<ItemsResponse, Error>) -> Void)
}

struct ItemsResponse {
    let items: [MenuItem]
    let category: FoodCategory
}

enum Errors: Error {
    case invalidURL
    case invalidState
}

final class MenuItemsNetworkService: MenuItemsNetworkServiceProtocol {
    
    private enum Endpoints {
        //https://api.spoonacular.com/food/menuItems/search?query=burger&apiKey=77d24e26adb448c5b3a60aeb45e11020
        static func menuItems(for category: FoodCategory) -> String {
            let baseEndpoint = "https://api.spoonacular.com/food/menuItems/search"
            let query = category.queryValue
            return "\(baseEndpoint)?query=\(query)&apiKey=77d24e26adb448c5b3a60aeb45e11020"
        }
    }
    
    private let urlSession: URLSession
    private let jsonDecoder: JSONDecoder
    
    init(urlSession: URLSession = .shared, jsonDecoder: JSONDecoder) {
        self.urlSession = urlSession
        self.jsonDecoder = jsonDecoder
    }
    
    func getItemsForCategory(_ category: FoodCategory, completion: @escaping (Result<ItemsResponse, Error>) -> Void) {
        guard let url = URL(string: Endpoints.menuItems(for: category)) else {
            completion(.failure(Errors.invalidURL))
            return
        }
        
        let request = urlSession.dataTask(with: URLRequest(url: url)) { [jsonDecoder] data, response, error in
            switch (data, error) {
            case let (.some(data), nil):
                do {
                    let menuItems = try jsonDecoder.decode(MenuItemsResponse.self, from: data)
                    let itemsResponse = ItemsResponse(items: menuItems.menuItems, category: category)
                    completion(.success(itemsResponse))
                } catch {
                    completion(.failure(error))
                }
            case let (.none, .some(error)):
                completion(.failure(error))
            default:
                completion(.failure(Errors.invalidState))
            }
        }
        
        request.resume()
    }
}
