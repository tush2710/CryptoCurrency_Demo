//
//  CoinsSceneDIContainer.swift
//  EquityGroupTest_TusharZade
//
//  Created by Tushar Zade on 02/03/25.
//

import Foundation
import SwiftUI

final class CoinsSceneDIContainer: CoinsListFlowCoordinatorDependencies {
    struct Dependencies {
        let apiDataTransferService: DataTransferService
    }
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func makeCoinsListViewController(actions: CoinsListViewModelActions) -> DiscoverVC {
        DiscoverVC.create(with: makeCoinsListViewModel(action: actions, coinRepo: makeCoinsRepository()))
    }
    
    func makeCoinsDetailsViewController(coin: Coin) -> UIViewController {
        CoinDetailsVC.create(
            with: makeCoinsDetailsViewModel(coin: coin)
        )
    }
    
    func makeFavouritesViewController(actions: FavouritestViewModelActions) -> UIViewController {
        FavouriteVC.create(with: makeFavouritesViewModel(action: actions))
    }
    
    func makeCoinsDetailsViewModel(coin: Coin) -> CoinDetailsViewModel {
        DefaultCoinDetailsViewModel(
            coinData: coin,
            coinDetailsRepository: makeCoinDetailRepository()
        )
    }
    
    func makeFavouritesViewModel(action: FavouritestViewModelActions) -> FavouritesViewModel {
        DefaultFavouritesViewModel(actions: action)
    }
    
    func makeCoinsListViewModel(action: CoinsListViewModelActions, coinRepo: CoinsRepository) -> CoinsListViewModel {
        DefaultCoinsListViewModel(actions: action, coinsRepo: coinRepo)
    }
    
    func makeCoinsFlowCoordinator(navigationController: UINavigationController) -> CoinsListFlowCoordinator {
        CoinsListFlowCoordinator(navigationController: navigationController, dependencies: self)
    }
    
    func makeCoinsRepository() -> CoinsRepository {
        DefaultCoinsRepository(
            dataTransferService: dependencies.apiDataTransferService
        )
    }
    
    func makeCoinDetailRepository() -> CoinDetailsRepository {
        DefaultCoinDetailsRepository(dataTransferService: dependencies.apiDataTransferService)
    }
}
