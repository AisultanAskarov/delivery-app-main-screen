//
//  ImageNetworkServiceTests.swift
//  delivery-app-main-screenTests
//
//  Created by Aisultan Askarov on 25.01.2024.
//

import XCTest
@testable import delivery_app_main_screen

final class ImageNetworkServiceTests: XCTestCase {
    
    func testGetImage_NetworkRequestSuccess() {
        // Given
        let mockCachingService = MockCachingService()
        let mockSession = MockURLSession()
        let imageNetworkService = ImageNetworkService(cachingService: mockCachingService, urlSession: mockSession)
        let mockURL = "https://example.com/image.jpg"
        let mockImageId = "1"
        let mockImageData = UIImage(systemName: "circle")?.pngData()
        mockSession.data = mockImageData
        
        // When
        imageNetworkService.getImage(forURL: mockURL, withId: mockImageId) { result in
            // Then
            switch result {
            case .success(let image):
                XCTAssertNotNil(image)
            case .failure:
                XCTFail("Expected success, got failure")
            }
        }
    }
    
    func testGetImage_NetworkRequestFailure() {
        // Given
        let mockCachingService = MockCachingService()
        let mockSession = MockURLSession()
        let imageNetworkService = ImageNetworkService(cachingService: mockCachingService, urlSession: mockSession)
        let mockURL = "https://example.com/image.jpg"
        let mockImageId = "1"
        let mockError = NSError(domain: "Test", code: 123, userInfo: nil)
        mockSession.error = mockError
        
        // When
        imageNetworkService.getImage(forURL: mockURL, withId: mockImageId) { result in
            // Then
            switch result {
            case .success:
                XCTFail("Expected failure, got success")
            case .failure(let error):
                XCTAssertEqual(error as NSError, mockError)
            }
        }
    }
}
