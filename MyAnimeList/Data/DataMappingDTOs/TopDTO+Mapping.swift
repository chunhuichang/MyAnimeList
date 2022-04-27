//
//  TopDTO+Mapping.swift
//  MyAnimeList
//
//  Created by Jill Chang on 2022/4/15.
//

import Foundation

public struct TopDTO: Decodable{
    var requestHash: String?
    var requestCached: Bool?
    var requestCacheExpiry: Int?
    var apiDeprecation: Bool?
    var apiDeprecationDate: String?
    var apiDeprecationInfo: String?
    var top: [TopElementDTO]?
   
    struct TopElementDTO: Decodable {
        var malID: Int
        var rank: Int
        var title: String
        var url: String
        var imageURL: String
        var type: String
        var episodes: Episodes?
        var startDate: StratDateUnion?
        var endDate: EndDateUnion?
        var members: Int?
        var score: Double?
        var isFavorite: Bool?
        
        struct EmptyClass: Codable {
        }

        enum StratDateUnion: Codable {
            case emptyClass(EmptyClass)
            case string(String)

            init(from decoder: Decoder) throws {
                let container = try decoder.singleValueContainer()
                if let x = try? container.decode(String.self) {
                    self = .string(x)
                    return
                }
                if let x = try? container.decode(EmptyClass.self) {
                    self = .emptyClass(x)
                    return
                }
                throw DecodingError.typeMismatch(EndDateUnion.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for EndDateUnion"))
            }

            func encode(to encoder: Encoder) throws {
                var container = encoder.singleValueContainer()
                switch self {
                case .emptyClass(let x):
                    try container.encode(x)
                case .string(let x):
                    try container.encode(x)
                }
            }
        }
        
        enum EndDateUnion: Codable {
            case emptyClass(EmptyClass)
            case string(String)

            init(from decoder: Decoder) throws {
                let container = try decoder.singleValueContainer()
                if let x = try? container.decode(String.self) {
                    self = .string(x)
                    return
                }
                if let x = try? container.decode(EmptyClass.self) {
                    self = .emptyClass(x)
                    return
                }
                throw DecodingError.typeMismatch(EndDateUnion.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for EndDateUnion"))
            }

            func encode(to encoder: Encoder) throws {
                var container = encoder.singleValueContainer()
                switch self {
                case .emptyClass(let x):
                    try container.encode(x)
                case .string(let x):
                    try container.encode(x)
                }
            }
        }
        
        enum Episodes: Codable {
            case emptyClass(EmptyClass)
            case integer(Int)

            init(from decoder: Decoder) throws {
                let container = try decoder.singleValueContainer()
                if let x = try? container.decode(Int.self) {
                    self = .integer(x)
                    return
                }
                if let x = try? container.decode(EmptyClass.self) {
                    self = .emptyClass(x)
                    return
                }
                throw DecodingError.typeMismatch(Episodes.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for Episodes"))
            }

            func encode(to encoder: Encoder) throws {
                var container = encoder.singleValueContainer()
                switch self {
                case .emptyClass(let x):
                    try container.encode(x)
                case .integer(let x):
                    try container.encode(x)
                }
            }
        }
    }
}

private extension TopDTO {
    private enum CodingKeys: String, CodingKey {
         case requestHash = "request_hash"
         case requestCached = "request_cached"
         case requestCacheExpiry = "request_cache_expiry"
         case apiDeprecation = "API_DEPRECATION"
         case apiDeprecationDate = "API_DEPRECATION_DATE"
         case apiDeprecationInfo = "API_DEPRECATION_INFO"
         case top
     }
}

private extension TopDTO.TopElementDTO {
    private enum CodingKeys: String, CodingKey {
        case malID = "mal_id"
        case rank, title, url
        case imageURL = "image_url"
        case type, episodes
        case startDate = "start_date"
        case endDate = "end_date"
        case members, score
    }
}

extension TopDTO {
    public func toDomain() -> [TopEntity] {
        guard let tops = top else { return [TopEntity]() }
        return tops.map { $0.toDomain() }
    }
}

extension TopDTO.TopElementDTO {
    func toDomain() -> TopEntity {
        var tmpStartDate: String?
        switch startDate {
        case .string(let str):
            tmpStartDate = str
        default:
            tmpStartDate = nil
        }
        
        var tmpEndDate: String?
        switch endDate {
        case .string(let str):
            tmpEndDate = str
        default:
            tmpEndDate = nil
        }
        
        return TopEntity(malID: malID, rank: rank, title: title, url: url, imageURL: imageURL, type: type, startDate: tmpStartDate, endDate: tmpEndDate, isFavorite: false)
    }
}
