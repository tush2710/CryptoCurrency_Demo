//
//  CoinsListResponseDTO+Mapping.swift
//  EquityGroupTest_TusharZade
//
//  Created by Tushar Zade on 02/03/25.
//

import Foundation

// MARK: - CoinsListResponseDTO
struct CoinsListResponseDTO: Codable {
    let status: String
    let data: DataClassDTO
}

extension CoinsListResponseDTO {
    func toDomain(_ page: Int) -> CoinsPage {
        let totalPages = (data.stats.totalCoins + 19) / 20
        return CoinsPage(page: page, totalPages: totalPages, coins: data.coins.map{ $0.toCoin() })
    }
}

// MARK: - DataClass
struct DataClassDTO: Codable {
    let stats: StatsDTO
    let coins: [CoinDTO]
}

extension DataClassDTO {
    func toDomain() -> CoinsPage {
        let totalPages = (stats.totalCoins + 19) / 20
        return CoinsPage(page: 0, totalPages: totalPages, coins: coins.map{ $0.toCoin() })
    }
}

// MARK: - Coin
struct CoinDTO: Codable {
    let uuid, symbol, name: String
    let description, color, websiteURL: String?
    let links: [LinkDTO]?
    let supply: SupplyDTO?
    let numberOfMarkets, numberOfExchanges: Int?
    let iconURL, marketCap, price: String
    let fullyDilutedMarketCap: String?
    let listedAt, tier, rank: Int
    let change: String
    let sparkline: [String?]
    let lowVolume: Bool
    let coinrankingURL: String
    let the24HVolume, btcPrice: String
    let contractAddresses: [String]
    let priceAt: Int?
    let allTimeHigh: AllTimeHighDTO?
    let hasContent: Bool?
    let tags: [String]?
    
    

    enum CodingKeys: String, CodingKey {
        case uuid, symbol, name, description, color, websiteURL, links, supply
        case numberOfMarkets, numberOfExchanges
        case iconURL = "iconUrl"
        case marketCap, price, fullyDilutedMarketCap, listedAt, tier, change, rank, sparkline, lowVolume
        case coinrankingURL = "coinrankingUrl"
        case the24HVolume = "24hVolume"
        case btcPrice, contractAddresses, priceAt, allTimeHigh, hasContent, tags
    }
}

extension CoinDTO {
    
    func toCoin() -> Coin {
        return Coin(
            id: Coin.Identifier(uuid), symbol: symbol, name: name, color: color,
            iconUrl: iconURL,
            marketCap: marketCap, price: price,
            listedAt: listedAt, tier: tier,
            change: change,
            rank: rank,
            sparkline: sparkline,
            lowVolume: lowVolume,
            coinrankingUrl: coinrankingURL,
            volume24h: the24HVolume, btcPrice: btcPrice, contractAddresses: contractAddresses,
            allTimeHigh: AllTimeHigh(price: allTimeHigh?.price ?? "", date: Double(allTimeHigh?.timestamp ?? 0).formattedDate())
        )
    }
}

// MARK: - Stats
struct StatsDTO: Codable {
    let total, totalCoins, totalMarkets, totalExchanges: Int
    let totalMarketCap, total24HVolume: String

    enum CodingKeys: String, CodingKey {
        case total, totalCoins, totalMarkets, totalExchanges, totalMarketCap
        case total24HVolume = "total24hVolume"
    }
}

struct LinkDTO: Codable {
    let name: String
    let url: String
    let type: String
}

struct SupplyDTO: Codable {
    let confirmed: Bool
    let supplyAt: Int
    let max, total, circulating: String
}

struct AllTimeHighDTO: Codable {
    let price: String
    let timestamp: Int
    
    var date : Date {
        Date(timeIntervalSince1970: Double(timestamp))
    }
}
