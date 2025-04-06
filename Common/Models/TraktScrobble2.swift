//
//  TraktScrobble2.swift
//  TraktKit
//
//  Created by Caret on 2025/4/5.
//

import Foundation

/// 媒体内容ID模型
public struct TraktIds: Encodable {
    public let tmdb: String?
    public let tvdb: String?
    public let trakt: Int?
    public let imdb: String?

    enum CodingKeys: String, CodingKey {
        case ids
    }

    enum IdsCodingKeys: String, CodingKey {
        case tmdb, tvdb, trakt, imdb
    }

    public init(tmdb: String? = nil, tvdb: String? = nil, trakt: Int? = nil, imdb: String? = nil) {
        self.tmdb = tmdb
        self.tvdb = tvdb
        self.trakt = trakt
        self.imdb = imdb
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        var idContainer = container.nestedContainer(keyedBy: IdsCodingKeys.self, forKey: .ids)

        if let tmdb = self.tmdb {
            try idContainer.encode(tmdb, forKey: .tmdb)
        }
        if let tvdb = self.tvdb {
            try idContainer.encode(tvdb, forKey: .tvdb)
        }
        if let trakt = self.trakt {
            try idContainer.encode(trakt, forKey: .trakt)
        }
        if let imdb = self.imdb {
            try idContainer.encode(imdb, forKey: .imdb)
        }
    }
}

/// 剧集信息模型
public struct ScrobbleEpisode: Encodable {
    public let season: Int
    public let number: Int

    public init(season: Int, number: Int) {
        self.season = season
        self.number = number
    }
}

/// 媒体内容进度跟踪模型
public struct TraktScrobble2: Encodable {
    // 互斥的媒体类型
    public let movie: TraktIds?
    public let show: TraktIds?
    public let episode: ScrobbleEpisode?

    // 公共属性
    public let appDate: String?
    public let progress: Float

    enum CodingKeys: String, CodingKey {
        case movie, show, episode, appDate = "app_date", progress
    }

    /// 初始化电影进度
    public init(movie: TraktIds, progress: Float, appDate: String? = nil) {
        self.movie = movie
        self.show = nil
        self.episode = nil
        self.progress = progress
        self.appDate = appDate
    }

    /// 初始化剧集进度
    public init(show: TraktIds, episode: ScrobbleEpisode, progress: Float, appDate: String? = nil) {
        self.movie = nil
        self.show = show
        self.episode = episode
        self.progress = progress
        self.appDate = appDate
    }

    /// 创建当前日期的辅助函数
    public static func currentDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: Date())
    }
}
