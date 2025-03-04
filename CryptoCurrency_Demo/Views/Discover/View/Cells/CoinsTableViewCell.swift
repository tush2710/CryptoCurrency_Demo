//
//  CoinsTableViewCell.swift
//  EquityGroupTest_TusharZade
//
//  Created by Tushar Zade on 28/02/25.
//

import UIKit
import SDWebImage
import SDWebImageSVGCoder

class CoinsTableViewCell: UITableViewCell {
    static let reuseIdentifier = String(describing: CoinsTableViewCell.self)
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var imgCoin: UIImageView!
    @IBOutlet weak var lblCoinName: UILabel!
    @IBOutlet weak var lblSymbol: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblPerformance: UILabel!
    
    
    private var viewModel: CoinsListItemViewModel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        bgView.layer.cornerRadius = 10
    }
    
    func feedData(
        with viewModel: CoinsListItemViewModel
    ){
        self.viewModel = viewModel
        lblCoinName.text = viewModel.name
        imgCoin.setImage(from: viewModel.iconPath, placeholder: UIImage(systemName: "photo.circle.fill"))
        lblSymbol.text = viewModel.symbolName
        lblPrice.text = viewModel.price
        lblPerformance.text = String(describing: viewModel.performance24Hrs)
    }
}

extension UIImageView {
    func setImage(from urlString: String, placeholder: UIImage? = nil) {
        guard let url = URL(string: urlString) else {
            print("Invalid URL: \(urlString)")
            return
        }
        
        if urlString.lowercased().hasSuffix(".svg") {
            self.sd_setImage(with: url, placeholderImage: placeholder, context: [.imageCoder: CustomSVGDecoder(fallbackDecoder: SDImageSVGCoder.shared)])
        } else {
            self.sd_setImage(with: url,  placeholderImage: placeholder)
        }
    }
}
