//
//  TraktSync.swift
//  TraktKit
//
//  Created by Caret on 2025/4/6.
//

import Foundation

// 表示 Trakt API 请求的结构
public struct TraktSync: Encodable {
    // 请求只能是电视剧或电影之一
    let shows: [SyncShow]?
    let movies: [SyncMovie]?

    // 电视剧请求初始化
    public init(shows: [SyncShow]) {
        self.shows = shows
        self.movies = nil
    }

    // 电影请求初始化
    public init(movies: [SyncMovie]) {
        self.movies = movies
        self.shows = nil
    }

    // 自定义编码逻辑，确保只编码非 nil 字段
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        if let shows = shows {
            try container.encode(shows, forKey: .shows)
        }

        if let movies = movies {
            try container.encode(movies, forKey: .movies)
        }
    }

    private enum CodingKeys: String, CodingKey {
        case shows, movies
    }
}

// 表示电视剧的结构
public struct SyncShow: Encodable {
    let seasons: [SyncSeason]
    let ids: TraktIds

    enum CodingKeys: String, CodingKey {
        case seasons, ids
    }

    // 为了访问TraktIds内部的ids字段
    enum IdsCodingKeys: String, CodingKey {
        case ids
    }

    // TraktIds内部的ids字段中的键
    enum InnerIdsCodingKeys: String, CodingKey {
        case tmdb, tvdb, trakt, imdb
    }

    public init(seasons: [SyncSeason], ids: TraktIds) {
        self.seasons = seasons
        self.ids = ids
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        // 编码seasons字段
        try container.encode(seasons, forKey: .seasons)

        // 自定义ids字段编码逻辑
        var idsContainer = container.nestedContainer(keyedBy: InnerIdsCodingKeys.self, forKey: .ids)

        // 将TraktIds中的各个ID直接编码到ids字段中
        if let tmdb = ids.tmdb {
            try idsContainer.encode(tmdb, forKey: .tmdb)
        }
        if let tvdb = ids.tvdb {
            try idsContainer.encode(tvdb, forKey: .tvdb)
        }
        if let trakt = ids.trakt {
            try idsContainer.encode(trakt, forKey: .trakt)
        }
        if let imdb = ids.imdb {
            try idsContainer.encode(imdb, forKey: .imdb)
        }
    }
}

// 表示季度的结构
public struct SyncSeason: Encodable {
    let number: Int
    let episodes: [SyncEpisode]


    public init(number: Int, episodes: [SyncEpisode]) {
        self.number = number
        self.episodes = episodes
    }
}

// 表示剧集的结构
public struct SyncEpisode: Encodable {
    let number: Int

    public init(number: Int) {
        self.number = number
    }
}

// 表示电影的结构
public struct SyncMovie: Encodable {
    let ids: TraktIds

    enum CodingKeys: String, CodingKey {
        case ids
    }

    // 为了访问TraktIds内部的ids字段
    enum IdsCodingKeys: String, CodingKey {
        case ids
    }

    // TraktIds内部的ids字段中的键
    enum InnerIdsCodingKeys: String, CodingKey {
        case tmdb, tvdb, trakt, imdb
    }

    public init(ids: TraktIds) {
        self.ids = ids
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        // 自定义ids字段编码逻辑
        var idsContainer = container.nestedContainer(keyedBy: InnerIdsCodingKeys.self, forKey: .ids)

        // 将TraktIds中的各个ID直接编码到ids字段中
        if let tmdb = ids.tmdb {
            try idsContainer.encode(tmdb, forKey: .tmdb)
        }
        if let tvdb = ids.tvdb {
            try idsContainer.encode(tvdb, forKey: .tvdb)
        }
        if let trakt = ids.trakt {
            try idsContainer.encode(trakt, forKey: .trakt)
        }
        if let imdb = ids.imdb {
            try idsContainer.encode(imdb, forKey: .imdb)
        }
    }
}
