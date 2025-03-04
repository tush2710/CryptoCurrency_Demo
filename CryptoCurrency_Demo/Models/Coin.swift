//
//  Coin.swift
//  EquityGroupTest_TusharZade
//
//  Created by Tushar Zade on 28/02/25.
//

import Foundation

struct Coin : Equatable, Identifiable {
    typealias Identifier = String
    let id: Identifier
    let symbol: String
    let name: String
    let color: String?
    let iconUrl: String
    let marketCap: String?
    let price: String
    let listedAt: Int?
    let tier: Int?
    let change: String?
    let rank: Int?
    let sparkline: [String?]?
    let lowVolume: Bool?
    let coinrankingUrl: String?
    let volume24h: String?
    let btcPrice: String?
    let contractAddresses: [String]?
    let allTimeHigh: AllTimeHigh?
    var isFavourite: Bool = false
    
    var performance24h: String? {
        let performance = Double(change ?? "0.0") ?? 0
        let formattedPerformance = String(format: "%.2f", performance)
        return performance >= 0 ? "+\(formattedPerformance)%" : "\(formattedPerformance)%"
    }
    
    var formattedPrice: String {
        guard let priceValue = Double(price) else { return price }
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"  // Change to your preferred currency
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: priceValue)) ?? price
    }
}


struct CoinsPage: Equatable {
    let page: Int
    let totalPages: Int
    var coins: [Coin]
}

struct AllTimeHigh: Equatable {
    let price: String
    let date: String
}
