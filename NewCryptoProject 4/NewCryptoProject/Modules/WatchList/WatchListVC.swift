import UIKit
import CoreData

protocol WatchListDelegate: AnyObject {
    func resetDeletedIconStatus(_ model: Crypto?)
}

final class WatchListVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var viewModel: WatchListViewModel?
    weak var delegate: WatchListDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        setupUI()
        fetch()
    }
}

extension WatchListVC {
    func setupBindings() {
        viewModel?.reloadCollectionView = { [weak self] in
            DispatchQueue.main.async { [weak self] in
                self?.collectionView.reloadData()
            }
        }
    }
}

private
extension WatchListVC {
    func setupUI() {
        collectionView.delegate = self
        collectionView.dataSource = self
        let cellIdentifier = String(describing: FavCell.self)
        let nib = UINib(nibName: cellIdentifier, bundle: .main)
        collectionView.register(nib, forCellWithReuseIdentifier: cellIdentifier)
        
        self.title = "\(Constants.titleWatchlist)"
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.largeTitleTextAttributes = textAttributes
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func fetch() {
        viewModel?.fetchStorageData()
    }
}

extension WatchListVC: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.savedList.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: FavCell.self), for: indexPath) as? FavCell else { return UICollectionViewCell() }
        cell.delegate = self
        cell.configureCell(viewModel?.savedList[indexPath.row], indexPath.row)
        return cell
    }
}

extension WatchListVC: FavCellProtocol {
    func deleteBookmark(_ index: Int?) {
        guard let index else { return }
        PersistentManager.shared.deleteBookmark(viewModel?.savedList[index]) { [weak self] in
            self?.delegate?.resetDeletedIconStatus(self?.viewModel?.savedList[index])
            self?.fetch()
        }
    }
}

private
extension WatchListVC {
    struct Constants {
        static let titleWatchlist = "Watchlist"
    }
}
