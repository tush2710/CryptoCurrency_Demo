//
//  AdditionalStatsView.swift
//  EquityGroupTest_TusharZade
//
//  Created by Tushar Zade on 04/03/25.
//

import SwiftUI

struct AdditionalStatsView: View {
    let coinData: Coin
    
    var body: some View {
        List {
            HStack {
                Text("All Time High")
                Spacer()
                Text("\(coinData.allTimeHigh?.price.formattedAsCurrency() ?? "") (\(coinData.allTimeHigh?.date ?? ""))")
            }
            
            HStack {
                Text("Valoume / Market Cap")
                Spacer()
                Text("\(coinData.marketCap ?? "")")
            }
            
            HStack {
                Text("Price in BTM")
                Spacer()
                Text("\(coinData.btcPrice?.formattedAsCurrency() ?? "")")
            }
            
            HStack {
                Text("Listing Date")
                Spacer()
                Text("\(Double(coinData.listedAt ?? 0).formattedDate())")
            }
            
            HStack {
                Text("Listing Date")
                Spacer()
                Text("\(coinData.listedAt ?? 0)")
            }
            
            
            HStack {
                Text("UUID")
                Spacer()
                Text("\(coinData.id)")
            }
        }
    }
}
