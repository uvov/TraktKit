//
//  Users2.swift
//  TraktKit
//
//  Created by Maximilian Litteral on 10/18/15.
//  Copyright © 2015 Maximilian Litteral. All rights reserved.
//

import Foundation

/**
 User's with public data will return info with all GET methods. Private user's (inlcuding yourself) require valid OAuth and a friend relationship to return data.

 ***Special username for the OAuth user***

 If you send valid OAuth, you can use `me` for the username to identify the OAuth user instead of needing their actual username. You can of course still use their actual username, it's up to you.

 ***Creating New Users***

 Since the API uses OAuth, users can create a new account during that flow if they need to. As far as your app is concerned, you'll still receive OAuth tokens no matter if they sign in with an existing account or create a new one.
 */
extension TraktManager {

    // MARK: - Profile

    /**
     Get a user's profile information. If the user is private, info will only be returned if you send OAuth and are either that user or an approved follower.

     🔓 OAuth Optional
     */
    @discardableResult
    public func getUserProfile2(username: String = "me", extended: [ExtendedType] = [.Min], completion: @escaping ObjectCompletionHandler<User>) -> URLSessionDataTaskProtocol? {
        let authorization = username == "me" ? true : false

        // 如果需要授权(即username为"me")，先检查令牌状态
        if authorization {
            var taskToReturn: URLSessionDataTaskProtocol?

            checkToRefresh { [weak self] result in
                guard let self = self else {
                    completion(.error(error: NSError(domain: "com.litteral.TraktKit", code: -1, userInfo: [NSLocalizedDescriptionKey: "Self was deallocated"])))
                    return
                }

                switch result {
                case .success:
                    // 令牌有效或已刷新，继续执行原来的操作
                    guard let request = self.mutableRequest(forPath: "users/\(username)",
                                                          withQuery: ["extended": extended.queryString()],
                                                          isAuthorized: true,
                                                          withHTTPMethod: .GET) else {
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
        } else {
            // 不需要授权，直接执行请求
            guard let request = mutableRequest(forPath: "users/\(username)",
                                             withQuery: ["extended": extended.queryString()],
                                             isAuthorized: false,
                                             withHTTPMethod: .GET) else { return nil }
            return performRequest(request: request, completion: completion)
        }
    }
}
