//
//  APIDataSource.swift
//  HealiosTestApp
//
//  Created by Denis Severinov on 15.02.2021.
//

import RxSwift
import RxCocoa

protocol APIDataSource {
    static var shared: APIDataSource { get }
    
    func send<T: Codable>(apiRequest: APIRequest) -> Single<T>
}

final class APIClient: APIDataSource {
    static var shared: APIDataSource = APIClient()
    
    func send<T: Codable>(apiRequest: APIRequest) -> Single<T> {
        return Single<T>.create { observer in
            let request = apiRequest.request()
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                do {
                    let model: T = try JSONDecoder().decode(T.self, from: data ?? Data())
                    observer(.success(model))
                } catch let error {
                    observer(.error(error))
                }
            }
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
}
