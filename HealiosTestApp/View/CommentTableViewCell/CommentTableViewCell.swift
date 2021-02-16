//
//  CommentTableViewCell.swift
//  HealiosTestApp
//
//  Created by Denis Severinov on 15.02.2021.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    var comment: Comment? {
        didSet {
            nameLabel.text = comment?.name
            emailLabel.text = comment?.email
            bodyLabel.text = comment?.body
        }
    }
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var bodyLabel: UILabel!
}
