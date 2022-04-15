//
//  TopDTO+Mapping.swift
//  MyAnimeList
//
//  Created by Jill Chang on 2022/4/15.
//

import Foundation

public struct TopDTO: Decodable{
    public var requestHash: String?
    public var requestCached: Bool?
    public var requestCacheExpiry: Int?
    public var apiDeprecation: Bool?
    public var apiDeprecationDate: String?
    public var apiDeprecationInfo: String?
    public var top: [TopElementDTO]?
   
    enum CodingKeys: String, CodingKey {
        case requestHash = "request_hash"
        case requestCached = "request_cached"
        case requestCacheExpiry = "request_cache_expiry"
        case apiDeprecation = "API_DEPRECATION"
        case apiDeprecationDate = "API_DEPRECATION_DATE"
        case apiDeprecationInfo = "API_DEPRECATION_INFO"
        case top
    }

    public struct TopElementDTO: Decodable {
        public var malID: Int
        public var rank: Int
        public var title: String
        public var url: String
        public var imageURL: String
        public var type: String
        public var episodes: Episodes?
        public var startDate: StratDateUnion?
        public var endDate: EndDateUnion?
        public var members: Int?
        public var score: Double?
        public var isFavorite: Bool?
        
        enum CodingKeys: String, CodingKey {
            case malID = "mal_id"
            case rank, title, url
            case imageURL = "image_url"
            case type, episodes
            case startDate = "start_date"
            case endDate = "end_date"
            case members, score
        }
        
        
        public struct EmptyClass: Codable {
        }

        public enum StratDateUnion: Codable {
            case emptyClass(EmptyClass)
            case string(String)

            public init(from decoder: Decoder) throws {
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

            public func encode(to encoder: Encoder) throws {
                var container = encoder.singleValueContainer()
                switch self {
                case .emptyClass(let x):
                    try container.encode(x)
                case .string(let x):
                    try container.encode(x)
                }
            }
        }
        
        public enum EndDateUnion: Codable {
            case emptyClass(EmptyClass)
            case string(String)

            public init(from decoder: Decoder) throws {
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

            public func encode(to encoder: Encoder) throws {
                var container = encoder.singleValueContainer()
                switch self {
                case .emptyClass(let x):
                    try container.encode(x)
                case .string(let x):
                    try container.encode(x)
                }
            }
        }
        
        public enum Episodes: Codable {
            case emptyClass(EmptyClass)
            case integer(Int)

            public init(from decoder: Decoder) throws {
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

            public func encode(to encoder: Encoder) throws {
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

extension TopDTO {
    public func toDomain() -> [TopEntity] {
        guard let tops = top else { return [TopEntity]() }
        return tops.map { $0.toDomain() }
    }
}

extension TopDTO.TopElementDTO {
    public func toDomain() -> TopEntity {
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
