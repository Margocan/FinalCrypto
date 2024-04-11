//
//  SceneDelegate.swift
//  CryptoTracker
//
//  Created by Margarita Can on 18.03.2024.
//

import UIKit

final class StartVC: UIViewController {
    
    @IBOutlet private weak var startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    
    @IBAction func startButtonTapped(_ sender: Any) {
        ///Implement.
        let listVC = ListVC()
        listVC.viewModel = ListViewModel()
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
