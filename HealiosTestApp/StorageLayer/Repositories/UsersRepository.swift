//
//  UsersRepository.swift
//  HealiosTestApp
//
//  Created by Denis Severinov on 15.02.2021.
//

import RxSwift

protocol UsersRepository {
    func get(with id: Int) -> Single<User>
    func add(_ entity: User) throws -> User
    func update(_ entity: User) throws
    func delete(_ entity: User) throws
}

final class CoreDataUsersRepository: UsersRepository {
    private let dataController: CoreDataController
    private let remoteSource: APIDataSource
    
    private var disposeBag = DisposeBag()
    
    public static var shared: CoreDataUsersRepository = {
        CoreDataUsersRepository(dataController: CoreDataController.shared, remoteSource: APIClient.shared)
    }()
    
    private init(dataController: CoreDataController, remoteSource: APIDataSource) {
        self.dataController = dataController
        self.remoteSource = remoteSource
    }
    
    func get(with id: Int) -> Single<User> {
        let predicate = NSPredicate(format: "id == \(id)")
        if let managedUser = dataController.fetchManagedObjects(ofType: ManagedUser.self, predicate: predicate).first {
            return Single<User>
                .create { single in
                    let mapper = UserMapper.default
                    var user = User()
                    
                    mapper.map(from: managedUser, to: &user)
                    
                    single(.success(user))
                    
                    return Disposables.create()
                }
        } else {
            return requestUser(with: id)
        }
    }
    
    func add(_ entity: User) throws -> User {
        if let _: ManagedUser = dataController.fetchManagedObject(withIdentifier: entity.id, includeSubentities: false) {
            try? update(entity)
            return entity
        }
        
        guard let managedObject = dataController.createManagedObject(ofType: ManagedUser.self) else {
            throw RepositoryError.failedToInsertObject
        }
        
        let mapper = UserMapper.default
        
        mapper.map(from: entity, to: managedObject)
        
        dataController.save()
        
        var resultTransaction = User()
        mapper.map(from: managedObject, to: &resultTransaction)
        
        return resultTransaction
    }
    
    func update(_ entity: User) throws {
        guard let managedObject: ManagedUser = dataController.fetchManagedObject(withIdentifier: entity.id, includeSubentities: false) else {
            throw RepositoryError.failedToUpdateObject
        }
        
        let mapper = UserMapper.default
        
        mapper.map(from: entity, to: managedObject)
        
        dataController.save()
    }
    
    func delete(_ entity: User) throws {
        dataController.deleteObject(withIdentifier: entity.id)
        dataController.save()
    }
}

// MARK: - Remote Source
extension CoreDataUsersRepository {
    func requestUser(with id: Int) -> Single<User> {
        let apiRequest = UsersRequestBuilder.getUser(with: "\(id)")
        
        let usersPublisher: Single<Users> = remoteSource.send(apiRequest: apiRequest)
        let userPublisher = usersPublisher.map {
            $0.first ?? .init()
        }
        
        userPublisher
            .subscribe { [weak self] in
                _ = try? self?.add($0)
            }
            .disposed(by: disposeBag)
        
        return userPublisher
    }
}
