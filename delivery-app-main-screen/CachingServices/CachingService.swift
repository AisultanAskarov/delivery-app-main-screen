//
//  CachingService.swift
//  delivery-app-main-screen
//
//  Created by Aisultan Askarov on 19.01.2024.
//

import UIKit
import CoreData

final class CachingService {
    
    static let shared = CachingService()
    
    private let imageCache = NSCache<NSString, UIImage>()
    private let entityCache = NSCache<NSString, NSArray>()
    
    private init() {}
    
    // MARK: - Image Caching
    
    func cacheImage(_ image: UIImage, forKey key: String) {
        imageCache.setObject(image, forKey: key as NSString)
        
        // Save image to disk in the Caches directory
        if let data = image.jpegData(compressionQuality: 0.5) {
            let fileURL = getCacheURL(for: key, in: .images)
            try? data.write(to: fileURL)
        }
    }
    
    func loadImage(forKey key: String) -> UIImage? {
        if let cachedImage = imageCache.object(forKey: key as NSString) {
            return cachedImage
        }
        
        // If not in memory cache, try loading from disk
        let fileURL = getCacheURL(for: key, in: .images)
        if let data = try? Data(contentsOf: fileURL), let image = UIImage(data: data) {
            imageCache.setObject(image, forKey: key as NSString)
            return image
        }
        
        return nil
    }
    
    // MARK: - Entity Caching
    
    func cacheEntity(_ entities: [MenuItemModel], ofType type: FoodCategory) {
        entityCache.setObject(entities as NSArray, forKey: type.queryValue as NSString)
    }
    
    func loadEntity(forType type: String) -> [MenuItemModel]? {
        if let cachedEntities = entityCache.object(forKey: type as NSString) as? [MenuItemModel] {
            return cachedEntities
        }
        
        return nil
    }
    
    // MARK: - Helper
    
    private func getCacheURL(for key: String, in directory: CacheDirectory) -> URL {
        let cacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0].appendingPathComponent(directory.rawValue)
        
        if !FileManager.default.fileExists(atPath: cacheDirectory.path) {
            try? FileManager.default.createDirectory(at: cacheDirectory, withIntermediateDirectories: true, attributes: nil)
        }
        
        return cacheDirectory.appendingPathComponent("\(key).dat")
    }
    
    private enum CacheDirectory: String {
        case images
        case entities
    }
}
