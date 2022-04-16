//
//  AppCoordinator.swift
//  MyAnimeList
//
//  Created by Jill Chang on 2022/4/15.
//

import UIKit

public protocol AppCoordinatorDelegate: AnyObject {
    func gotoWebVC(entity: TopEntity)
}

public final class AppCoordinator: AppCoordinatorDelegate {
    public var rootVC: UIViewController?
    
    public func start() {
        let loadDataLoader = RemoteDataLoader()
        let repository = MainTopListRepository(loadDataLoader: loadDataLoader)
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
