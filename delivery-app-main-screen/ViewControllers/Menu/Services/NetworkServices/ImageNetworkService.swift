//
//  ImageNetworkService.swift
//  delivery-app-main-screen
//
//  Created by Aisultan Askarov on 15.01.2024.
//

import UIKit

protocol ImageNetworkServiceProtocol {
    func getImage(forURL imageURL: String, completion: @escaping (Result<Data, Error>) -> Void)
}

final class ImageNetworkService: ImageNetworkServiceProtocol {
    private let urlSession: URLSession

    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }

    func getImage(forURL imageURL: String, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: imageURL) else {
            completion(.failure(Errors.invalidURL))
            return
        }

        let request = urlSession.dataTask(with: URLRequest(url: url)) { data, _, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                completion(.success(data))
            }
        }

        request.resume()
    }
}

extension UIImageView {
    func setImage(fromURL urlString: String, using imageNetworkService: ImageNetworkServiceProtocol = ImageNetworkService()) {
        imageNetworkService.getImage(forURL: urlString) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.image = UIImage(data: data)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
