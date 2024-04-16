import UIKit
import CoreData

final class ListVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: ListViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupSearchBar()
        registerCell()
        setupBindings()
        PersistentManager.shared.fetchStorageData {
            self.viewModel?.fetchData()
        }
    }
    
}

extension ListVC {

    func setupBindings() {
        viewModel?.reloadTableView = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    func registerCell() {
        let cellName = String(describing: CryptoCell.self)
        let cellNib = UINib(nibName: cellName, bundle: .main)
        tableView.register(cellNib, forCellReuseIdentifier: cellName)
    }
    
}

private
extension ListVC {
    func setupUI() {
        self.title = "\(Constants.marketsName)"
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.largeTitleTextAttributes = textAttributes
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: Constants.bookMarkImage,
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(favButtonTapped))
        tableView.dataSource = self
    }
    
    @objc func favButtonTapped() {
        let watchListVC = WatchListVC()
        watchListVC.delegate = self
        watchListVC.viewModel = WatchListViewModel()
        self.navigationController?.pushViewController(watchListVC, animated: true)
    }
    
    func setupSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        if let searchTextField = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            searchTextField.backgroundColor = .white
            searchTextField.attributedPlaceholder = NSAttributedString(string: Constants.searchPlaceholder,
                                                                       attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .regular),
                                                                                    NSAttributedString.Key.foregroundColor: UIColor.gray])
        }
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.searchResultsUpdater = self
        self.navigationItem.searchController = searchController
    }
}

extension ListVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.filteredList.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: "CryptoCell".self),
                                                       for: indexPath) as? CryptoCell else { return UITableViewCell() }
        cell.delegate = self
        cell.configureCell(viewModel?.filteredList[indexPath.row], indexPath.row)
        return cell
    }
}

extension ListVC: CryptoCellProtocol {
    func addToBookMark(_ model: Crypto?) {
        viewModel?.addToBookMark(model)
    }
}

extension ListVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        viewModel?.updateSearchResults(for: searchController)
    }
}

extension ListVC: WatchListDelegate {
    func resetDeletedIconStatus(_ model: Crypto?) {
        viewModel?.resetDeletedIconStatus(model)
    }
}

private 
extension ListVC {
    struct Constants {
        static let marketsName = "Markets"
        static let bookMarkImage = UIImage(systemName: "bookmark.fill")
        static let searchPlaceholder = "Search Cryptos"
    }
}
