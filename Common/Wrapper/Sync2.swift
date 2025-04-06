//
//  Sync2.swift
//  TraktKit
//
//  Created by Caret on 2025/4/6.
//

import Foundation

extension TraktManager {
    /**
     Add items to a user's watch history. Accepts shows, seasons, episodes and movies. If only a show is passed, all episodes for the show will be added. If seasons are specified, only episodes in those seasons will be added.

     Send a `watched_at` UTC datetime to mark items as watched in the past. This is useful for syncing past watches from a media center.

     Status Code: 201

     🔒 OAuth: Required

     - parameter movies: array of movie objects
     - parameter shows: array of show objects
     - parameter episodes: array of episode objects
     - parameter completion: completion handler
     */
    @discardableResult
    public func addToHistory2(movies: TraktSync? = nil, shows: TraktSync? = nil, completion: @escaping ObjectCompletionHandler<AddToHistoryResult>) throws -> URLSessionDataTaskProtocol? {
        // 检查参数并确定请求体
        let body: TraktSync?

        if movies != nil && shows != nil {
            return nil
            body = movies
        } else if movies != nil {
            body = movies
        } else if shows != nil {
            body = shows
        } else {
            // 两者都不存在，返回 nil
            return nil
        }

        // 确保 body 不为 nil 并创建请求
        guard let requestBody = body,
              let request = post("sync/history", body: requestBody) else {
            return nil
        }

        return performRequest(request: request, completion: completion)
    }
}
