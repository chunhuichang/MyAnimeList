//
//  RemoteDataLoader.swift
//  MyAnimeList
//
//  Created by Jill Chang on 2022/4/13.
//

import Foundation

public enum DataLoaderError: Swift.Error {
    case noResponse
    case parseDataError(Error)
    case customerError((title: String, msg: String))
    case unknowNetworkFailure(Error)

    var description : (title: String, msg: String) {
        switch self {
        case .customerError(let messagePackage):
            return (messagePackage.title, messagePackage.msg)

        default:
            return ("網路錯誤", "伺服器沒有回應")
        }
    }
}

public enum DataLoaderResult<T> {
    case success(T)
    case failure(DataLoaderError)
}
