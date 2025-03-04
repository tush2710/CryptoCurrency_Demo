//
//  CategoriesView.swift
//  EquityGroupTest_TusharZade
//
//  Created by Tushar Zade on 04/03/25.
//

import SwiftUI
import Charts

struct ProfitAndLossChartView: View {
    @ObservedObject var viewModel: PriceChartViewModel
    var body: some View {
        let profitLossData = viewModel.calculateProfitLoss()
        VStack{
            Chart(profitLossData) { entry in
                BarMark(
                    x: .value("Date", entry.date),
                    y: .value("Profit/Loss", entry.value)
                )
                .foregroundStyle(entry.value >= 0 ? .green : .red)
                .cornerRadius(4)
            }
            .chartYAxis {
                AxisMarks { value in
                    AxisValueLabel {
                        Text("\(value.as(Int.self) ?? 0)%")
                    }
                }
            }
            .chartXAxis {
                AxisMarks(values: .stride(by: .month)) { value in
                    if let date = value.as(Date.self) {
                        AxisValueLabel(date.formatted(.dateTime.day().month()))
    //                    AxisValueLabel(date, format: .dateTime.month(.abbreviated))
                    }
                }
            }
        }
        .onAppear(){
            viewModel.getPriceHistory()
        }
    }
}
