//
//  URLRequestErrors.swift
//  delivery-app-main-screen
//
//  Created by Aisultan Askarov on 25.01.2024.
//

import Foundation

public enum Errors: Error {
    case invalidURL
    case invalidState
}

protocol URLSessionDataTaskProtocol {
    func resume()
}

extension URLSessionDataTask: URLSessionDataTaskProtocol {}

protocol URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol
}

class URLSessionWrapper: URLSessionProtocol {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        return session.dataTask(with: request, completionHandler: completionHandler)
    }
}
