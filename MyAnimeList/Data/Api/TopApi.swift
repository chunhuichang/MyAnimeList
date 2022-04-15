//
//  TopApi.swift
//  MyAnimeList
//
//  Created by Jill Chang on 2022/4/15.
//

import Foundation

public struct TopApi: ApiConfig {
    public let host = "api.jikan.moe"

    public let path = "/v3/top"
    
    public var queryString = "/anime/1/upcoming"
        
    public let method = HTTPRestfulType.get
    
    public var APIParameters: [String : Any]?
}
//https://api.jikan.moe/v3/top/anime/1/upcoming
