//
//  PostDetailsViewModel.swift
//  HealiosTestApp
//
//  Created by Denis Severinov on 12.02.2021.
//

import RxSwift

final class PostDetailsViewModel {
    private let usersRepository: UsersRepository
    private let commentsRepository: CommentsRepository
    
    public let post: BehaviorSubject<Post>
    public var users: PublishSubject<User> = PublishSubject()
    public var comments: PublishSubject<Comments> = PublishSubject()
    
    public let error : PublishSubject<String> = PublishSubject()
    
    private let disposeBag = DisposeBag()
    
    init(usersRepository: UsersRepository, commentsRepository: CommentsRepository, post: Post) {
        self.commentsRepository = commentsRepository
        self.usersRepository = usersRepository
        self.post = BehaviorSubject(value: post)
    }
    
    func requestUser(with id: Int) {
        usersRepository.get(with: id)
            .subscribe { [weak self] user in
                self?.users.onNext(user)
            } onError: { [weak self] error in
                self?.error.onNext(error.localizedDescription)
            }
            .disposed(by: disposeBag)
    }
    
    func requestComments(for postId: Int) {
        commentsRepository.listAll(for: postId)
            .subscribe { [weak self] comments in
                self?.comments.onNext(comments)
            } onError: { [weak self] error in
                self?.error.onNext(error.localizedDescription)
            }
            .disposed(by: disposeBag)
    }
}
