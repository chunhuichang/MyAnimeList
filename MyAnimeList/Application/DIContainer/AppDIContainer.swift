//
//  AppDIContainer.swift
//  MyAnimeList
//
//  Created by Jill Chang on 2022/6/26.
//

import Foundation
import CoreData

public final class AppDIContainer {
    
    // MARK: - Network
    let loadDataLoader = RemoteDataLoader()
    
    // MARK: - Local DB
    let managedObjectContext: NSManagedObjectContext
    
    init(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
    }
    
    // MARK: - DIContainers of scenes
    func makeTopListSceneDIContainer() -> TopListSceneDIContainer {
        let dependencies = TopListSceneDIContainer.Dependencies(loadDataLoader: loadDataLoader, managedObjectContext: managedObjectContext)
        
        return TopListSceneDIContainer(dependencies: dependencies)
    }
}
