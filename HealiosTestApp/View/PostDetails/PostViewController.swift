//
//  PostDetailsViewController.swift
//  HealiosTestApp
//
//  Created by Denis Severinov on 12.02.2021.
//

import UIKit
import RxSwift

final class PostDetailsViewController: UIViewController {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var bodyLabel: UILabel!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    
    var viewModel: PostDetailsViewModel!
    
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationController()
        configureTableView()
        
        viewModel.post
            .map { $0.title }
            .bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.post
            .map { $0.body }
            .bind(to: bodyLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.users
            .map { $0.name }
            .bind(to: usernameLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.post
            .map { $0.userId }
            .subscribe { [weak self] in
                guard let element = $0.element else { return }
                self?.viewModel.requestUser(with: element)
            }
            .disposed(by: disposeBag)
        
        viewModel.post
            .map { $0.id }
            .subscribe { [weak self] postId in
                self?.viewModel.requestComments(for: postId)
            }
            .disposed(by: disposeBag)
        
        viewModel.error
            .subscribe{ [weak self] error in
                self?.showNetworkAlert(with: error)
            }
            .disposed(by: disposeBag)
    }
    
    private func configureNavigationController() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .never
    }
    
    
    private func configureTableView() {
        tableView.register(UINib(nibName: CommentTableViewCell.reuseIdentifier, bundle: nil),
                           forCellReuseIdentifier: String(describing: CommentTableViewCell.self))
        
        tableView.rx.itemSelected
            .subscribe { [weak self] indexPath in
                self?.tableView.deselectRow(at: indexPath, animated: true)
            }
            .disposed(by: disposeBag)
        
        
        viewModel.comments.bind(to: tableView.rx.items(cellIdentifier: CommentTableViewCell.reuseIdentifier,
                                                       cellType: CommentTableViewCell.self)) {  (row, comment, cell) in
            cell.comment = comment
        }
        .disposed(by: disposeBag)
    }
    
    private func showNetworkAlert(with error: String) {
        let title = "Network error"
        let alert = AlertManager.createAlert(with: title, message: error, okTitle: "OK") { }
        
        present(alert, animated: true)
    }
}
