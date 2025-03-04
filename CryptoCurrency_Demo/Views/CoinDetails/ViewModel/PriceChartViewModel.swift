//
//  PriceChartViewModel.swift
//  EquityGroupTest_TusharZade
//
//  Created by Tushar Zade on 03/03/25.
//

import SwiftUI

class PriceChartViewModel: ObservableObject {
    private let coinDetailsRepository: CoinDetailsRepository
    private let mainQueue: DispatchQueueType
    
    @Published var priceHistory : [PriceHistory] = []
    @Published var timePeriod: TimeFilter = .twentyFourHours
    @Published var selectedTimeframe = "Months"
    
    
    let timeframes = ["Hours", "Days", "Months"]
    private var coinData: Coin
    private var error: String?
    
    init(
        coinData: Coin,
        coinDetailsRepository: CoinDetailsRepository,
        mainQueue: DispatchQueueType = DispatchQueue.main
    ) {
        self.coinData = coinData
        self.coinDetailsRepository = coinDetailsRepository
        self.mainQueue = mainQueue
    }
    
    func getPriceHistory() {
        coinDetailsRepository.fetchCoinPriceHistory(uuid: coinData.id ?? "", timePeriod: timePeriod) { result in
            if case .success(let success) = result {
                self.mainQueue.async {
                    switch result {
                    case .success(let data):
                        self.priceHistory = data
                    case .failure(let error):
                        self.handle(error: error)
                    }
                }
            }
        }
    }
    
    private func handle(error: Error) {
        self.error = error.isInternetConnectionError ?
            NSLocalizedString("No internet connection", comment: "") :
            NSLocalizedString("Failed loading movies", comment: "")
    }
    
    func calculateProfitLoss() -> [ProfitLoss] {
        let sortedData = priceHistory.sorted { $0.date < $1.date } // Sort by time
        var result: [ProfitLoss] = []
        
        guard sortedData.count > 0 else { return [] }
        for i in 1..<sortedData.count {
            let prevPrice = sortedData[i - 1].price
            let currentPrice = sortedData[i].price
            let profitLoss = currentPrice - prevPrice
            result.append(ProfitLoss(date: sortedData[i].date, value: profitLoss))
        }
        
        return result
    }
}

enum TimeFilter: String, CaseIterable {
    case oneHour = "1h"
    case threeHours = "3h"
    case twelveHours = "12h"
    case twentyFourHours = "24h"
    case sevenDays = "7d"
    case thirtyDays = "30d"
    case threeMonths = "3m"
    case oneYear = "1y"
    case threeYear = "3y"
    case fiveYear = "5y"
    
    var displayName: String { self.rawValue }
}

extension TimeFilter {
    var isHourly: Bool {
        return self == .oneHour || self == .threeHours || self == .twelveHours
    }
}

struct ProfitLoss: Identifiable {
    let id = UUID()
    let date: Date
    let value: Double
}
