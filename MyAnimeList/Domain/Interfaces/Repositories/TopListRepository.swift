//
//  TopListRepository.swift
//  MyAnimeList
//
//  Created by Jill Chang on 2022/4/13.
//

import Foundation

public protocol TopListRepository {
    func fetchTop(queryParams: [String: String], with completion: @escaping (Result<[TopEntity], DataLoaderError>) -> Void)
    
    func getLocalTopData() -> [TopEntity]?
    
    func saveFavoriteTop(entity: TopEntity)
}
