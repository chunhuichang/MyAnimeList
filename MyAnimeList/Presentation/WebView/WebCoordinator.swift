//
//  DetailCoordinator.swift
//  MyAnimeList
//
//  Created by Jill Chang on 2022/4/15.
//

import UIKit

// Current Coordinator send to prev Coordinator
public protocol WebDelegate: AnyObject {}

// Current Coordinator go to next Coordinator
public protocol WebCoordinatorDelegate: AnyObject {
    func close()
}

public final class WebCoordinator {
    public struct Params {
        let entity: TopEntity
    }
    
    private weak var navigationController: UINavigationController?
    private let dependencies: WebCoordinatorDependencies
    private let param: Params?
    
    init(navigationController: UINavigationController?, dependencies: WebCoordinatorDependencies, param: WebCoordinator.Params?) {
        self.navigationController = navigationController
        self.dependencies = dependencies
        self.param = param
    }
    
    func start() {
        guard let param = param else {
            fatalError("inject param can't be nil")
        }
        
        guard let vc = dependencies.makeWebViewController(param: param) as? WebViewController else {
            fatalError("Casting to ViewController fail")
        }
        
        vc.viewModel.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension WebCoordinator: WebCoordinatorDelegate {
    public func close() {
        // Top List does not need tool bar
        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationController?.setToolbarHidden(true, animated: false)
        
        navigationController?.popViewController(animated: true)
    }
}

extension WebCoordinator: WebDelegate {}
