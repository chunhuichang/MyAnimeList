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
    
    private struct MockRepository: TopListRepository {
        func fetchTop(queryParams: [String : String], with completion: @escaping (Result<[TopEntity], DataLoaderError>) -> Void) {
            guard let result = fetchDataTopResult else {
                completion(.failure(DataLoaderError.noResponse))
                return
            }
            completion(result)
        }
        
        func getLocalTopData() -> [TopEntity]? {
            localTopData
        }
        
        // TODO: how to test save or update event
        func saveFavoriteTop(entity: TopEntity) {
//            if localTopData == nil {
//                localTopData = [TopEntity]()
//            }
        }
        
        var fetchDataTopResult: Result<[TopEntity], DataLoaderError>?
        var localTopData: [TopEntity]?
    }

    func test_TopListUseCase__whenSuccessfullyFetch_thenDataIsQuery()  {
        let predicateFetchEntity = [
            TopEntity(malID: 111, rank: 1, title: "title1", url: "url1", imageURL: "imageURL1", type: "Movie", startDate: "Apr 2017"),
            TopEntity(malID: 222, rank: 3, title: "title2", url: "url2", imageURL: "imageURL2", type: "TV", startDate: "Apr 2015")]
        let predicateLocalEntity = [TopEntity(malID: 111, rank: 1, title: "title1", url: "url1", imageURL: "imageURL1", type: "Movie", startDate: "Apr 2017", isFavorite: true)]
        
        
        var repository = MockRepository()
        repository.fetchDataTopResult = .success(predicateFetchEntity)
        repository.localTopData = predicateLocalEntity
        
        let sut = MainTopListUseCase(repository: repository)
        
        sut.fetchTop(queryParams: [String: String]()) { result in
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
}
