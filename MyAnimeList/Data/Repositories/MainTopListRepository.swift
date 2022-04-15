//
//  MainTopListRepository.swift
//  MyAnimeList
//
//  Created by Jill Chang on 2022/4/15.
//

import Foundation

public final class MainTopListRepository: TopListRepository {
    
    private let loadDataLoader: DataServiceLoader

    public init(loadDataLoader: DataServiceLoader = RemoteDataLoader()) {
        self.loadDataLoader = loadDataLoader
    }
    
    public func fetchTop(queryString: String, with completion: @escaping (Result<[TopEntity], DataLoaderError>) -> Void) {
        let api = TopApi(queryString: queryString, APIParameters: nil)
        self.loadDataLoader.load(type: TopDTO.self, config: api) {  result in
            switch(result) {
            case .success(let repositoryDTO) :
                completion(Result.success(repositoryDTO.toDomain()))
                
            case .failure(let error) :
                completion(Result.failure(error))
            }
        }
    }
    
    // MARK: core data
    public func getLocalTopData() -> [TopEntity]? {
        return nil
    }
    
    public func saveFavoriteTop(entity: TopEntity) {
        
    }
}
