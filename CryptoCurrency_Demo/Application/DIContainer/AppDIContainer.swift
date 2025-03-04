//
//  AppDIContainer.swift
//  EquityGroupTest_TusharZade
//
//  Created by Tushar Zade on 02/03/25.
//

import Foundation

final class AppDIContainer {
    
    lazy var appConfiguration = AppConfiguration()
    
    // MARK: - Network
    lazy var apiDataTransferService: DataTransferService = {
        let config = ApiDataNetworkConfig(
            baseURL: URL(string: appConfiguration.apiBaseURL)!,
            queryParameters: [
                "api_key": appConfiguration.apiKey,
                "language": NSLocale.preferredLanguages.first ?? "en"
            ]
        )
        
        let apiDataNetwork = NetworkManager(config: config)
        return DefaultDataTransferService(with: apiDataNetwork)
    }()
   
//    // MARK: - DIContainers of scenes
    func makeCoinsSceneDIContainer() -> CoinsSceneDIContainer {
        let dependencies = CoinsSceneDIContainer.Dependencies(
            apiDataTransferService: apiDataTransferService
        )
        return CoinsSceneDIContainer(dependencies: dependencies)
    }
}
