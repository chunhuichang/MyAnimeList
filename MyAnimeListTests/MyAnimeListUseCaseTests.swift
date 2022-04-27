//
//  MyAnimeListUseCaseTests.swift
//  MyAnimeListUseCaseTests
//
//  Created by Jill Chang on 2022/4/9.
//

import XCTest
import Nimble
@testable import MyAnimeList

class MyAnimeListUseCaseTests: XCTestCase {
    
    private final class MockRepository: TopListRepository {
        func fetchTop(queryString: String, with completion: @escaping (Result<[TopEntity], DataLoaderError>) -> Void) {
            guard let result = fetchDataTopResult else {
                completion(.failure(DataLoaderError.noResponse))
                return
            }
            completion(result)
        }
        
        func getLocalTopData() -> [TopEntity]? {
            localTopData
        }
        
        func updateFavoriteTop(entity: TopEntity) {
            guard var localTopData = localTopData else {
                return
            }
            if entity.isFavorite {
                localTopData.append(entity)
                
            } else {
                localTopData.removeAll(where: { $0.malID == entity.malID })
            }
            self.localTopData = localTopData
        }
        
        var fetchDataTopResult: Result<[TopEntity], DataLoaderError>?
        var localTopData: [TopEntity]?
        
        init(fetchDataTopResult: Result<[TopEntity], DataLoaderError>? = nil, localTopData: [TopEntity]? = nil) {
            self.fetchDataTopResult = fetchDataTopResult
            self.localTopData = localTopData
        }
    }
    
    func test_TopListUseCase__whenSuccessfullyFetchTopApi_thenDataIsQuery()  {
        let predicateFetchEntity = [
            TopEntity(malID: 111, rank: 1, title: "title1", url: "url1", imageURL: "imageURL1", type: "Movie", startDate: "Apr 2017"),
            TopEntity(malID: 222, rank: 3, title: "title2", url: "url2", imageURL: "imageURL2", type: "TV", startDate: "Apr 2015")]
        let predicateLocalEntity = [TopEntity(malID: 111, rank: 1, title: "title1", url: "url1", imageURL: "imageURL1", type: "Movie", startDate: "Apr 2017", isFavorite: true)]
        
        
        let repository = MockRepository(fetchDataTopResult: .success(predicateFetchEntity), localTopData: predicateLocalEntity)
        
        let sut = MainTopListUseCase(repository: repository)
        
        sut.fetchTop(queryString: "") { result in
            switch result {
            case .success(let entities):
                expect(entities.count) == predicateFetchEntity.count
                expect(entities[0].malID) == predicateFetchEntity[0].malID
                expect(entities[0].isFavorite) == predicateLocalEntity[0].isFavorite
            case .failure:
                XCTFail("fetchTop failure")
            }
        }
    }
    
    func test_TopListUseCase__whenSuccessfullyFetchLocalData_thenDataIsQuery()  {
        let predicateLocalEntity = [TopEntity(malID: 111, rank: 1, title: "title1", url: "url1", imageURL: "imageURL1", type: "Movie", startDate: "Apr 2017", isFavorite: true)]
        
        let repository = MockRepository(fetchDataTopResult: nil, localTopData: predicateLocalEntity)
        
        let sut = MainTopListUseCase(repository: repository)
        
        let result = sut.getLocalTopData()
        expect(result?.count) == predicateLocalEntity.count
        expect(result?[0].malID) == predicateLocalEntity[0].malID
        expect(result?[0].isFavorite) == predicateLocalEntity[0].isFavorite
    }
    
    func test_TopListUseCase__whenUpdateLocalData_thenDataIsInsert()  {
        let predicateLocalEntity = [TopEntity(malID: 111, rank: 1, title: "title1", url: "url1", imageURL: "imageURL1", type: "Movie", startDate: "Apr 2017", isFavorite: true)]
        
        let repository = MockRepository(fetchDataTopResult: nil, localTopData: predicateLocalEntity)
        
        let sut = MainTopListUseCase(repository: repository)
        sut.updateFavoriteTop(entity: TopEntity(malID: 555, rank: 1, title: "title1", url: "url1", imageURL: "imageURL1", type: "Movie", startDate: "Apr 2017", isFavorite: true))
        
        let result = sut.getLocalTopData()
        expect(result?.count) == 2
    }
    
