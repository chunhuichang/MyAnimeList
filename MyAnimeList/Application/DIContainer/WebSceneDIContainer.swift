//
//  WebSceneDIContainer.swift
//  MyAnimeList
//
//  Created by Jill Chang on 2022/6/26.
//

import UIKit

// make DIContainer or ViewController
public protocol WebCoordinatorDependencies {
    func makeWebViewController(param: WebCoordinator.Params) -> UIViewController
}

public final class WebSceneDIContainer {
    struct Dependencies {
    }
    
    private let dependencies: Dependencies
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: - Flow Coordinators
    func makeWebCoordinator(navigationController: UINavigationController?, param: WebCoordinator.Params?) -> WebCoordinator {
        return WebCoordinator(navigationController: navigationController, dependencies: self, param: param)
    }
}

extension WebSceneDIContainer: WebCoordinatorDependencies {
    public func makeWebViewController(param: WebCoordinator.Params) -> UIViewController {
        // Presentation layer
        let vm = WebViewModel(entity: param.entity)
        let vc = WebViewController(viewModel: vm)
        return vc
    }
}
