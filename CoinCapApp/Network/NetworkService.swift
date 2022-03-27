//
//  NetworkService.swift
//  CoinCapApp
//
//  Created by d.leonova on 23.03.2022.
//

import Foundation

struct NetworkError: Error {
    var message: String?
    let code: Int
}

final class NetworkService {
    private let session = URLSession(configuration: .default)
    
    func request<Model: Decodable>(
        _ request: Request,
        comletion: @escaping(Result<Model, NetworkError>) -> Void
    ) {
        var urlComponents = URLComponents()
        urlComponents.scheme = request.scheme
        urlComponents.host = request.host
        urlComponents.path = request.path
        urlComponents.queryItems = request.requestModel?.queryItems ?? []

        guard let url = urlComponents.url else {
            comletion(.failure(NetworkError(message: "NetworkError. Incorrect url", code: 1000)))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        request.headers?.forEach { urlRequest.setValue($0.value, forHTTPHeaderField: $0.key) }
        
        let task = session.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                comletion(.failure(NetworkError(message: error.localizedDescription, code: 1)))
                return
            }
            
            guard let data = data else {
                comletion(.failure(NetworkError(message: "Empty data", code: 5)))
                return
            }
            
            do {
                let result = try JSONDecoder().decode(Model.self, from: data)
                comletion(.success(result))
            } catch {
                print(error.localizedDescription)
                comletion(.failure(NetworkError(message: "Decode error", code: 10)))
                return
            }
        }
        task.resume()
    }
}
