//
//  MyAnimeListViewModelTests.swift
//  MyAnimeListTests
//
//  Created by Jill Chang on 2022/4/13.
//

import XCTest
import Nimble
@testable import MyAnimeList

class MyAnimeListViewModelTests: XCTestCase {
    
    private struct MockUseCase: TopListUseCase {
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
        
        // TODO: how to test save or update event
        func updateFavoriteTop(entity: TopEntity) {
            //            if localTopData == nil {
            //                localTopData = [TopEntity]()
            //            }
        }
        
        var fetchDataTopResult: Result<[TopEntity], DataLoaderError>?
        var localTopData: [TopEntity]?
    }
    
    func test_TopListVM__whenFetchDataTrigger_thenListDataChange() {
        let predicateFetchEntity = [
            TopEntity(malID: 111, rank: 1, title: "title1", url: "url1", imageURL: "imageURL1", type: "Movie", startDate: "Apr 2017", isFavorite: true),
            TopEntity(malID: 222, rank: 3, title: "title2", url: "url2", imageURL: "imageURL2", type: "TV", startDate: "Apr 2015")]
        let predicateLocalEntity = [TopEntity(malID: 111, rank: 1, title: "title1", url: "url1", imageURL: "imageURL1", type: "Movie", startDate: "Apr 2017", isFavorite: true)]
        
        var usecase = MockUseCase()
        usecase.fetchDataTopResult = .success(predicateFetchEntity)
        usecase.localTopData = predicateLocalEntity
        
        let sut = makeSUT(usecase: usecase)
        sut.subtypeData.value = [("airing",  true),("upcoming", false)]
        
        sut.listData.binding(trigger: false) { newValue, _ in
            if let entities = newValue {
                expect(entities.count) == predicateFetchEntity.count
                expect(entities[0].malID) == predicateFetchEntity[0].malID
            } else {
                XCTFail("resultData is nil")
            }
        }

        sut.input.fetchDataTrigger.value = ()
    }
    
    // TODO: how to verify save data
//    func test_TopListVM__whenSaveDataTrigger_thenLocalDataChange() {
//        let predicateFetchEntity = [
//            TopEntity(malID: 111, rank: 1, title: "title1", url: "url1", imageURL: "imageURL1", type: "Movie", startDate: "Apr 2017", isFavorite: true),
//            TopEntity(malID: 222, rank: 3, title: "title2", url: "url2", imageURL: "imageURL2", type: "TV", startDate: "Apr 2015")]
//        let predicateLocalEntity = [TopEntity(malID: 111, rank: 1, title: "title1", url: "url1", imageURL: "imageURL1", type: "Movie", startDate: "Apr 2017", isFavorite: true)]
//
//        var usecase = MockUseCase()
//        usecase.fetchDataTopResult = .success(predicateFetchEntity)
//        usecase.localTopData = predicateLocalEntity
//
//        let sut = makeSUT(usecase: usecase)
//
//        sut.listData.binding(trigger: false) { newValue, _ in
//            if let entities = newValue {
//                expect(entities.count) == predicateFetchEntity.count
//                expect(entities[0].malID) == predicateFetchEntity[0].malID
//            } else {
//                XCTFail("resultData is nil")
//            }
//        }
//
//
//        sut.input.saveDataTrigger.value = ()
//    }
    
    
    func test_TopListVM__whentypeClick_thenSubtypeChange() {
        
        let predicateFetchEntity = [
            TopEntity(malID: 111, rank: 1, title: "title1", url: "url1", imageURL: "imageURL1", type: "Movie", startDate: "Apr 2017", isFavorite: true),
            TopEntity(malID: 222, rank: 3, title: "title2", url: "url2", imageURL: "imageURL2", type: "TV", startDate: "Apr 2015")]
        let predicateLocalEntity = [TopEntity(malID: 111, rank: 1, title: "title1", url: "url1", imageURL: "imageURL1", type: "Movie", startDate: "Apr 2017", isFavorite: true)]
        
        var usecase = MockUseCase()
        usecase.fetchDataTopResult = .success(predicateFetchEntity)
        usecase.localTopData = predicateLocalEntity
        
        let sut = makeSUT(usecase: usecase)
        
        let typeClickIndex = 1
        
        sut.typeIndex.binding(trigger: false) { newValue, _ in
            if let index = newValue {
                expect(index) == typeClickIndex
            } else {
                XCTFail("resultData is nil")
            }
        }
        
        sut.subtypeData.binding(trigger: false) { newValue, _ in
            if let data = newValue {
                let predicateData = sut.typeSubtype["\(sut.typeNames[typeClickIndex])"]
                
                expect(data.count) == predicateData?.count
            } else {
                XCTFail("resultData is nil")
            }
        }
        
        sut.typeClick(index: typeClickIndex)
    }
    
    private func makeSUT(usecase: MockUseCase) -> TopListViewModel {
        return TopListViewModel(usecase)
    }
}
