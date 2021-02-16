//
//  AlertManager.swift
//  HealiosTestApp
//
//  Created by Denis Severinov on 15.02.2021.
//

import UIKit

final class AlertManager {
    public static func createAlert(with title: String,
                                   message: String,
                                   okTitle: String,
                                   okAction: (() -> Void)? = nil) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if let okAction = okAction {
            let okAlertAction = UIAlertAction(title: okTitle, style: .default, handler: { _ in okAction() })
            alert.addAction(okAlertAction)
        }
        
        return alert
    }
    
    public static func createAlertWithActivityIndicator() -> UIAlertController {
        let alert = UIAlertController(title: "Loading", message: nil, preferredStyle: .alert)
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.isUserInteractionEnabled = false
        activityIndicator.startAnimating()

        alert.view.addSubview(activityIndicator)
        alert.view.heightAnchor.constraint(equalToConstant: 95).isActive = true

        activityIndicator.centerXAnchor.constraint(equalTo: alert.view.centerXAnchor, constant: 0).isActive = true
        activityIndicator.bottomAnchor.constraint(equalTo: alert.view.bottomAnchor, constant: -20).isActive = true

        return alert
    }
}
