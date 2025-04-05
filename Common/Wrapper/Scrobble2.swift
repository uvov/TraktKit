//
//  Scrobble2.swift
//  TraktKit
//
//  Created by Caret on 2025/4/5.
//

import Foundation

extension TraktManager {

    // MARK: - Start

    /**
     Use this method when the video intially starts playing or is unpaused. This will remove any playback progress if it exists.

     **Note**: A watching status will auto expire after the remaining runtime has elpased. There is no need to re-send every 15 minutes.

     🔒 OAuth: Required
     */
    @discardableResult
    public func scrobble2Start(_ scrobble: TraktScrobble2, completion: @escaping ObjectCompletionHandler<ScrobbleResult>) throws -> URLSessionDataTaskProtocol? {
        return try perform("start", scrobble: scrobble, completion: completion)
    }

    // MARK: - Pause

    /**
     Use this method when the video is paused. The playback progress will be saved and **GET** `/sync/playback` can be used to resume the video from this exact position. Unpause a video by calling the **GET** `/scrobble/start` method again.

     🔒 OAuth: Required
     */
    @discardableResult
    public func scrobble2Pause(_ scrobble: TraktScrobble2, completion: @escaping ObjectCompletionHandler<ScrobbleResult>) throws -> URLSessionDataTaskProtocol? {
        return try perform("pause", scrobble: scrobble, completion: completion)
    }

    // MARK: - Stop

    /**
     Use this method when the video is stopped or finishes playing on its own. If the progress is above 80%, the video will be scrobbled and the action will be set to **scrobble**.

     If the progress is less than 80%, it will be treated as a pause and the `action` will be set to `pause`. The playback progress will be saved and **GET** `/sync/playback` can be used to resume the video from this exact position.

     **Note**: If you prefer to use a threshold higher than 80%, you should use **GET** `/scrobble/pause` yourself so it doesn't create duplicate scrobbles.

     🔒 OAuth: Required
     */
    @discardableResult
    public func scrobble2Stop(_ scrobble: TraktScrobble2, completion: @escaping ObjectCompletionHandler<ScrobbleResult>) throws -> URLSessionDataTaskProtocol? {
        return try perform("stop", scrobble: scrobble, completion: completion)
    }

    // MARK: - Private

    @discardableResult
    func perform(_ scrobbleAction: String, scrobble: TraktScrobble2, completion: @escaping ObjectCompletionHandler<ScrobbleResult>) throws -> URLSessionDataTaskProtocol? {
        // Request
        guard let request = post("scrobble/\(scrobbleAction)", body: scrobble) else { return nil }
        return performRequest(request: request, completion: completion)
    }
}
