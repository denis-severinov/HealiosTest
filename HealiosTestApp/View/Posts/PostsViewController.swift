//
//  PostsViewController.swift
//  HealiosTestApp
//
//  Created by Denis Severinov on 12.02.2021.
//

import UIKit
import RxCocoa
import RxSwift

class PostsViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    
    private let viewModel = PostsViewModel(postsRepository: CoreDataPostsRepository.shared)
    
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationController()
        configureTableView()
        
        viewModel.error
            .subscribe { [weak self] error in
                self?.showNetworkAlert(with: error)
            }
            .disposed(by: disposeBag)
        
        viewModel.updatePosts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    private func configureNavigationController() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic
    }
    
    private func configureTableView() {
        tableView.register(UINib(nibName: PostTableViewCell.reuseIdentifier, bundle: nil),
                           forCellReuseIdentifier: String(describing: PostTableViewCell.self))
        
        tableView.rx
            .modelSelected(Post.self)
            .subscribe(onNext: { [weak self] post in
                guard let self = self else { return }
                
                self.showPostDetials(post)
            })
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe { [weak self] indexPath in
                self?.tableView.deselectRow(at: indexPath, animated: true)
            }
            .disposed(by: disposeBag)
        
        
        viewModel.posts.bind(to: tableView.rx.items(cellIdentifier: PostTableViewCell.reuseIdentifier,
                                                    cellType: PostTableViewCell.self)) {  (row, post, cell) in
            cell.post = post
        }
        .disposed(by: disposeBag)
    }
    
    private func showPostDetials(_ post: Post) {
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "PostDetailsViewController") as? PostDetailsViewController
        else { return }
        
        let viewModel = PostDetailsViewModel(usersRepository: CoreDataUsersRepository.shared,
                                             commentsRepository: CoreDataCommentsRepository.shared,
                                             post: post)
        vc.viewModel = viewModel
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func showNetworkAlert(with error: String) {
        let title = "Network error"
        let alert = AlertManager.createAlert(with: title, message: error, okTitle: "OK") { }
        
        present(alert, animated: true)
    }
}

