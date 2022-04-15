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
    
    public init(entity: TopEntity) {
        self.isFavorite.value = entity.isFavorite
        self.entity.value = entity
    }
    
    public func upadteFavorite(isFavorite: Bool) {
        self.isFavorite.value = isFavorite
        self.entity.value?.isFavorite = isFavorite
    }
}
