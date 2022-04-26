//
//  AppCoordinator.swift
//  MyAnimeList
//
//  Created by Jill Chang on 2022/4/15.
//

import UIKit
import CoreData

public protocol AppCoordinatorDelegate: AnyObject {
    func gotoWebVC(entity: TopEntity)
}

public final class AppCoordinator: AppCoordinatorDelegate {
    public var rootVC: UIViewController?
    
    private let managedObjectContext: NSManagedObjectContext?
    
    public init(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
    }
    
    public func start() {
        let loadDataLoader = RemoteDataLoader()
        let repository = MainTopListRepository(loadDataLoader: loadDataLoader, managedObjectContext: managedObjectContext)
        //Mock
//        let repository = TopListMockRepository()
        let usecase = MainTopListUseCase(repository: repository)
        let vm = TopListViewModel(usecase)
        vm.delegate = self
        self.rootVC =  TopListViewController(viewModel: vm, posterImagesRepository: MainPosterImagesRepository(loadDataLoader: loadDataLoader))
    }
    
    public func gotoWebVC(entity: TopEntity) {
        let coordinator = DetailCoordinator()
        coordinator.start(entity: entity)
        
        guard let nextVC = coordinator.rootVC else {
            return
        }
        
        self.rootVC?.present(nextVC, animated: true, completion: nil)
    }
}
