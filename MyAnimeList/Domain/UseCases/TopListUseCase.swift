//
//  TopListUseCase.swift
//  MyAnimeList
//
//  Created by Jill Chang on 2022/4/13.
//

import Foundation

public protocol TopListUseCase {
    func fetchTop(queryParams: [String: String], with completion: @escaping (Result<[TopEntity], DataLoaderError>) -> Void)
    
    func getLocalTopData() -> [TopEntity]?
    
    func saveFavoriteTop(entity: TopEntity)
}
public final class MainTopListUseCase: TopListUseCase {
    public let repository: TopListRepository
    
    public init(repository: TopListRepository) {
        self.repository = repository
    }
    
    public func fetchTop(queryParams: [String : String], with completion: @escaping (Result<[TopEntity], DataLoaderError>) -> Void) {
        let localData: [TopEntity]
        if let data = getLocalTopData() {
            localData = data
        } else {
            localData = [TopEntity]()
        }
        
        self.repository.fetchTop(queryParams: queryParams) {[weak self] result in
            guard let self = self else {
                completion(.failure(.noResponse))
                return
            }
            
            switch result {
            case .success(let entities):
                completion(.success(self.mapFavoriteData(loaclData: localData, fetchData: entities)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func mapFavoriteData(loaclData: [TopEntity], fetchData: [TopEntity]) -> [TopEntity] {
        
        return fetchData.map { entity in
            let isFav = loaclData.firstIndex { $0.malID == entity.malID } != nil
            return TopEntity(malID: entity.malID, rank: entity.rank, title: entity.title, url: entity.url, imageURL: entity.imageURL, type: entity.type, startDate: entity.startDate, endDate: entity.endDate, isFavorite: isFav)
        }
    }
    
    public func getLocalTopData() -> [TopEntity]? {
        self.repository.getLocalTopData()
    }
    
    public func saveFavoriteTop(entity: TopEntity) {
        self.repository.saveFavoriteTop(entity: entity)
    }
}
