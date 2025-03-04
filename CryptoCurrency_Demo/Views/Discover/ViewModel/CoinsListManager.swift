//
//  CoinsListUseCase.swift
//  EquityGroupTest_TusharZade
//
//  Created by Tushar Zade on 02/03/25.
//

import Foundation
protocol CoinsRepository {
    @discardableResult
    func fetchCoinsList(
        page: Int,
        orderBy: OrderBy,
        completion: @escaping (Result<CoinsPage, Error>) -> Void
    ) -> Cancellable?
}
final class DefaultCoinsRepository{
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

extension DefaultCoinsRepository: CoinsRepository {
    func fetchCoinsList(
        page: Int,
        orderBy: OrderBy,
        completion: @escaping (Result<CoinsPage, Error>) -> Void
    ) -> Cancellable? {
        let requestDTO = CoinsListRequestDTO(offset: page, orderBy: orderBy.rawValue)
        let task = RepositoryTask()
        
        let endPoint = APIEndpoints.getCoinsList(with: requestDTO)
        task.networkTask = self.dataTransferService.request(
            with: endPoint,
            on: backgroundQueue
        ) { result in
            switch result {
            case .success(let responseDTO):
                completion(.success(responseDTO.toDomain(page)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        return task
    }
}
