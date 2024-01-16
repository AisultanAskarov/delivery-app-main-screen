//
//  MenuItemsNetworkService.swift
//  delivery-app-main-screen
//
//  Created by Aisultan Askarov on 15.01.2024.
//

import Foundation

protocol MenuItemsNetworkServiceProtocol {
    func getAllItems(completion: @escaping (Result<[ItemsResponse], Error>) -> Void)
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
        //https://api.spoonacular.com/food/menuItems/search?query=burger&apiKey=API_KEY
        static func menuItems(for category: FoodCategory) -> String {
            let baseEndpoint = "https://api.spoonacular.com/food/menuItems/search"
            let query = category.queryValue
            let key = ENV.MENU_ITEMS_API_KEY
            return "\(baseEndpoint)?query=\(query)&number=7&apiKey=\(key)"
        }
    }
    
    private let urlSession: URLSession
    private let jsonDecoder: JSONDecoder
    
    init(urlSession: URLSession = .shared, jsonDecoder: JSONDecoder) {
        self.urlSession = urlSession
        self.jsonDecoder = jsonDecoder
    }
    
    func getAllItems(completion: @escaping (Result<[ItemsResponse], Error>) -> Void) {
        let dispatchGroup = DispatchGroup()
        var results: [Result<ItemsResponse, Error>] = []
        
        for category in FoodCategory.allCases {
            dispatchGroup.enter()
            getItemsForCategory(category) { result in
                results.append(result)
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            let errors = results.compactMap { result -> Error? in
                if case let .failure(error) = result {
                    return error
                }
                return nil
            }
            
            if let firstError = errors.first {
                completion(.failure(firstError))
            } else {
                let itemsResponses = results.compactMap { result -> ItemsResponse? in
                    if case let .success(itemsResponse) = result {
                        return itemsResponse
                    }
                    return nil
                }
                completion(.success(itemsResponses))
            }
        }
    }
    
    private func getItemsForCategory(_ category: FoodCategory, completion: @escaping (Result<ItemsResponse, Error>) -> Void) {
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
