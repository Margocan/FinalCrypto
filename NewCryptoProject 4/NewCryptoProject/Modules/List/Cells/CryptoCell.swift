import UIKit
import Kingfisher

protocol CryptoCellProtocol: AnyObject {
    func addToBookMark(_ model: Crypto?)
}

final class CryptoCell: UITableViewCell {
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var isFavoriteButton: UIButton!
    
    weak var delegate: CryptoCellProtocol?
    private var model: Crypto?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func addToBookmarkTapped(_ sender: Any) {
        self.model?.isFavorite = (model?.isFavorite == nil || !(model?.isFavorite ?? false)) ? true:false
        isFavoriteButton.setImage(UIImage(systemName: (model?.isFavorite ?? false) ? "bookmark.fill" : "bookmark"), for: .normal)
        delegate?.addToBookMark(model)
    }
}

extension CryptoCell {
    
    func configureCell(_ model: Crypto?, _ index: Int?) {
        guard let model else { return }
        self.model = model
        self.nameLabel.text = model.name
        if let price = model.priceUsd {
            self.priceLabel.text = "\(price) $"
        }else {
            self.priceLabel.text = "N/A"
        }
        isFavoriteButton.setImage(UIImage(systemName: (model.isFavorite ?? false) ? "bookmark.fill" : "bookmark"), for: .normal)
        iconImageView.kf.setImage(with: URL(string: model.imageUrl ?? ""), placeholder: UIImage(named: "na"))
    }
}
