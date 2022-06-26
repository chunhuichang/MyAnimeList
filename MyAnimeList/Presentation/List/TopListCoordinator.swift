//
//  ListCoordinator.swift
//  MyAnimeList
//
//  Created by Jill Chang on 2022/6/14.
//

import UIKit
import CoreData

// Current Coordinator send to prev Coordinator
public protocol TopListDelegate: AnyObject {}

// Current Coordinator go to next Coordinator
public protocol TopListCoordinatorDelegate: AnyObject {
    func gotoWebVC(entity: TopEntity)
}

public final class TopListCoordinator {
    public struct Params {}
    
    private weak var navigationController: UINavigationController?
    private let dependencies: TopListCoordinatorDependencies
    
    public init(navigationController: UINavigationController?, dependencies: TopListCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    public func start() {
        guard let vc = dependencies.makeListViewController(param: nil) as? TopListViewController else {
            fatalError("Casting to ViewController fail")
        }
        vc.viewModel.coordinatorDelegate = self
        navigationController?.pushViewController(vc, animated: false)
        
        // Top List does need tool bar
        vc.navigationController?.setNavigationBarHidden(true, animated: false)
        vc.navigationController?.setToolbarHidden(true, animated: false)
    }
    
}

extension TopListCoordinator: TopListCoordinatorDelegate {
    public func gotoWebVC(entity: TopEntity) {
        // Web does need tool bar
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.setToolbarHidden(false, animated: false)
        
        let DIContainer = dependencies.makeWebSceneDIContainer()
        let coordinator = DIContainer.makeWebCoordinator(navigationController: navigationController, param: WebCoordinator.Params(entity: entity))
        coordinator.start()
    }
}

extension TopListCoordinator: TopListDelegate{}
