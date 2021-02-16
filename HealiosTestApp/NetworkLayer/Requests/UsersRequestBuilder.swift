//
//  UsersRequestBuilder.swift
//  HealiosTestApp
//
//  Created by Denis Severinov on 15.02.2021.
//

import Foundation

final class UsersRequestBuilder {
    static func getAllUsersRequest() -> APIRequest {
        let baseURL = URL(string: Endpoints.baseUrl)!
        let method = HTTPMethod.get
        let path = Endpoints.users
        
        return BaseAPIRequest(baseURL: baseURL, method: method, path: path)
    }
    
    static func getUser(with id: String) -> APIRequest {
        let baseURL = URL(string: Endpoints.baseUrl)!
        
        let method = HTTPMethod.get
        let path = Endpoints.users
        let parameters = ["id": id]
        
        return BaseAPIRequest(baseURL: baseURL, method: method, path: path, parameters: parameters)
    }
}
