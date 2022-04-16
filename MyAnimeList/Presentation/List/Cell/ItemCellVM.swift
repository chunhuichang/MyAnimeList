//
//  ItemCellVM.swift
//  MyAnimeList
//
//  Created by Jill Chang on 2022/4/15.
//

import Foundation

public final class ItemCellVM {
    var isFavorite: Box<Bool> = Box(nil)
    var entity: Box<TopEntity> = Box(nil)
    var imageData: Box<Data> = Box(nil)
    
    private var posterImagesRepository: PosterImagesRepository?
    
    public init(entity: TopEntity, posterImagesRepository: PosterImagesRepository?) {
        self.isFavorite.value = entity.isFavorite
        self.entity.value = entity
        self.posterImagesRepository = posterImagesRepository
    }
    
    public func upadteFavorite(isFavorite: Bool) {
        self.isFavorite.value = isFavorite
        self.entity.value?.isFavorite = isFavorite
    }
    
    public func fetchImage() {
        guard let posterImagePath = entity.value?.imageURL, let url = URL(string: posterImagePath) else {
            return
        }
        
        posterImagesRepository?.fetchImage(url: url, with: { result in
            switch result {
            case .success(let data):
                self.imageData.value = data
            case.failure(let error):
                fatalError("error:\(error)")
            }
        })
    }
}
