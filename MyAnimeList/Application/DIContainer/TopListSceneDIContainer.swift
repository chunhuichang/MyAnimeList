//
//  TopListSceneDIContainer.swift
//  MyAnimeList
//
//  Created by Jill Chang on 2022/6/26.
//

import UIKit
import CoreData

// make DIContainer or ViewController
public protocol TopListCoordinatorDependencies  {
    func makeListViewController(param: TopListCoordinator.Params?) -> UIViewController
    func makeWebSceneDIContainer() -> WebSceneDIContainer
}

public final class TopListSceneDIContainer {
    struct Dependencies {
        let loadDataLoader: DataServiceLoader
        let managedObjectContext: NSManagedObjectContext
    }
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: - Flow Coordinators
    func makeTopListCoordinator(navigationController: UINavigationController?) -> TopListCoordinator {
        return TopListCoordinator(navigationController: navigationController, dependencies: self)
    }
}

extension TopListSceneDIContainer: TopListCoordinatorDependencies {
    public func makeListViewController(param: TopListCoordinator.Params? = nil) -> UIViewController {
        // Data layer
        let repository = MainTopListRepository(loadDataLoader: self.dependencies.loadDataLoader, managedObjectContext: self.dependencies.managedObjectContext)
        // Mock
//        let repository = TopListMockRepository()
        
        // Domain layer
        let usecase = MainTopListUseCase(repository: repository)
        
        // Presentation layer
        let vm = TopListViewModel(usecase)
        
        let view = TopListViewController(viewModel: vm, posterImagesRepository: MainPosterImagesRepository(loadDataLoader: self.dependencies.loadDataLoader))
        return view
    }
    
    // MARK: - DIContainers of scenes
    public func makeWebSceneDIContainer() -> WebSceneDIContainer {
        let dependencies = WebSceneDIContainer.Dependencies()
        return WebSceneDIContainer(dependencies: dependencies)
    }
}
