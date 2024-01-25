//
//  CachingServiceTests.swift
//  delivery-app-main-screenTests
//
//  Created by Aisultan Askarov on 24.01.2024.
//

import XCTest
@testable import delivery_app_main_screen

final class CachingServiceTests: XCTestCase {
    
    var cachingService: CachingService!
    
    override func setUp() {
        super.setUp()
        cachingService = CachingService.shared
    }
    
    override func tearDown() {
        cachingService = nil
        super.tearDown()
    }
    
    func testCacheImage() {
        let image = UIImage(systemName: "plus.circle.fill")!
        let key = "testKey"
        
        cachingService.cacheImage(image, forKey: key)
        
        XCTAssertNotNil(cachingService.imageCache.object(forKey: key as NSString))
    }
    
    func testLoadImageFromCache() {
        let image = UIImage(systemName: "plus.circle.fill")!
        let key = "testKey"
        
        cachingService.cacheImage(image, forKey: key)
        let loadedImage = cachingService.loadImage(forKey: key)
        
        XCTAssertNotNil(loadedImage)
    }
    
    func testCacheMenuItems() {
        let items = [MenuItemModel(id: 1, title: "Item1", restaurantChain: "Restaurant1", image: "image1", imageType: "png", servings: ServingsModel(number: 1.0, size: 2.0, unit: "kg"), type: "type1")]
        
        cachingService.cacheMenuItems(items, ofType: FoodCategory.burgers.queryValue)
        
        XCTAssertNotNil(cachingService.menuItemsCache.object(forKey: FoodCategory.burgers.queryValue as NSString))
    }
    
    func testLoadMenuItemsFromCache() {
        let items = [MenuItemModel(id: 1, title: "Item1", restaurantChain: "Restaurant1", image: "image1", imageType: "png", servings: ServingsModel(number: 1.0, size: 2.0, unit: "kg"), type: "type1")]
        
        cachingService.cacheMenuItems(items, ofType: FoodCategory.burgers.queryValue)
        let loadedItems = cachingService.loadMenuItems(forType: FoodCategory.burgers.queryValue)
        
        XCTAssertNotNil(loadedItems)
    }
    
    func testDeleteCachedMenuItems() {
        let items = [MenuItemModel(id: 1, title: "Item1", restaurantChain: "Restaurant1", image: "image1", imageType: "png", servings: ServingsModel(number: 1.0, size: 2.0, unit: "kg"), type: "type1")]
        
        cachingService.cacheMenuItems(items, ofType: FoodCategory.burgers.queryValue)
        cachingService.deleteCachedMenuItems()
        
        XCTAssertNil(cachingService.menuItemsCache.object(forKey: FoodCategory.burgers.queryValue as NSString))
    }
    
    func testGetCacheURL() {
        let key = "testKey"
        let directory = CachingService.CacheDirectory.images
        let url = cachingService.getCacheURL(for: key, in: directory)
        
        XCTAssertNotNil(url)
    }
}

