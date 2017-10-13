//
//  Coordinator.swift
//  lily
//
//  Created by Nathan Chan on 9/13/17.
//  Copyright © 2017 Nathan Chan. All rights reserved.
//

import UIKit
import SafariServices

protocol Coordinator: class {
    var childCoordinators: [Coordinator] { get set }
    func start()
}

extension Coordinator {
    public func addChildCoordinator(_ childCoordinator: Coordinator) {
        self.childCoordinators.append(childCoordinator)
    }
    
    public func removeChildCoordinator(_ childCoordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators.filter { $0 !== childCoordinator }
    }
}

protocol NavigationCoordinator: Coordinator {
    var navigationController: UINavigationController { get set }
    init(navigationController: UINavigationController)
}

protocol TabBarCoordinator: Coordinator {
    var tabBarController: UITabBarController { get set }
    init(tabBarController: UITabBarController)
}

extension NavigationCoordinator {
    func openUrlInModal(_ url: URL?) {
        if let url = url {
            if UIApplication.shared.canOpenURL(url) {
                let vc = SFSafariViewController(url: url, entersReaderIfAvailable: false)
                vc.modalPresentationStyle = .overFullScreen
                self.navigationController.present(vc, animated: true, completion: nil)
            } else {
                let alertController = UIAlertController(title: "Error", message: "URL is invalid. Maybe it's missing http:// ?", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alertController.addAction(okAction)
                self.navigationController.present(alertController, animated: true, completion: nil)
            }
        }
    }
}
