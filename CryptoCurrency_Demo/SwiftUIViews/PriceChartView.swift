//
//  GradientAreaChartView.swift
//  EquityGroupTest_TusharZade
//
//  Created by Tushar Zade on 03/03/25.
//

import SwiftUI
import Charts


struct PriceData: Identifiable {
    let id = UUID()
    let time: Date
    let price: Double
}

struct StockData: Identifiable {
    let id = UUID()
    let date: Date
    let price: Double
}

struct PriceChartView: View {
    @ObservedObject var viewModel: PriceChartViewModel
    
    let linearGradient = LinearGradient(gradient: Gradient(colors: [Color.accentColor.opacity(0.4),
                                                                    Color.accentColor.opacity(0)]),
                                        startPoint: .top,
                                        endPoint: .bottom)

    var body: some View {
        VStack {
            let priceHistory = viewModel.priceHistory
            Chart {
                ForEach(priceHistory) { data in
                    LineMark(x: .value("Time", data.date),
                             y: .value("Price", data.price))
                }
                .foregroundStyle(priceHistory.last?.price ?? 0 > priceHistory.first?.price ?? 0 ? .green : .red)
                .interpolationMethod(.catmullRom)
                
                ForEach(priceHistory) { data in
                    AreaMark(x: .value("Time", data.date),
                             y: .value("Price", data.price))
                }
//                .interpolationMethod(.cardinal)
                .foregroundStyle(linearGradient)
            }
            .chartXScale(domain: (priceHistory.last?.date ?? Date())...(priceHistory.first?.date ?? Date()))
            .chartLegend(.hidden)
            
            .chartXAxis {
                AxisMarks(values: .automatic) { value in
                    if let date = value.as(Date.self) {
                        let label = formattedXAxisLabel(for: date, filter: viewModel.timePeriod)
                        AxisValueLabel(label)
                    }
                }
            }
            // Time Filter Buttons
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(TimeFilter.allCases, id: \.self) { filter in
                        Button(action: {
                            viewModel.timePeriod = filter
                            viewModel.getPriceHistory()
                        }) {
                            Text(filter.displayName)
                                .padding()
                                .background(viewModel.timePeriod == filter ? Color.white.opacity(0.2) : Color.clear)
                                .cornerRadius(10)
                        }
                        .foregroundColor(.white)
                    }
                }
                .padding(.horizontal)
            }
            
            Spacer()
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .onAppear(){
            viewModel.getPriceHistory()
        }
    }
    
    private func formattedXAxisLabel(for date: Date, filter: TimeFilter) -> String {
        let formatter = DateFormatter()
        if filter.isHourly {
            formatter.dateFormat = "ha" // Example: "1AM", "2PM"
        } else {
            formatter.dateFormat = "d MMM" // Example: "4 Mar"
        }
        return formatter.string(from: date)
    }
}
