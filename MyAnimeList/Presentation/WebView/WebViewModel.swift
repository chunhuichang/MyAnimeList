//
//  WebViewModel.swift
//  MyAnimeList
//
//  Created by Jill Chang on 2022/4/15.
//

import Foundation

public final class WebViewModel {
    public weak var delegate: DetailCoordinatorDelegate?
    var urlString: String
    
    public init(urlString: String) {
        self.urlString = urlString
    }
    
    public func gotoListVC() {
        self.delegate?.gotoListVC()
    }
}
