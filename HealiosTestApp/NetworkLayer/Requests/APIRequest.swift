//
//  APIRequest.swift
//  HealiosTestApp
//
//  Created by Denis Severinov on 15.02.2021.
//

import Foundation

protocol APIRequest {
    var baseURL: URL { get }
    
    var method: HTTPMethod { get }
    var path: String { get }
    var parameters: [String: String] { get }
}

final class BaseAPIRequest: APIRequest {
    var baseURL: URL
    
    var method: HTTPMethod
    var path: String
    var parameters: [String: String]
    
    init(baseURL: URL, method: HTTPMethod, path: String, parameters: [String: String] = [String: String]()) {
        self.baseURL = baseURL
        self.method = method
        self.path = path
        self.parameters = parameters
    }
}

extension APIRequest {
    func request() -> URLRequest {
        guard var components = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: false) else {
            fatalError("Unable to create URL components")
        }

        components.queryItems = parameters.map {
            URLQueryItem(name: String($0), value: String($1))
        }

        guard let url = components.url else {
            fatalError("Could not get url")
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
}
