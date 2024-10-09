//
//  MainViewController.swift
//  BookStore
//
//  Created by Jorge O'Neill on 07/10/2024.
//

import UIKit

final class MainViewController: UIViewController {
    
    // MARK: - Private properties
    private var mainViewModel = MainView.ViewModel()
    private var mainView: MainView!
    private var barButton: UIBarButtonItem!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground  // Adapts to light/dark mode
        setupNavigationBar()
        setupMainView()
        setupConstraints()
        mainViewModel.onBookSelected = { [weak self] book in
            self?.displayBookDetail(book: book)
        }
        loadDataTask()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mainViewModel.onDataUpdated?()
    }
    
    private func loadDataTask() {
        Task {
            do {
                try await mainViewModel.getBooks()
            } catch {
                self.displayError(
                    alertTitle: String(localized: "data_unavailable_error_title"),
                    alertMessage: error.localizedDescription,
                    buttonAction: self.loadDataTask
                )
            }
        }
    }

    
    // MARK: - Private methods
    private func setupNavigationBar() {
        navigationItem.title = String(localized: "navigation_title")
        barButton = UIBarButtonItem(
            image: UIImage(systemName: Constants.UI.favoriteOffSymbolName),
            style: .plain,
            target: self,
            action: nil
        )
        barButton.target = self
        barButton.action = #selector(barButtonPressed)
        navigationItem.rightBarButtonItem = barButton
        updateBarButton()
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
        
    private func displayBookDetail(book: Book) {
        let bookDetailViewModel =  BookDetailView.ViewModel(book: book)
        let bookDetailViewController = BookDetailViewController(viewModel: bookDetailViewModel)
        navigationController?.pushViewController(bookDetailViewController, animated: true)
    }
    
    private func updateBarButton() {
        let imageName = mainViewModel.shouldDisplayFavorites ? Constants.UI.favoriteOnSymbolName : Constants.UI.favoriteOffSymbolName
        barButton.image = UIImage(systemName: imageName)
    }

    @objc private func barButtonPressed() {
        mainViewModel.toggleFavorites()
        updateBarButton()
    }
    
    private func displayError(
        alertTitle: String,
        alertMessage: String,
        buttonTitle: String? = String(localized: "ok_button"),
        buttonAction: (() -> Void)? = nil
    ) {
        let alert = UIAlertController(
            title: alertTitle,
            message: alertMessage,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(
            title: buttonTitle, style: .default,
            handler: {_ in
            buttonAction?()
            }))
        self.present(alert, animated: true, completion: nil)
    }
}
