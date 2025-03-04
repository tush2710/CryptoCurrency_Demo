//
//  CoinDetailsViewModel.swift
//  EquityGroupTest_TusharZade
//
//  Created by Tushar Zade on 03/03/25.
//

import Foundation

enum CoinDetailsViewModelLoading {
    case fullScreen
    case none
}

protocol CoinDetailsViewModelInput: AnyObject{
    func viewDidLoad()
    func update()
    func didChangeFilter()
}

protocol CoinDetailsViewModelOutput: AnyObject {
    var coinData: Observable<Coin?> { get }
    var priceHistory: Observable<[PriceHistory]> { get }
    var loading: Observable<CoinsListViewModelLoading?> { get }
    var error: Observable<String> { get }
    var errorTitle: String { get }
    
    var timePeriod: Observable<TimeFilter> { get set }
    func getCoinDetails(loading: CoinsListViewModelLoading)
    func getPriceHistory()
    func priceChartViewModel() -> PriceChartViewModel
}

typealias CoinDetailsViewModel = CoinDetailsViewModelInput & CoinDetailsViewModelOutput

final class DefaultCoinDetailsViewModel: CoinDetailsViewModel, ObservableObject {
    private let coinDetailsRepository: CoinDetailsRepository
    private let mainQueue: DispatchQueueType
    
    var coinData: Observable<Coin?> = Observable(nil)
    var priceHistory: Observable<[PriceHistory]> = Observable([])
    var loading: Observable<CoinsListViewModelLoading?> = Observable(.fullScreen)
    var error: Observable<String> = Observable("")
    var timePeriod: Observable<TimeFilter> = Observable(.twentyFourHours)
    var errorTitle: String { "Error" }
   
    
    init(
        coinData: Coin,
        coinDetailsRepository: CoinDetailsRepository,
        mainQueue: DispatchQueueType = DispatchQueue.main
    ) {
        self.coinData.value = coinData
        self.coinDetailsRepository = coinDetailsRepository
        self.mainQueue = mainQueue
    }
    
    func getCoinDetails(loading: CoinsListViewModelLoading) {
        self.loading.value = loading
        coinDetailsRepository.fetchCoinDetails(uuid: coinData.value?.id ?? "", timePeriod: timePeriod.value) { result in
            if case .success(let success) = result {
                self.mainQueue.async {
                    switch result {
                    case .success(let data):
                        self.coinData.value = data
                        self.getPriceHistory()
                    case .failure(let error):
                        self.handle(error: error)
                    }
                    self.loading.value = .none
                }
            }
        }
    }
    
    func getPriceHistory() {
        coinDetailsRepository.fetchCoinPriceHistory(uuid: coinData.value?.id ?? "", timePeriod: timePeriod.value) { result in
            if case .success(let success) = result {
                self.mainQueue.async {
                    switch result {
                    case .success(let data):
                        self.priceHistory.value = data
                    case .failure(let error):
                        if let dataTransferError = error as? DataTransferError, case .networkFailure(.limitReached) = dataTransferError {
                            self.error.value = NSLocalizedString("You've reached the API request limit.", comment: "")
                        } else {
                            self.handle(error: error)
                        }
                    }
                }
            } else if case .failure(let error) = result {
                self.mainQueue.async {
                    if let dataTransferError = error as? DataTransferError, case .networkFailure(.limitReached) = dataTransferError {
                        self.error.value = NSLocalizedString("You've reached the API request limit.", comment: "")
                    } else {
                        self.handle(error: error)
                    }
                }
            }
        }
    }
    
    private func handle(error: Error) {
        self.error.value = error.isInternetConnectionError ?
            NSLocalizedString("No internet connection", comment: "") :
            NSLocalizedString("Failed loading movies", comment: "")
    }
    
    func priceChartViewModel() -> PriceChartViewModel {
        PriceChartViewModel(coinData: self.coinData.value!, coinDetailsRepository: self.coinDetailsRepository)
    }
}

extension DefaultCoinDetailsViewModel{
    func viewDidLoad() {  }
    
    func update() {
        getCoinDetails(loading: .fullScreen)
    }
    
    func didChangeFilter() {
        
    }
}
