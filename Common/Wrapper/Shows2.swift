//
//  Shows2.swift
//  TraktKit
//
//  Created by Caret on 2025/4/15.
//

import Foundation

extension TraktManager {
    /**
     Returns watched progress for show including details on all seasons and episodes. The `next_episode` will be the next episode the user should watch, if there are no upcoming episodes it will be set to `null`. By default, any hidden seasons will be removed from the response and stats. To include these and adjust the completion stats, set the `hidden` flag to `true`.

     🔒 OAuth: Required
     */
    @discardableResult
    public func getShowWatchedProgress2<T: CustomStringConvertible>(showID id: T, hidden: Bool = false, specials: Bool = false, completion: @escaping ShowWatchedProgressCompletionHandler) -> URLSessionDataTaskProtocol? {
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
                guard
                    let request = self.mutableRequest(forPath: "shows/\(id)/progress/watched",
                                                 withQuery: ["hidden": "\(hidden)",
                                                             "specials": "\(specials)"],
                                                 isAuthorized: true,
                                                 withHTTPMethod: .GET) else {
                    completion(.error(error: NSError(domain: "com.litteral.TraktKit", code: -1, userInfo: [NSLocalizedDescriptionKey: "无法创建请求"])))
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
