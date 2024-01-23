//
//  ImageNetworkService.swift
//  delivery-app-main-screen
//
//  Created by Aisultan Askarov on 15.01.2024.
//

import UIKit

protocol ImageNetworkServiceProtocol {
    func getImage(forURL imageURL: String, withId id: String, completion: @escaping (Result<UIImage, Error>) -> Void)
}

final class ImageNetworkService: ImageNetworkServiceProtocol {
    private let cachingService: CachingService
    private let urlSession: URLSession

    init(cachingService: CachingService = .shared, urlSession: URLSession = .shared) {
        self.cachingService = cachingService
        self.urlSession = urlSession
    }

    func getImage(forURL imageURL: String, withId id: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        if let cachedResponse = cachingService.loadImage(forKey: id) {
            completion(.success(cachedResponse))
            return
        }
        
        guard let url = URL(string: imageURL) else {
            completion(.failure(Errors.invalidURL))
            return
        }

        let request = urlSession.dataTask(with: URLRequest(url: url)) { [cachingService] data, _, error in
            print("Fetched Image")
            switch (data, error) {
            case let (.some(data), nil):
                let image = UIImage(data: data) ?? UIImage()
                cachingService.cacheImage(image, forKey: id)
                completion(.success(image))
            case let (.none, .some(error)):
                completion(.failure(error))
            default:
                completion(.failure(Errors.invalidState))
            }
        }
        
        request.resume()
    }
}

extension UIImageView {
    func setImage(fromURL urlString: String, withId id: String, using imageNetworkService: ImageNetworkServiceProtocol = ImageNetworkService()) {
        imageNetworkService.getImage(forURL: urlString, withId: id) { result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    self.image = image
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
