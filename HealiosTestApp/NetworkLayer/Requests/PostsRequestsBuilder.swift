//
//  PostsRequestsBuilder.swift
//  HealiosTestApp
//
//  Created by Denis Severinov on 15.02.2021.
//

import Foundation

final class PostsRequestsBuilder {
    static func getAllPostsRequest() -> APIRequest {
        let baseURL = URL(string: Endpoints.baseUrl)!
        let method = HTTPMethod.get
        let path = Endpoints.posts
        
        return BaseAPIRequest(baseURL: baseURL, method: method, path: path)
    }
}
