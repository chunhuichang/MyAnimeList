//
//  MainPosterImagesRepository.swift
//  MyAnimeList
//
//  Created by Jill Chang on 2022/4/16.
//

import Foundation

public final class MainPosterImagesRepository: PosterImagesRepository {
    
    private let loadDataLoader: DataServiceLoader
    
    public init(loadDataLoader: DataServiceLoader = RemoteDataLoader()) {
        self.loadDataLoader = loadDataLoader
    }
    
    public func fetchImage(url: URL, with completion: @escaping (Result<Data, DataLoaderError>) -> Void) {
        self.loadDataLoader.download(from: url) { data, response, error in
            if let err = error {
                completion(.failure(.unknowNetworkFailure(err)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noResponse))
                return
            }
            completion(.success(data))
        }
    }
}
