//
//  UITableViewCell+ReuseIdentifier.swift
//  HealiosTestApp
//
//  Created by Denis Severinov on 15.02.2021.
//

import UIKit

protocol ReuseIdentifiable {
    static var reuseIdentifier: String { get }
}

extension ReuseIdentifiable {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}

extension UICollectionReusableView: ReuseIdentifiable {}

extension UITableViewCell: ReuseIdentifiable {}

