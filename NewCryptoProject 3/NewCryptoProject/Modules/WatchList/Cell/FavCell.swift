//
//  SceneDelegate.swift
//  CryptoTracker
//
//  Created by Margarita Can on 18.03.2024.
//

import UIKit
import Kingfisher

protocol FavCellProtocol: AnyObject {
    func deleteBookmark(_ index: Int?)
}

final class FavCell: UICollectionViewCell {

    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var nameLbl: UILabel!
    @IBOutlet private weak var priceLbl: UILabel!
    @IBOutlet private weak var iconView: UIImageView!
    
    private var index: Int?
    weak var delegate: FavCellProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        delegate?.deleteBookmark(index)
    }
    
    func configureCell(_ model: Crypto?, _ index: Int?) {
        guard let model else { return }
        self.index = index
        self.nameLbl.text = model.name
        if let price = model.price_usd {
            self.priceLbl.text = "\(price) $"
        }else {
            self.priceLbl.text = "N/A"
        }
        iconView.kf.setImage(with: URL(string: model.imageUrl ?? ""), placeholder: UIImage(named: "na"))
    }

}

private
extension FavCell {
    func setupUI() {
        containerView.layer.cornerRadius = 10
    }
}
