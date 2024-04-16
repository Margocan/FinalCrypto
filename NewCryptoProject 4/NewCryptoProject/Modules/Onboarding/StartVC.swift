import UIKit

final class StartVC: UIViewController {
    
    @IBOutlet private weak var startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    
    @IBAction func startButtonTapped(_ sender: Any) {
        let urlSessionService = URLSessionManager()
        let listDataProvider = ListDataProvider(serviceManager: urlSessionService)
        let listVC = ListVC()
        listVC.viewModel = ListViewModel(dataProvider: listDataProvider)
        self.navigationController?.pushViewController(listVC, animated: true)
    }
}

private
extension StartVC {
    
    func setupUI() {
        view.backgroundColor = UIColor(red: 14/255, green: 14/255, blue: 14/255, alpha: 1.0)
        startButton.layer.cornerRadius = 40
    }
}
