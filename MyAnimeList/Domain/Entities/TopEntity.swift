//
//  TopEntity.swift
//  MyAnimeList
//
//  Created by Jill Chang on 2022/4/12.
//

import Foundation

public struct TopEntity {
    internal init(malID: Int, rank: Int, title: String, url: String, imageURL: String, type: String, startDate: String, endDate: String? = nil, isFavorite: Bool = false) {
        self.malID = malID
        self.rank = rank
        self.title = title
        self.url = url
        self.imageURL = imageURL
        self.type = type
        self.startDate = startDate
        self.endDate = endDate
        self.isFavorite = isFavorite
    }
    
    let malID: Int
    let rank: Int
    let title: String
    let url: String
    let imageURL: String
    let type: String
    let startDate: String
    let endDate: String?
    let isFavorite: Bool

//    enum TypeEnum: String {
//        case tv = "TV"
//        case movie = "Movie"
//        case ova = "OVA"
//        case special = "Special"
//        case music = "Music"
//        case ona = "ONA"
//        case manga = "Manga"
//        case novel = "Novel"
//        case oneShot = "One-shot"
//        case doujinshi = "Doujinshi"
//        case manhwa = "Manhwa"
//        case manhua = "Manhua"
//    }
}
/*
 {
   "mal_id": 23390,
   "rank": 1,
   "title": "Shingeki no Kyojin",
   "url": "https://myanimelist.net/manga/23390/Shingeki_no_Kyojin",
   "type": "Manga",
   "volumes": 34,
   "start_date": "Sep 2009",
   "end_date": "Apr 2021",
   "members": 569898,
   "score": 8.58,
   "image_url": "https://cdn.myanimelist.net/images/manga/2/37846.jpg?s=bdda4d1c1d85237aead7d545f876c077"
 }
 */
