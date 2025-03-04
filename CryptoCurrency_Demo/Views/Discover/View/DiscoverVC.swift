//
//  DiscoverVC.swift
//  EquityGroupTest_TusharZade
//
//  Created by Tushar Zade on 28/02/25.
//

import UIKit

class DiscoverVC: UIViewController, StoryboardInstantiable, Alertable {

    @IBOutlet weak var discoverList: UITableView!
    private var viewModel: CoinsListViewModel!
    var nextPageLoadingSpinner: UIActivityIndicatorView?
    
    static func create(
        with viewModel: CoinsListViewModel
    ) -> DiscoverVC {
        let view = DiscoverVC.instantiateViewController()
        view.viewModel = viewModel
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.registerCoinTblCell()
        
        self.setupDiscoverTableViewDataSource()
                
        self.setupFilterMenu()
        
        bind(to: viewModel)
        
        viewModel.update()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.refreshFavourites()
    }
    
    @IBAction func favouritesItemClicked(_ sender: UIBarButtonItem) {
        viewModel.didSelectFavouriteButton()
    }
    
    
    private func registerCoinTblCell() {
        discoverList.register(UINib(nibName: "CoinsTableViewCell", bundle: nil), forCellReuseIdentifier: "CoinsTableViewCell")
    }
    
    private func setupDiscoverTableViewDataSource() {
        discoverList.dataSource = self
        discoverList.delegate = self
    }
    
    private func bind(to viewModel: CoinsListViewModel){
        viewModel.items.observe(on: self) { [weak self] _ in
            self?.updateItems()
        }
        viewModel.error.observe(on: self) { [weak self] in self?.showError($0) }
        viewModel.orderBy.observe(on: self) { [weak self] _ in self?.viewModel.update() }
    }
    
    private func updateItems(){
        discoverList.reloadData()
    }
    
    private func updateLoading(_ loading: CoinsListViewModelLoading){
        LoadingView.hide()
        switch loading {
        case .fullScreen:
            discoverList.tableFooterView = nil
            LoadingView.show()
        case .nextPage:
            nextPageLoadingSpinner?.removeFromSuperview()
            nextPageLoadingSpinner = discoverList.makeActivityIndicator(size: CGSize(width: discoverList.frame.width, height: 44))
            discoverList.tableFooterView = nextPageLoadingSpinner
        }
        
    }
    
    private func showError(_ error: String) {
        guard !error.isEmpty else { return }
        showAlert(title: viewModel.errorTitle, message: error)
    }
}

extension DiscoverVC: MenuPresentable{
    func setupFilterMenu(){
        let highestPriceAction = UIAction(title: "Highest Price", image: UIImage(systemName: "dollarsign.circle")) { _ in
            self.viewModel.orderBy.value = .price
        }
        let bestPerformanceAction = UIAction(title: "Best 24h Performance", image: UIImage(systemName: "chart.line.uptrend.xyaxis")) { _ in
            self.viewModel.orderBy.value = .change
        }
        let filterMenu = createMenu(actions: [highestPriceAction, bestPerformanceAction])
        setupMenuButton(image: UIImage(systemName: "line.3.horizontal.decrease.circle.fill"), menu: filterMenu, in: navigationItem)
    }
}

extension DiscoverVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectItem(at: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        var coin = viewModel.items.value[indexPath.row]
        let isFavorited = coin.isFavourite
        let favoriteAction = UIContextualAction(style: .normal, title: nil) { _, _, completionHandler in
            if isFavorited {
                self.viewModel.removeFavourite(coin.uuid) {[weak self] isFavourite in
                    self?.viewModel.refreshFavourites()
                }
            } else {
                self.viewModel.addFavourite(coin.uuid) { [weak self] isFavourite in
                    self?.viewModel.refreshFavourites()
                }
            }
            tableView.reloadRows(at: [indexPath], with: .automatic)  // Update UI
            completionHandler(true)
        }
        
        let icon = isFavorited ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
        favoriteAction.image = icon
        favoriteAction.backgroundColor = .systemOrange
        return UISwipeActionsConfiguration(actions: [favoriteAction])
    }
}

extension DiscoverVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CoinsTableViewCell") as? CoinsTableViewCell  else {
            return UITableViewCell()
        }
        cell.feedData(with: viewModel.items.value[indexPath.row])
        
        if indexPath.row == viewModel.items.value.count - 1 {
            viewModel.didLoadNextPage()
        }
        
        return cell
    }
}


