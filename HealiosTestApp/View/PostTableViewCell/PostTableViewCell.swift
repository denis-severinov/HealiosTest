//
//  PostTableViewCell.swift
//  HealiosTestApp
//
//  Created by Denis Severinov on 15.02.2021.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var bodyLabel: UILabel!
    
    var post: Post? {
        didSet {
            titleLabel.text = post?.title
            bodyLabel.text = post?.body
        }
    }
}
