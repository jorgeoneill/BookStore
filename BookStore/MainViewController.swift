//
//  MainViewController.swift
//  BookStore
//
//  Created by Jorge O'Neill on 07/10/2024.
//

import UIKit

final class MainViewController: UIViewController {
    
    private var mainViewModel = MainView.ViewModel()
    private var mainView: MainView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupMainView()
        setupConstraints()
        
        Task {
            await mainViewModel.getBooks()
        }
   
    }
    
    private func setupNavigationBar() {
        navigationItem.title = String(localized: "navigation_title")
        let barButton = UIBarButtonItem(
            image: UIImage(systemName: Constants.UI.favoritesSymbolName),
            style: .plain,
            target: self,
            action: nil
        )
       // barButton.tintColor = UIColor(named: "primaryButtonBackgroundColor")
        barButton.target = self
        barButton.action = #selector(barButtonPressed)
        navigationItem.rightBarButtonItem = barButton
    }
    
    private func setupMainView() {
        mainView = MainView(viewModel: mainViewModel)
        view.addSubview(mainView)
    }

    private func setupConstraints() {
        mainView.translatesAutoresizingMaskIntoConstraints = false
        mainView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        mainView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        mainView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        mainView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    @objc private func barButtonPressed() {
        // TODO: Implement favorites persistence/filtering
        print("Bar button pressed")
    }
}