    func test_TopListUseCase__whenUpdateLocalData_thenDataIsDelete()  {
        let predicateLocalEntity = [TopEntity(malID: 111, rank: 1, title: "title1", url: "url1", imageURL: "imageURL1", type: "Movie", startDate: "Apr 2017", isFavorite: true)]
        
        let repository = MockRepository(fetchDataTopResult: nil, localTopData: predicateLocalEntity)
        
        let sut = MainTopListUseCase(repository: repository)
        sut.updateFavoriteTop(entity: TopEntity(malID: 111, rank: 1, title: "title1", url: "url1", imageURL: "imageURL1", type: "Movie", startDate: "Apr 2017", isFavorite: false))
        
        let result = sut.getLocalTopData()
        expect(result?.count) == 0
    }
    
    func test_TOPJsonString() {
        let JSON = """
        {
          "request_hash": "request:top:06dfba4e4f4423169acee0f04a14dea786f40261",
          "request_cached": true,
          "request_cache_expiry": 93354,
          "API_DEPRECATION": true,
          "API_DEPRECATION_DATE": "2022-02-10T16:02:50+00:00",
          "API_DEPRECATION_INFO": "https://bit.ly/jikan-v3-deprecation",
          "top": [
                {
                  "mal_id": 36456,
                  "rank": 25,
                  "title": "Boku no Hero Academia 3rd Season",
                  "url": "https://myanimelist.net/anime/36456/Boku_no_Hero_Academia_3rd_Season",
                  "image_url": "https://cdn.myanimelist.net/images/anime/1319/92084.jpg?s=35232941f9c872fd1f5af37fa389452b",
                  "type": "TV",
                  "episodes": 25,
                  "start_date": "Apr 2018",
                  "end_date": "Sep 2018",
                  "members": 1861243,
                  "score": 8.1
                },
                {
                  "mal_id": 21,
                  "rank": 26,
                  "title": "One Piece",
                  "url": "https://myanimelist.net/anime/21/One_Piece",
                  "image_url": "https://cdn.myanimelist.net/images/anime/6/73245.jpg?s=f792b8c9e28534ae455d06b15e686a14",
                  "type": "TV",
                  "episodes": {},
                  "start_date": "Oct 1999",
                  "end_date": {},
                  "members": 1832953,
                  "score": 8.63
                },
                {
                  "mal_id": 22199,
                  "rank": 27,
                  "title": "Akame ga Kill!",
                  "url": "https://myanimelist.net/anime/22199/Akame_ga_Kill",
                  "image_url": "https://cdn.myanimelist.net/images/anime/1429/95946.jpg?s=54a1d4bcd881957ce164297f36df5a72",
                  "type": "TV",
                  "episodes": 24,
                  "start_date": "Jul 2014",
                  "end_date": "Dec 2014",
                  "members": 1813038,
                  "score": 7.47
                },
                {
                  "mal_id": 10620,
                  "rank": 28,
                  "title": "Mirai Nikki (TV)",
                  "url": "https://myanimelist.net/anime/10620/Mirai_Nikki_TV",
                  "image_url": "https://cdn.myanimelist.net/images/anime/13/33465.jpg?s=47381246925211d3873b932cba7b2703",
                  "type": "TV",
                  "episodes": 26,
                  "start_date": "Oct 2011",
                  "end_date": "Apr 2012",
                  "members": 1810806,
                  "score": 7.45
                }
          ]
        }
        """

        let jsonData = JSON.data(using: .utf8)!
        let dto: TopDTO = try! JSONDecoder().decode(TopDTO.self, from: jsonData)
        let entities = dto.toDomain()
        
        expect(entities.count) == 4
        expect(entities.first?.malID) == dto.top?.first?.malID
    }
}
