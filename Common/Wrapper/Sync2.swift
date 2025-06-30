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
        } else if movies != nil {
            body = movies
        } else if shows != nil {
            body = shows
        } else {
            // 两者都不存在，返回 nil
            return nil
        }

        // 确保 body 不为 nil
        guard let requestBody = body else {
            return nil
        }

        // 先检查令牌状态
        var taskToReturn: URLSessionDataTaskProtocol?

        checkToRefresh { [weak self] result in
            guard let self = self else {
                completion(.error(error: NSError(domain: "com.litteral.TraktKit", code: -1, userInfo: [NSLocalizedDescriptionKey: "Self was deallocated"])))
                return
            }

            switch result {
            case .success:
                // 令牌有效或已刷新，继续执行原来的操作
                guard let request = self.post("sync/history", body: requestBody) else {
                    completion(.error(error: NSError(domain: "com.litteral.TraktKit", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to create request"])))
                    return
                }

                taskToReturn = self.performRequest(request: request, completion: completion)

            case .failure(let error):
                // 令牌无效且无法刷新，返回错误
                completion(.error(error: error))
            }
        }

        return taskToReturn
    }

    /**
     Remove items from a user's watch history including all watches, scrobbles, and checkins. Accepts shows and movies. If only a show is passed, all episodes for the show will be removed.

     Status Code: 200

     🔒 OAuth: Required

     - parameter movies: movie objects
     - parameter shows: show objects
     - parameter completion: completion handler
     */
    @discardableResult
    public func removeFromHistory2(movies: TraktSync? = nil, shows: TraktSync? = nil, completion: @escaping ObjectCompletionHandler<RemoveFromHistoryResult>) throws -> URLSessionDataTaskProtocol? {
        // 检查参数并确定请求体
        let body: TraktSync?

        if movies != nil && shows != nil {
            return nil
        } else if movies != nil {
            body = movies
        } else if shows != nil {
            body = shows
        } else {
            // 两者都不存在，返回 nil
            return nil
        }

        // 确保 body 不为 nil
        guard let requestBody = body else {
            return nil
        }

        // 先检查令牌状态
        var taskToReturn: URLSessionDataTaskProtocol?

        checkToRefresh { [weak self] result in
            guard let self = self else {
                completion(.error(error: NSError(domain: "com.litteral.TraktKit", code: -1, userInfo: [NSLocalizedDescriptionKey: "Self was deallocated"])))
                return
            }

            switch result {
            case .success:
                // 令牌有效或已刷新，继续执行原来的操作
                guard let request = self.post("sync/history/remove", body: requestBody) else {
                    completion(.error(error: NSError(domain: "com.litteral.TraktKit", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to create request"])))
                    return
                }

                taskToReturn = self.performRequest(request: request, completion: completion)

            case .failure(let error):
                // 令牌无效且无法刷新，返回错误
                completion(.error(error: error))
            }
        }

        return taskToReturn
    }
}
