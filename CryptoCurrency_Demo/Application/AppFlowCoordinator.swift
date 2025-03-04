//
//  AppFlowCoordinator.swift
//  EquityGroupTest_TusharZade
//
//  Created by Tushar Zade on 02/03/25.
//

import UIKit

final class AppFlowCoordinator {

    var navigationController: UINavigationController
    private let appDIContainer: AppDIContainer
    
    init(
        navigationController: UINavigationController,
        appDIContainer: AppDIContainer
    ) {
        self.navigationController = navigationController
        self.appDIContainer = appDIContainer
    }

    func start() {
        let coinsSceneDIContainer = appDIContainer.makeCoinsSceneDIContainer()
        let flow = coinsSceneDIContainer.makeCoinsFlowCoordinator(navigationController: navigationController)
        flow.start()
    }
}
