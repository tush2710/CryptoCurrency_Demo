//
//  CoinDetailsVC.swift
//  EquityGroupTest_TusharZade
//
//  Created by Tushar Zade on 03/03/25.
//

import UIKit
import SwiftUI


import UIKit
import SwiftUI

class CoinDetailsVC: UIViewController, StoryboardInstantiable, Alertable {
    
    @IBOutlet weak var imgCoinIcon: UIImageView!
    @IBOutlet weak var lblCoinName: UILabel!
    @IBOutlet weak var lblCoinSymbol: UILabel!
    @IBOutlet weak var lblCoinPrice: UILabel!
    @IBOutlet weak var lblCoinPerformance: UILabel!
    @IBOutlet weak var priceChartContainer: UIView!
    @IBOutlet weak var categoriesContainer: UIView!
    @IBOutlet weak var additionalStatsContainer: UIView!
    
    
    var priceChartAdapter : SwiftUIAdapter<PriceChartView>!
    var profitLoassChartAdapter : SwiftUIAdapter<ProfitAndLossChartView>!
    var additionalStatsAdapter : SwiftUIAdapter<AdditionalStatsView>!
    
    private var viewModel: CoinDetailsViewModel!
    
    static func create(with viewModel: CoinDetailsViewModel) -> CoinDetailsVC {
        let view = CoinDetailsVC.instantiateViewController()
        view.viewModel = viewModel
        return view
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCoinBasicData()
        
        setupPriceHistoryChart()
        
        setupProfirLossChart()
        
        setupAdditionalStatsView()
        
        bind(to: viewModel)
    }
    
    private func bind(to viewModel: CoinDetailsViewModel){
        viewModel.error.observe(on: self) { [weak self] in self?.showError($0) }
    }
    
    func setupCoinBasicData(){
        guard let coin = viewModel.coinData.value else { return }
        imgCoinIcon.setImage(from: coin.iconUrl, placeholder: UIImage(systemName: "photo.circle.fill"))
        lblCoinName.text = coin.name
        lblCoinPrice.text = coin.formattedPrice
        lblCoinSymbol.text = coin.symbol
        lblCoinPerformance.text = coin.performance24h
    }
    
    func setupPriceHistoryChart(){
        let priceChartViewModel = viewModel.priceChartViewModel()
        let priceChartView = PriceChartView(viewModel: priceChartViewModel)
        priceChartAdapter = SwiftUIAdapter(view: priceChartView, parent: self)
        priceChartContainer.addSubview(priceChartAdapter.uiView)
        
        priceChartAdapter.uiView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: priceChartAdapter.uiView, attribute: .top, relatedBy: .equal, toItem: priceChartContainer, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: priceChartAdapter.uiView, attribute: .trailing, relatedBy: .equal, toItem: priceChartContainer, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: priceChartAdapter.uiView, attribute: .bottom, relatedBy: .equal, toItem: priceChartContainer, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: priceChartAdapter.uiView, attribute: .leading, relatedBy: .equal, toItem: priceChartContainer, attribute: .leading, multiplier: 1, constant: 0).isActive = true
    }
    
    func setupProfirLossChart(){
        let priceChartViewModel = viewModel.priceChartViewModel()
        let profitLoassCartView = ProfitAndLossChartView(viewModel: priceChartViewModel)
        profitLoassChartAdapter = SwiftUIAdapter(view: profitLoassCartView, parent: self)
        categoriesContainer.addSubview(profitLoassChartAdapter.uiView)
        
        profitLoassChartAdapter.uiView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: profitLoassChartAdapter.uiView, attribute: .top, relatedBy: .equal, toItem: categoriesContainer, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: profitLoassChartAdapter.uiView, attribute: .trailing, relatedBy: .equal, toItem: categoriesContainer, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: profitLoassChartAdapter.uiView, attribute: .bottom, relatedBy: .equal, toItem: categoriesContainer, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: profitLoassChartAdapter.uiView, attribute: .leading, relatedBy: .equal, toItem: categoriesContainer, attribute: .leading, multiplier: 1, constant: 0).isActive = true
    }
    
    func setupAdditionalStatsView(){
        let additionalStatsView = AdditionalStatsView(coinData: viewModel.coinData.value!)
        additionalStatsAdapter = SwiftUIAdapter(view: additionalStatsView, parent: self)
        additionalStatsContainer.addSubview(additionalStatsAdapter.uiView)
        
        additionalStatsAdapter.uiView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: additionalStatsAdapter.uiView, attribute: .top, relatedBy: .equal, toItem: additionalStatsContainer, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: additionalStatsAdapter.uiView, attribute: .trailing, relatedBy: .equal, toItem: additionalStatsContainer, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: additionalStatsAdapter.uiView, attribute: .bottom, relatedBy: .equal, toItem: additionalStatsContainer, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: additionalStatsAdapter.uiView, attribute: .leading, relatedBy: .equal, toItem: additionalStatsContainer, attribute: .leading, multiplier: 1, constant: 0).isActive = true
    }
    
    private func showError(_ error: String) {
        guard !error.isEmpty else { return }
        showAlert(title: viewModel.errorTitle, message: error)
    }
}
