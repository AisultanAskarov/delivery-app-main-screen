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
    let hasMoreItems: Bool
}

enum Errors: Error {
    case invalidURL
    case invalidState
}

final class MenuItemsNetworkService: MenuItemsNetworkServiceProtocol {
    private enum Endpoints {
        static func menuItems(for category: FoodCategory) -> String {
            let baseEndpoint = "https://api.spoonacular.com/food/menuItems/search"
            let query = category.queryValue
            return "\(baseEndpoint)?query=\(query)&number=10"
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
                    let menuItems = try jsonDecoder.decode([MenuItem].self, from: data)
                    let hasMoreItems = menuItems.count == 10
                    let itemsResponse = ItemsResponse(items: menuItems, hasMoreItems: hasMoreItems)
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
