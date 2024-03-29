//
//  MenuItemsNetworkService.swift
//  delivery-app-main-screen
//
//  Created by Aisultan Askarov on 15.01.2024.
//

import Foundation

protocol MenuItemsNetworkServiceProtocol {
    func getAllItems(completion: @escaping (Result<[[MenuItemModel]], Error>) -> Void)
}

final class MenuItemsNetworkService: MenuItemsNetworkServiceProtocol {
    private enum Endpoints {
        //https://api.spoonacular.com/food/menuItems/search?query=burger&apiKey=API_KEY
        static func menuItems(for category: FoodCategory) -> String {
            let baseEndpoint = "https://api.spoonacular.com/food/menuItems/search"
            let query = category.queryValue
            let key = ENV.MENU_ITEMS_API_KEY
            return "\(baseEndpoint)?query=\(query)&number=3&apiKey=\(key)"
        }
    }
    
    private let cachingService: CachingServiceProtocol
    private var urlSession: URLSessionProtocol
    private let jsonDecoder: JSONDecoder
    
    init(cachingService: CachingServiceProtocol = CachingService.shared, urlSession: URLSessionProtocol = URLSessionWrapper(), jsonDecoder: JSONDecoder) {
        self.cachingService = cachingService
        self.urlSession = urlSession
        self.jsonDecoder = jsonDecoder
        jsonDecoder.userInfo[.managedObjectContext] = CoreDataManager.shared.context
    }
    
    func getAllItems(completion: @escaping (Result<[[MenuItemModel]], Error>) -> Void) {
        let dispatchGroup = DispatchGroup()
        var results: [Result<MenuItemsResponseModel, Error>] = []
        
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
                let itemsResponses = results.compactMap { result -> [MenuItemModel]? in
                    if case let .success(itemsResponse) = result {
                        self.cachingService.cacheMenuItems(itemsResponse.menuItems, ofType: itemsResponse.type)
                        return itemsResponse.menuItems
                    }
                    return nil
                }
                completion(.success(itemsResponses))
            }
        }
    }
    
    func getItemsForCategory(_ category: FoodCategory, completion: @escaping (Result<MenuItemsResponseModel, Error>) -> Void) {
        let cacheKey = category.queryValue
        
        //Two-stage caching system. First checks quick NSCache, if empty checks CoreData, if empty perform URL request.
        if let cachedResponse = cachingService.loadMenuItems(forType: cacheKey) {
            let menuItemsResponse = MenuItemsResponseModel(type: category.queryValue, menuItems: cachedResponse)
            completion(.success(menuItemsResponse))
            return
        }

        guard let url = URL(string: Endpoints.menuItems(for: category)) else {
            completion(.failure(Errors.invalidURL))
            return
        }

        let request = urlSession.dataTask(with: URLRequest(url: url)) { [jsonDecoder] data, response, error in
            switch (data, error) {
            case let (.some(data), nil):
                do {
                    print("Fetched Menu Item")
                    var menuItemsResponse = try jsonDecoder.decode(MenuItemsResponseModel.self, from: data)
                    menuItemsResponse.type = category.queryValue
                    
                    completion(.success(menuItemsResponse))
                } catch {
                    print("error: \(error)")
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
