//
//  PostsViewModel.swift
//  HealiosTestApp
//
//  Created by Denis Severinov on 12.02.2021.
//

import Foundation
import RxSwift
import RxCocoa

final class PostsViewModel {
    private let postsRepository: PostsRepository
    
    let posts: PublishSubject<Posts> = PublishSubject()
    let error: PublishSubject<String> = PublishSubject()
    
    private let disposeBag = DisposeBag()
    
    init(postsRepository: PostsRepository) {
        self.postsRepository = postsRepository
    }
    
    func updatePosts() {
        postsRepository.listAll()
            .subscribe {  [weak self] in
                self?.posts.onNext($0)
            } onError: { [weak self] in
                self?.error.onNext($0.localizedDescription)
            }
            .disposed(by: disposeBag)
    }
}
