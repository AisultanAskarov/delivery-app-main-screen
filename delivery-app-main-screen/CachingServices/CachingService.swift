//
//  CachingService.swift
//  delivery-app-main-screen
//
//  Created by Aisultan Askarov on 19.01.2024.
//

import UIKit
import CoreData

final class CachingService {
    
    private enum CacheDirectory: String {
        case images
        case entities
    }
    
    static let shared = CachingService()
    
    private let imageCache = NSCache<NSString, UIImage>()
    private let menuItemsCache = NSCache<NSString, NSArray>()
    
    private let coreDataManager = CoreDataManager.shared
    private let maxImagesInCache = 100
    private let maxMenuItemsInCache = 200
    
    private init() {
        imageCache.countLimit = maxImagesInCache
        menuItemsCache.countLimit = maxMenuItemsInCache
    }
    
    // MARK: - Image Caching
    func cacheImage(_ image: UIImage, forKey key: String) {
        print("NS cached Image")
        imageCache.setObject(image, forKey: key as NSString, cost: 1)
        
        if let data = image.jpegData(compressionQuality: 0.5) {
            let fileURL = getCacheURL(for: key, in: .images)
            try? data.write(to: fileURL)
        }
    }
    
    func loadImage(forKey key: String) -> UIImage? {
        if let cachedImage = imageCache.object(forKey: key as NSString) {
            print("Retrieved Image from NSCache")
            return cachedImage
        }
        
        let fileURL = getCacheURL(for: key, in: .images)
        if let data = try? Data(contentsOf: fileURL), let image = UIImage(data: data) {
            print("Retrieved Image from File Manager")
            print("Re-caching Image in NSCache")
            imageCache.setObject(image, forKey: key as NSString, cost: 1)
            return image
        }
        
        return nil
    }
    
    // MARK: - Menu Items Caching
    func cacheMenuItems(_ items: [MenuItemModel], ofType type: FoodCategory) {
        print("NS cached Menu Item")
        menuItemsCache.setObject(items as NSArray, forKey: type.queryValue as NSString)
        convertToMenuItemEntity(from: items, ofType: type)
    }
    
    func loadMenuItems(forType type: String) -> [MenuItemModel]? {
        if let quickCachedEntities = menuItemsCache.object(forKey: type as NSString) as? [MenuItemModel] {
            print("Retrieved Menu Item from NSCache")
            return quickCachedEntities
        }
        
        let coreDataCachedEntities = coreDataManager.fetch(entityType: MenuItem.self, predicate: NSPredicate(format: "type == %@", type))
        
        if !coreDataCachedEntities.isEmpty {
            print("Retrieved Menu Item from CoreData")
            let menuItemModels = convertToMenuItemModels(from: coreDataCachedEntities)
            // Cache the items in memory
            print("Re-caching Menu Item in NSCache")
            menuItemsCache.setObject(menuItemModels as NSArray, forKey: type as NSString)
            return menuItemModels
        }
        
        return nil
    }
    
    // MARK: - Helpers
    private func getCacheURL(for key: String, in directory: CacheDirectory) -> URL {
        let cacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0].appendingPathComponent(directory.rawValue)
        
        if !FileManager.default.fileExists(atPath: cacheDirectory.path) {
            try? FileManager.default.createDirectory(at: cacheDirectory, withIntermediateDirectories: true, attributes: nil)
        }
        
        return cacheDirectory.appendingPathComponent("\(key).dat")
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
    
    func convertToMenuItemEntity(from models: [MenuItemModel], ofType type: FoodCategory) {
        for model in models {
            guard let servings = coreDataManager.create(entityType: Servings.self) else { return }
            servings.number = model.servings.number
            servings.size = model.servings.size ?? 0.0
            servings.unit = model.servings.unit ?? ""
            
            guard let menuItem = coreDataManager.create(entityType: MenuItem.self) else { return }
            menuItem.id = Int32(model.id)
            menuItem.title = model.title
            menuItem.restaurantChain = model.restaurantChain
            menuItem.image = model.image
            menuItem.imageType = model.imageType
            menuItem.type = type.queryValue
            menuItem.servings = servings
            
            print("Saved to CoreData")
            coreDataManager.saveContext()
        }
    }
}
