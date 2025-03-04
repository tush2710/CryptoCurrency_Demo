//
//  CoinsListItemViewModel.swift
//  EquityGroupTest_TusharZade
//
//  Created by Tushar Zade on 02/03/25.
//

import Foundation

struct CoinsListItemViewModel : Equatable {
    let uuid: String
    let name: String
    let iconPath: String
    let symbolName: String
    let price: String
    let performance24Hrs: String
    var isFavourite: Bool
}

extension CoinsListItemViewModel {
    
    init(coin: Coin) {
        self.uuid = "\(coin.id)"
        self.name = coin.name
        self.iconPath = coin.iconUrl
        self.symbolName = coin.symbol
        self.price = coin.formattedPrice
        self.performance24Hrs = coin.performance24h ?? ""
        self.isFavourite = coin.isFavourite
    }
//
//    init(movie: Movie) {
//        self.title = movie.title ?? ""
//        self.posterImagePath = movie.posterPath
//        self.overview = movie.overview ?? ""
//        if let releaseDate = movie.releaseDate {
//            self.releaseDate = "\(NSLocalizedString("Release Date", comment: "")): \(dateFormatter.string(from: releaseDate))"
//        } else {
//            self.releaseDate = NSLocalizedString("To be announced", comment: "")
//        }
//    }
    
    func calculate24hPerformance(latestPrice: Double, oldestPrice: Double) -> Double {
        guard oldestPrice > 0 else { return 0.0 }
        return ((latestPrice - oldestPrice) / oldestPrice) * 100
    }
}
