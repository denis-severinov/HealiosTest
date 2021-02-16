//
//  PostsRepository.swift
//  HealiosTestApp
//
//  Created by Denis Severinov on 16.02.2021.
//

import RxSwift

protocol PostsRepository {
    func listAll() -> Single<Posts>
    func add(_ entity: Post) throws -> Post
    func update(_ entity: Post) throws
    func delete(_ entity: Post) throws
}

final class CoreDataPostsRepository: PostsRepository {
    private let dataController: CoreDataController
    private let remoteSource: APIDataSource
    
    private var disposeBag = DisposeBag()
    
    public static var shared: CoreDataPostsRepository = {
        CoreDataPostsRepository(dataController: CoreDataController.shared, remoteSource: APIClient.shared)
    }()
    
    private init(dataController: CoreDataController, remoteSource: APIDataSource) {
        self.dataController = dataController
        self.remoteSource = remoteSource
    }
    
    func listAll() -> Single<Posts> {
        let managedUsers = self.dataController.fetchManagedObjects(ofType: ManagedPost.self)
        
        if managedUsers.isEmpty {
            return requestPosts()
        } else {
            return Single<Posts>.create { single in
                let mapper = PostMapper.default
                let posts: Posts = managedUsers.map {
                    var post = Post()
                    mapper.map(from: $0, to: &post)
                    
                    return post
                }
            
                single(.success(posts))
                
                return Disposables.create()
            }
        }
    }
    
    func add(_ entity: Post) throws -> Post {
        if let _: ManagedPost = dataController.fetchManagedObject(withIdentifier: entity.id, includeSubentities: false) {
            try? update(entity)
            return entity
        }
        
        guard let managedObject = dataController.createManagedObject(ofType: ManagedPost.self) else {
            throw RepositoryError.failedToInsertObject
        }
        
        let mapper = PostMapper.default
        
        mapper.map(from: entity, to: managedObject)
        
        dataController.save()
        
        var resultTransaction = Post()
        mapper.map(from: managedObject, to: &resultTransaction)
        
        return resultTransaction
    }
    
    func update(_ entity: Post) throws {
        guard let managedObject: ManagedPost = dataController.fetchManagedObject(withIdentifier: entity.id, includeSubentities: false) else {
            throw RepositoryError.failedToUpdateObject
        }
        
        let mapper = PostMapper.default
        
        mapper.map(from: entity, to: managedObject)
        
        dataController.save()
    }
    
    func delete(_ entity: Post) throws {
        dataController.deleteObject(withIdentifier: entity.id)
        dataController.save()
    }
}

// MARK: - Remote Source
private extension CoreDataPostsRepository {
    func requestPosts() -> Single<Posts> {
        let apiRequest = PostsRequestsBuilder.getAllPostsRequest()
        
        let postsPublisher: Single<Posts> = remoteSource.send(apiRequest: apiRequest)
        
        postsPublisher
            .subscribe {[weak self] in
                $0.forEach {
                    _ = try? self?.add($0)
                    
                }
            }
            .disposed(by: disposeBag)
        
        return postsPublisher
    }
}
