//
//  AppCoordinator.swift
//  MyAnimeList
//
//  Created by Jill Chang on 2022/4/15.
//

import UIKit

public final class AppCoordinator {
    private let navigationController: UINavigationController
    private let appDIContainer: AppDIContainer
    
    public init(navigationController: UINavigationController,  appDIContainer: AppDIContainer) {
        self.navigationController = navigationController
        self.appDIContainer = appDIContainer
    }
    
    public func start() {
        let DIContainer = appDIContainer.makeTopListSceneDIContainer()
        let coordinator = DIContainer.makeTopListCoordinator(navigationController: navigationController)
        coordinator.start()
    }
}
