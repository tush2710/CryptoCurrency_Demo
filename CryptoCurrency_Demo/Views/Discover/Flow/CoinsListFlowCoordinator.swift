//
//  CoinsListFlowCoordinator.swift
//  EquityGroupTest_TusharZade
//
//  Created by Tushar Zade on 02/03/25.
//

import UIKit
protocol CoinsListFlowCoordinatorDependencies{
    func makeCoinsListViewController(
        actions: CoinsListViewModelActions
    ) -> DiscoverVC
    
    func makeCoinsDetailsViewController(coin: Coin) -> UIViewController
    
    func makeFavouritesViewController(actions: FavouritestViewModelActions) -> UIViewController
}

final class CoinsListFlowCoordinator {
    private weak var navigationController: UINavigationController?
    private let dependencies: CoinsListFlowCoordinatorDependencies
    private weak var coinsListVC: DiscoverVC?
    
    init(navigationController: UINavigationController,
         dependencies: CoinsListFlowCoordinatorDependencies
    ) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start(){
        let actions = CoinsListViewModelActions(showCoinsDetails: showCoinsDetails, showFavourites: showFavourites )
        let vc = dependencies.makeCoinsListViewController(actions: actions)
        navigationController?.pushViewController(vc, animated: false)
        coinsListVC = vc
    }
    
    private func showCoinsDetails(coins: Coin) {
        let vc = dependencies.makeCoinsDetailsViewController(coin: coins)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func showFavourites(){
        let actions = FavouritestViewModelActions(showCoinsDetails: showCoinsDetails )
        let vc = dependencies.makeFavouritesViewController(actions: actions)
        navigationController?.pushViewController(vc, animated: true)
    }
}
