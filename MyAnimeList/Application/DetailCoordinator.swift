//
//  DetailCoordinator.swift
//  MyAnimeList
//
//  Created by Jill Chang on 2022/4/15.
//

import UIKit

public protocol DetailCoordinatorDelegate: AnyObject {
    func gotoListVC()
}

public final class DetailCoordinator: DetailCoordinatorDelegate {
    public var rootVC: UIViewController?
    
    public func start(entity: TopEntity) {
        let vm = WebViewModel(urlString: entity.url)
        vm.delegate = self
        let vc = WebViewController(viewModel: vm)
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        self.rootVC = nav
    }
    
    public func gotoListVC() {
        self.rootVC?.dismiss(animated: true, completion: nil)
    }
}
