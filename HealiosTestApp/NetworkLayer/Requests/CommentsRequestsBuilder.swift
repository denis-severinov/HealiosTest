//
//  CommentsRequestsBuilder.swift
//  HealiosTestApp
//
//  Created by Denis Severinov on 15.02.2021.
//

import Foundation

final class CommentsRequestsBuilder {
    static func getComennts(for postId: String) -> APIRequest {
        let baseURL = URL(string: Endpoints.baseUrl)!
        
        let method = HTTPMethod.get
        let path = Endpoints.comments
        let parameters = ["postId": postId]
        
        return BaseAPIRequest(baseURL: baseURL, method: method, path: path, parameters: parameters)
    }
}
