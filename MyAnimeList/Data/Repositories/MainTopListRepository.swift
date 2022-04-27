//
//  MainTopListRepository.swift
//  MyAnimeList
//
//  Created by Jill Chang on 2022/4/15.
//

import Foundation
import CoreData

public final class MainTopListRepository: TopListRepository {
    
    private let loadDataLoader: DataServiceLoader
    private var managedObjectContext: NSManagedObjectContext? = nil
    private let entityName = "AnimeFavorite"

    public init(loadDataLoader: DataServiceLoader = RemoteDataLoader(), managedObjectContext: NSManagedObjectContext? = nil) {
        self.loadDataLoader = loadDataLoader
        self.managedObjectContext = managedObjectContext
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
        var result: [TopEntity]? = nil
        if let context = self.managedObjectContext {
            
            let fetchFavorite = AnimeFavorite.fetchRequest()
            
            //sortDescriptor is require
            let sortDescriptor = NSSortDescriptor(key: "malID", ascending: true)
            fetchFavorite.sortDescriptors = [sortDescriptor]
            
            let fetchResultsController = NSFetchedResultsController(fetchRequest: fetchFavorite, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            do {
                try fetchResultsController.performFetch()
                let fetchedObjects = fetchResultsController.fetchedObjects
                
                result = fetchedObjects?.map({ entity in
                    TopEntity(malID: Int(entity.malID), rank: Int(entity.rank), title: entity.title ?? "", url: entity.url ?? "", imageURL: entity.imageURL ?? "", type: entity.type ?? "", startDate: entity.startDate, endDate: entity.endDate, isFavorite: true)
                })
                
            } catch {
                fatalError("\(error)")
            }
        }
        return result
    }
    
    private func saveFavoriteTop(entity: TopEntity) {
        guard let context = self.managedObjectContext, let insertObj = NSEntityDescription.insertNewObject(forEntityName: entityName, into: context) as? AnimeFavorite else {
            return
        }
        
        insertObj.malID = Int64(entity.malID)
        insertObj.rank = Int64(entity.rank)
        insertObj.title = entity.title
        insertObj.url = entity.url
        insertObj.imageURL = entity.imageURL
        insertObj.type = entity.type
        insertObj.startDate = entity.startDate
        insertObj.endDate = entity.endDate
        
        do {
            try context.save()
        } catch {
            fatalError("\(error)")
        }
    }
    
    private func deleteFavoriteTop(entity: TopEntity) {
        guard let context = self.managedObjectContext else {
            return
        }
        let deleteRequest = NSFetchRequest<AnimeFavorite>(entityName: entityName)
        deleteRequest.predicate = NSPredicate(format: "malID == %@", "\(entity.malID)")
        
        
        do {
            let results = try context.fetch(deleteRequest)
            
            if !results.isEmpty {
                for result in results {
                    context.delete(result)
                }
                try context.save()
            }
        } catch {
            fatalError("\(error)")
        }
    }
    
    public func updateFavoriteTop(entity: TopEntity) {
        if entity.isFavorite {
            saveFavoriteTop(entity: entity)
        } else {
            deleteFavoriteTop(entity: entity)
        }
    }
}
