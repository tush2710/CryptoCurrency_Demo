//
//  FavouritesFlowCoordinator.swift
//  EquityGroupTest_TusharZade
//
//  Created by Tushar Zade on 04/03/25.
//

import UIKit

protocol FavouritesFlowCoordinatorDependencies{
    func makeFavouritesViewController(
        actions: FavouritestViewModelActions
    ) -> FavouriteVC
    
    func makeCoinsDetailsViewController(coin: Coin) -> UIViewController
}

final class FavouritesFlowCoordinator {
    private weak var navigationController: UINavigationController?
    private let dependencies: FavouritesFlowCoordinatorDependencies
    private weak var favouritetVC: FavouriteVC?
    
    init(navigationController: UINavigationController,
         dependencies: FavouritesFlowCoordinatorDependencies
    ) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start(){
        let actions = FavouritestViewModelActions(showCoinsDetails: showCoinsDetails)
        let vc = dependencies.makeFavouritesViewController(actions: actions)
        navigationController?.pushViewController(vc, animated: false)
        favouritetVC = vc
    }
    
    private func showCoinsDetails(coins: Coin) {
        let vc = dependencies.makeCoinsDetailsViewController(coin: coins)
        navigationController?.pushViewController(vc, animated: true)
    }
}
