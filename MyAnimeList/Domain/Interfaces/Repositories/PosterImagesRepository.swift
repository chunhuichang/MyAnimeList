//
//  PosterImagesRepository.swift
//  MyAnimeList
//
//  Created by Jill Chang on 2022/4/16.
//

import Foundation

public protocol PosterImagesRepository {
    func fetchImage(url: URL, with completion: @escaping (Result<Data, DataLoaderError>) -> Void)
}
