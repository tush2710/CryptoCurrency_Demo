//
//  CoinDetailsManager.swift
//  EquityGroupTest_TusharZade
//
//  Created by Tushar Zade on 03/03/25.
//

import Foundation

protocol CoinDetailsRepository {
    @discardableResult
    func fetchCoinDetails(
        uuid: String,
        timePeriod: TimeFilter,
        completion: @escaping (Result<Coin, Error>) -> Void
    ) -> Cancellable?
    
    @discardableResult
    func fetchCoinPriceHistory(
        uuid: String,
        timePeriod: TimeFilter,
        completion: @escaping (Result<[PriceHistory], any Error>) -> Void
    ) -> Cancellable?
}

final class DefaultCoinDetailsRepository{
    private let dataTransferService: DataTransferService
    private let backgroundQueue: DataTransferDispatchQueue
    
    init(
        dataTransferService: DataTransferService,
        backgroundQueue: DataTransferDispatchQueue = DispatchQueue.global(qos: .userInitiated)
    ) {
        self.dataTransferService = dataTransferService
        self.backgroundQueue = backgroundQueue
    }
}

extension DefaultCoinDetailsRepository: CoinDetailsRepository {
    func fetchCoinDetails(
        uuid: String,
        timePeriod: TimeFilter,
        completion: @escaping (Result<Coin, any Error>) -> Void
    ) -> Cancellable? {
        let requestDTO = CoinDetailsRequestDTO(timePeriod: timePeriod.displayName)
        let task = RepositoryTask()
        let endPoint = APIEndpoints.getCoinsDeatails(with: uuid, query: requestDTO)
        task.networkTask = self.dataTransferService.request(
            with: endPoint,
            on: backgroundQueue,
            completion: { result in
                switch result {
                case .success(let responseDTO):
                    completion(.success(responseDTO.toDomain()))
                case .failure(let error):
                    completion(.failure(error))
                }
            })
        return task
    }
    
    func fetchCoinPriceHistory(
        uuid: String,
        timePeriod: TimeFilter,
        completion: @escaping (Result<[PriceHistory], any Error>) -> Void
    ) -> Cancellable? {
        let requestDTO = CoinDetailsRequestDTO(timePeriod: timePeriod.displayName)
        let task = RepositoryTask()
        let endPoint = APIEndpoints.getCoinPriceHistory(with: uuid, query: requestDTO)
        task.networkTask = self.dataTransferService.request(
            with: endPoint,
            on: backgroundQueue,
            completion: { result in
                switch result {
                case .success(let responseDTO):
                    completion(.success(responseDTO.toDomain()))
                case .failure(let error):
                    completion(.failure(error))
                }
            })
        return task
    }
}
