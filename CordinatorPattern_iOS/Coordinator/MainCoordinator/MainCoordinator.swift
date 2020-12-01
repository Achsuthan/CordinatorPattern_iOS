//
//  MainCoordinator.swift
//  CordinatorPattern_iOS
//
//  Created by achsum on 29/11/20.
//  Copyright © 2020 Achsuthan. All rights reserved.
//

import Foundation
import UIKit

class MainCoordinator: NSObject, Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigation: UINavigationController
    
    init(_ navigation: UINavigationController) {
        self.navigation = navigation
    }
    
    //MARK: - Starting page for root
    func start() {
        self.navigation.delegate = self
        let vc = MainViewController(nibName: nil, bundle: nil)
        vc.title = "Home Page"
        vc.mainCoordinator = self
        self.navigation.viewControllers = [vc]
    }
    
    
    func childDidFinish(_ child: Coordinator?) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
    
    
    //MARK: - Push the details view controller
    func viewDetails(){
        let detailsCordinator = DetailsCoordinator(self.navigation)
        self.childCoordinators.append(detailsCordinator)
        detailsCordinator.parentCoordinator = self
        detailsCordinator.start()
    }
    
    //MARK: - Present the AuthViewcontroller with navigation controller
    func viewAuth(){
        let authCordinator = AuthCoordinator(self.navigation)
        self.childCoordinators.append(authCordinator)
        authCordinator.parentCoordinator = self
        authCordinator.start()
    }
}

extension MainCoordinator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        // Read the view controller we’re moving from.
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else {
            return
        }
        
        // Check whether our view controller array already contains that view controller. If it does it means we’re pushing a different view controller on top rather than popping it, so exit.
        if navigationController.viewControllers.contains(fromViewController) {
            return
        }
        
        // We’re still here – it means we’re popping the view controller, so we can check whether it’s a buy view controller
        if let detailsViewController = fromViewController as? DetailsViewController {
            // We're popping a buy view controller; end its coordinator
            self.childDidFinish(detailsViewController.detailsCoordinator)
        }
    }
}


