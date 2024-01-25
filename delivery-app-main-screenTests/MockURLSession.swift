//
//  MockURLSessions.swift
//  delivery-app-main-screenTests
//
//  Created by Aisultan Askarov on 25.01.2024.
//

import Foundation

class MockURLSession: URLSessionProtocol {
    var data: Data?
    var response: URLResponse?
    var error: Error?
    var lastRequest: URLRequest?
    
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        lastRequest = request
        completionHandler(data, response, error)
        return MockURLSessionDataTask()
    }
}

class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    func resume() {}
}
