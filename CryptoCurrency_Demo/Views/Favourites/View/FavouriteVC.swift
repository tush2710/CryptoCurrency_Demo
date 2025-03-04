//
//  FavouriteVC.swift
//  EquityGroupTest_TusharZade
//
//  Created by Tushar Zade on 04/03/25.
//

import UIKit

class FavouriteVC: UIViewController, StoryboardInstantiable, Alertable {
    @IBOutlet weak var favouriteList: UITableView!
    private var viewModel: FavouritesViewModel!
    
    static func create(
        with viewModel: FavouritesViewModel
    ) -> FavouriteVC {
        let view = FavouriteVC.instantiateViewController()
        view.viewModel = viewModel
        return view
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        registerCoinTblCell()
        
        setupFavouriteTableViewDataSource()
        
        bind(to: viewModel)
        
        viewModel.getAllFavourite()
    }
    
    private func registerCoinTblCell() {
        favouriteList.register(UINib(nibName: "CoinsTableViewCell", bundle: nil), forCellReuseIdentifier: "CoinsTableViewCell")
    }
    
    private func setupFavouriteTableViewDataSource() {
        favouriteList.dataSource = self
        favouriteList.delegate = self
    }
    
    private func bind(to viewModel: FavouritesViewModel){
        viewModel.items.observe(on: self) { [weak self] _ in
            self?.updateItems()
        }
    }
    
    private func updateItems(){
        favouriteList.reloadData()
    }
    
    private func showError(_ error: String) {
        guard !error.isEmpty else { return }
        showAlert(title: "Error", message: error)
    }
}

extension FavouriteVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectItem(at: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let coin = viewModel.items.value[indexPath.row]
        let favoriteAction = UIContextualAction(style: .normal, title: nil) { _, _, completionHandler in
            self.viewModel.removeFavourite(coin.uuid) {[weak self] isFavourite in
                self?.viewModel.refreshFavourites()
            }
            tableView.reloadRows(at: [indexPath], with: .automatic)  // Update UI
            completionHandler(true)
        }
        
        let icon = UIImage(systemName: "star.fill")
        favoriteAction.image = icon
        favoriteAction.backgroundColor = .systemOrange
        return UISwipeActionsConfiguration(actions: [favoriteAction])
    }
}

extension FavouriteVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CoinsTableViewCell") as? CoinsTableViewCell  else {
            return UITableViewCell()
        }
        cell.feedData(with: viewModel.items.value[indexPath.row])
        return cell
    }
}
