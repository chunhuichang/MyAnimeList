//
//  TopListMockRepository.swift
//  MyAnimeList
//
//  Created by Jill Chang on 2022/4/14.
//

import Foundation

final class TopListMockRepository: TopListRepository {
    func fetchTop(queryString: String, with completion: @escaping (Result<[TopEntity], DataLoaderError>) -> Void) {
        guard let entities = self.fetchEntities else {
            completion(.failure(.noResponse))
            return
        }
        completion(.success(entities))
    }
    
    func getLocalTopData() -> [TopEntity]? {
        localEntities
    }
    
    func saveFavoriteTop(entity: TopEntity) {
        if var localEntity = localEntities?.first(where: { $0.malID == entity.malID }) {
            localEntity.isFavorite = entity.isFavorite
        }
    }
    
   
    public var fetchEntities: [TopEntity]?
    public var localEntities: [TopEntity]?
    
    init() {
        fetchEntities = [
           TopEntity(malID: 23390, rank: 1, title: "Shingeki no Kyojin", url: "https://myanimelist.net/manga/23390/Shingeki_no_Kyojin", imageURL: "https://cdn.myanimelist.net/images/manga/2/37846.jpg?s=bdda4d1c1d85237aead7d545f876c077", type: "Manga", startDate: "Sep 2009", endDate: "Apr 2021"),
           TopEntity(malID: 2, rank: 2, title: "Berserk", url: "https://myanimelist.net/manga/2/Berserk", imageURL: "https://cdn.myanimelist.net/images/manga/1/157897.jpg?s=f03b5f8bfeb0b0962b7d5e7cb9a8d0d3", type: "Manga", startDate: "Aug 1989", endDate: "Sep 2021"),
           TopEntity(malID: 13, rank: 3, title: "One Piece", url: "https://myanimelist.net/manga/13/One_Piece", imageURL: "https://cdn.myanimelist.net/images/manga/2/253146.jpg?s=e5286481ed2b4c11ab39d1420110dc43", type: "Manga", startDate: "Jul 1997")]

        localEntities = nil
    }
}
