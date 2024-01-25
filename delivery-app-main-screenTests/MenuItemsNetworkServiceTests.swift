//
//  MenuItemsNetworkServiceTests.swift
//  delivery-app-main-screenTests
//
//  Created by Aisultan Askarov on 24.01.2024.
//

import XCTest
@testable import delivery_app_main_screen

final class MenuItemsNetworkServiceTests: XCTestCase {
    
    //MARK: -Get All Items
    func testGetAllItems_SuccessfulResponse() {
        // Given
        let jsonDecoder = JSONDecoder()
        let mockSession = MockURLSession()
        let mockCachingService = MockCachingService()
        let menuItemsNetworkService = MenuItemsNetworkService(cachingService: mockCachingService, urlSession: mockSession, jsonDecoder: jsonDecoder)
        
        let mockData =
             """
             {
                 "menuItems": [
                     {
                         "id": 419357,
                         "title": "Burger Sliders",
                         "restaurantChain": "Hooters",
                         "image": "https://images.spoonacular.com/file/wximages/419357-312x231.png",
                         "imageType": "png",
                         "servings": {
                             "number": 1,
                             "size": 2,
                             "unit": "oz"
                         }
                     },
                     {
                         "id": 424571,
                         "title": "Bacon King Burger",
                         "restaurantChain": "Burger King",
                         "image": "https://images.spoonacular.com/file/wximages/424571-312x231.png",
                         "imageType": "png",
                         "servings": {
                             "number": 1,
                             "size": 2,
                             "unit": "oz"
                         }
                     }
                 ],
                 "totalMenuItems": 6749,
                 "type": "menuItem",
                 "offset": 0,
                 "number": 2
             }
             """.data(using: .utf8)!
        mockSession.data = mockData
        
        // When
        menuItemsNetworkService.getAllItems { result in
            // Then
            switch result {
            case .success(let items):
                XCTAssertEqual(items.count, 2)
            case .failure:
                XCTFail("Expected success, got failure")
            }
        }
    }
    
    func testGetAllItems_FailureResponse() {
        // Given
        let jsonDecoder = JSONDecoder()
        let mockSession = MockURLSession()
        let mockCachingService = MockCachingService()
        let menuItemsNetworkService = MenuItemsNetworkService(cachingService: mockCachingService, urlSession: mockSession, jsonDecoder: jsonDecoder)
        
        mockSession.error = NSError(domain: "Test", code: 123, userInfo: nil)
        
        // When
        menuItemsNetworkService.getAllItems { result in
            // Then
            switch result {
            case .success:
                XCTFail("Expected failure, got success")
            case .failure(let error):
                XCTAssertNotNil(error)
            }
        }
    }
    
    //MARK: -Get Item For Category
    func testGetItemsForCategory_SuccessfulResponse() {
        // Given
        let jsonDecoder = JSONDecoder()
        let mockSession = MockURLSession()
        let mockCachingService = MockCachingService()
        let menuItemsNetworkService = MenuItemsNetworkService(cachingService: mockCachingService, urlSession: mockSession, jsonDecoder: jsonDecoder)
        
        let mockCategory = FoodCategory.burgers
        let mockData =
             """
             {
                 "menuItems": [
                     {
                         "id": 419357,
                         "title": "Burger Sliders",
                         "restaurantChain": "Hooters",
                         "image": "https://images.spoonacular.com/file/wximages/419357-312x231.png",
                         "imageType": "png",
                         "servings": {
                             "number": 1,
                             "size": 2,
                             "unit": "oz"
                         }
                     },
                     {
                         "id": 424571,
                         "title": "Bacon King Burger",
                         "restaurantChain": "Burger King",
                         "image": "https://images.spoonacular.com/file/wximages/424571-312x231.png",
                         "imageType": "png",
                         "servings": {
                             "number": 1,
                             "size": 2,
                             "unit": "oz"
                         }
                     }
                 ],
                 "totalMenuItems": 6749,
                 "type": "menuItem",
                 "offset": 0,
                 "number": 2
             }
             """.data(using: .utf8)!
        mockSession.data = mockData
        
        // When
        menuItemsNetworkService.getItemsForCategory(mockCategory) { result in
            // Then
            switch result {
            case .success(let response):
                XCTAssertEqual(response.type, mockCategory.queryValue)
                XCTAssertNotNil(response.menuItems)
            case .failure:
                XCTFail("Expected success, got failure")
            }
        }
    }
    
    func testGetItemsForCategory_FailureResponse() {
        // Given
        let jsonDecoder = JSONDecoder()
        let mockSession = MockURLSession()
        let mockCachingService = MockCachingService()
        let menuItemsNetworkService = MenuItemsNetworkService(cachingService: mockCachingService, urlSession: mockSession, jsonDecoder: jsonDecoder)
        
        let mockCategory = FoodCategory.burgers
        mockSession.error = NSError(domain: "Test", code: 123, userInfo: nil)
        
        // When
        menuItemsNetworkService.getItemsForCategory(mockCategory) { result in
            // Then
            switch result {
            case .success:
                XCTFail("Expected failure, got success")
            case .failure(let error):
                XCTAssertNotNil(error)
            }
        }
    }
}
