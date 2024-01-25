//
//  MockCachingService.swift
//  delivery-app-main-screenTests
//
//  Created by Aisultan Askarov on 25.01.2024.
//

import UIKit

class MockCachingService: CachingServiceProtocol {
    
    var cachedItemImages: [String: UIImage] = [:]
    
    func loadImage(forKey key: String) -> UIImage? {
        return cachedItemImages[key]
    }
    
    func cacheImage(_ image: UIImage, forKey key: String) {
        cachedItemImages[key] = UIImage(systemName: "circle")
    }
    
    var cachedMenuItems: [String: [MenuItemModel]] = [:]
    
    func loadMenuItems(forType type: String) -> [MenuItemModel]? {
        return cachedMenuItems[type]
    }
    
    func cacheMenuItems(_ items: [MenuItemModel], ofType type: String) {
        cachedMenuItems[type] = items
    }
}
