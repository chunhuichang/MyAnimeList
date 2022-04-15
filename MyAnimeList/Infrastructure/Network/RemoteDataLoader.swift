//
//  RemoteDataLoader.swift
//  MyAnimeList
//
//  Created by Jill Chang on 2022/4/13.
//

import Foundation

public enum DataLoaderError: Swift.Error {
    case noResponse
    case parseDataError(Error)
    case customerError((title: String, msg: String))
    case unknowNetworkFailure(Error)

    var description : (title: String, msg: String) {
        switch self {
        case .customerError(let messagePackage):
            return (messagePackage.title, messagePackage.msg)

        default:
            return ("網路錯誤", "伺服器沒有回應")
        }
    }
}

public enum DataLoaderResult<T> {
    case success(T)
    case failure(DataLoaderError)
}

public protocol DataServiceLoader {
    typealias CompletionHanlder<T> = (DataLoaderResult<T>) -> Void
    
    func load<T: Decodable>(type: T.Type, config: ApiConfig, completion :@escaping CompletionHanlder<T>)
}

public final class RemoteDataLoader: DataServiceLoader {
    public init() {
    }
    
    public func load<T: Decodable>(type: T.Type, config: ApiConfig, completion :@escaping CompletionHanlder<T>) {
        
        var components: URLComponents = .init()
        components.scheme = "https"
        components.host = config.host
        components.path = "\(config.path)\(config.queryString)"
        
        if config.method ==  .get, let apiParams = config.APIParameters, !apiParams.isEmpty {
            var params = "?"
            apiParams.enumerated().forEach { dict in
                params.append("\(dict.element.key)=\(dict.element.value)")
            }
            components.path = "\(components.path)\(params)"
        }
        
        guard let url = components.url else {
            completion(.failure(.customerError((title: "", msg: "url is nil"))))
            return
        }
        
        var request = URLRequest.init(url: url)
        request.httpMethod = config.method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) {  data, resp, error in
            if let err = error {
                completion(.failure(.unknowNetworkFailure(err)))
                return
            }
            
            guard let data = data else {
                return
            }
            
            if let result = try? JSONDecoder().decode(type.self, from: data) {
                DispatchQueue.main.async {
                    completion(.success(result))
                }
            } else {
                return completion(.failure(.noResponse))
            }
            
        }.resume()
    }
}
