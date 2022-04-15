//
//  ApiConfig.swift
//  MyAnimeList
//
//  Created by Jill Chang on 2022/4/15.
//

import Foundation

public enum HTTPRestfulType: String {
    case get     = "GET"
    case post    = "POST"
}

public protocol ApiConfig {
    var host: String { get }
    var path: String { get }
    var queryString: String { get }
    var method: HTTPRestfulType { get }
    var APIParameters: [String: Any]? { get set }
}
