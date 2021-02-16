//
//  CommentsRepository.swift
//  HealiosTestApp
//
//  Created by Denis Severinov on 16.02.2021.
//

import RxSwift

protocol CommentsRepository {
    func listAll(for postId: Int) -> Single<Comments>
    func add(_ entity: Comment) throws -> Comment
    func update(_ entity: Comment) throws
    func delete(_ entity: Comment) throws
}

final class CoreDataCommentsRepository: CommentsRepository {
    private let dataController: CoreDataController
    private let remoteSource: APIDataSource
    
    private var disposeBag = DisposeBag()
    
    public static var shared: CoreDataCommentsRepository = {
        CoreDataCommentsRepository(dataController: CoreDataController.shared, remoteSource: APIClient.shared)
    }()
    
    private init(dataController: CoreDataController, remoteSource: APIDataSource) {
        self.dataController = dataController
        self.remoteSource = remoteSource
    }
    
    func listAll(for postId: Int) -> Single<Comments> {
        let predicate = NSPredicate(format: "postId == \(postId)")
        let managedUsers = self.dataController.fetchManagedObjects(ofType: ManagedComment.self, predicate: predicate)
        
        if managedUsers.isEmpty {
            return requestComments(for: postId)
        } else {
            return Single<Comments>.create { single in
                let mapper = CommentMapper.default
                let comments: Comments = managedUsers.map {
                    var comment = Comment()
                    mapper.map(from: $0, to: &comment)
                    
                    return comment
                }
                
                single(.success(comments))
                
                return Disposables.create()
            }
        }
    }
    
    func add(_ entity: Comment) throws -> Comment {
        if let _: ManagedComment = dataController.fetchManagedObject(withIdentifier: entity.id, includeSubentities: false) {
            try? update(entity)
            return entity
        }
        
        guard let managedObject = dataController.createManagedObject(ofType: ManagedComment.self) else {
            throw RepositoryError.failedToInsertObject
        }
        
        let mapper = CommentMapper.default
        
        mapper.map(from: entity, to: managedObject)
        
        dataController.save()
        
        var resultTransaction = Comment()
        mapper.map(from: managedObject, to: &resultTransaction)
        
        return resultTransaction
    }
    
    func update(_ entity: Comment) throws {
        guard let managedObject: ManagedComment = dataController.fetchManagedObject(withIdentifier: entity.id, includeSubentities: false) else {
            throw RepositoryError.failedToUpdateObject
        }
        
        let mapper = CommentMapper.default
        
        mapper.map(from: entity, to: managedObject)
        
        dataController.save()
    }
    
    func delete(_ entity: Comment) throws {
        dataController.deleteObject(withIdentifier: entity.id)
        dataController.save()
    }
}

// MARK: - Remote source
extension CoreDataCommentsRepository {
    func requestComments(for postId: Int) -> Single<Comments> {
        let apiRequest = CommentsRequestsBuilder.getComennts(for: "\(postId)")
        let commentsPublisher: Single<Comments> = remoteSource.send(apiRequest: apiRequest)
        
        commentsPublisher
            .subscribe {[weak self] in
                $0.forEach {
                    _ = try? self?.add($0)
                    
                }
            }
            .disposed(by: disposeBag)
        
        return commentsPublisher
    }
}
