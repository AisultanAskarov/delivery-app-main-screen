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
            return "\(baseEndpoint)?query=\(query)&number=3&apiKey=\(key)"
        }
    }
    
    private let coreDataManager: CoreDataManager
    private let urlSession: URLSession
    private let jsonDecoder: JSONDecoder
    
    init(coreDataManager: CoreDataManager = .shared, urlSession: URLSession = .shared, jsonDecoder: JSONDecoder) {
        self.coreDataManager = coreDataManager
        self.urlSession = urlSession
        self.jsonDecoder = jsonDecoder
        jsonDecoder.userInfo[.managedObjectContext] = CoreDataManager.shared.context
    }
    
    func getAllItems(completion: @escaping (Result<[[MenuItemModel]], Error>) -> Void) {
        let dispatchGroup = DispatchGroup()
        var results: [Result<[MenuItemModel], Error>] = []
        
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
                        return itemsResponse
                    }
                    return nil
                }
                completion(.success(itemsResponses))
            }
        }
    }
    
    private func getItemsForCategory(_ category: FoodCategory, completion: @escaping (Result<[MenuItemModel], Error>) -> Void) {
        let cacheKey = category.queryValue
        
        //Two-stage caching system. First check quick NSCache, if empty check CoreData, if empty perform URL request.
        if let cachedResponse = CachingService.shared.loadEntity(forType: cacheKey) {
            print("Quick Cache not empty")
            completion(.success(cachedResponse))
            return
        }

        let cachedEntities = coreDataManager.fetch(entityType: MenuItem.self, predicate: NSPredicate(format: "type == %@", category.queryValue))

        if !cachedEntities.isEmpty {
            print("CoreData Cache not empty")
            completion(.success(convertToMenuItemModels(from: cachedEntities)))
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
                    var menuItemsResponse = try jsonDecoder.decode(MenuItemsResponseModel.self, from: data)
                    menuItemsResponse.type = category.queryValue

                    CachingService.shared.cacheEntity(menuItemsResponse.menuItems, ofType: category)
                    self.convertToMenuItemEntity(from: menuItemsResponse.menuItems)

                    completion(.success(menuItemsResponse.menuItems))
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
    
    func convertToMenuItemModels(from coreDataEntities: [MenuItem]) -> [MenuItemModel] {
        let menuItemModels = coreDataEntities.map { coreDataEntity -> MenuItemModel in
            let servingsModel = ServingsModel(number: coreDataEntity.servings?.number ?? 0.0,
                                              size: coreDataEntity.servings?.size ?? 0.0,
                                              unit: coreDataEntity.servings?.unit ?? "")
            
            return MenuItemModel( id: Int(coreDataEntity.id),
                                 title: coreDataEntity.title ?? "",
                                 restaurantChain: coreDataEntity.restaurantChain ?? "",
                                 image: coreDataEntity.image ?? "",
                                 imageType: coreDataEntity.imageType ?? "",
                                 servings: servingsModel,
                                 type: coreDataEntity.type)
        }

        return menuItemModels
    }
    
    func convertToMenuItemEntity(from models: [MenuItemModel]) {
        for model in models {
            let servings = coreDataManager.create(entityType: Servings.self)
            servings?.number = model.servings.number
            servings?.size = model.servings.size ?? 0.0
            servings?.unit = model.servings.unit ?? ""
            
            let menuItem = coreDataManager.create(entityType: MenuItem.self)
            menuItem?.id = Int32(model.id)
            menuItem?.title = model.title
            menuItem?.restaurantChain = model.restaurantChain
            menuItem?.image = model.image
            menuItem?.imageType = model.imageType
            menuItem?.servings = servings
            menuItem?.type = model.type

            coreDataManager.saveContext()
        }
    }
}
