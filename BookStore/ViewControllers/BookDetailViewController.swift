//
//  BookDetailViewController.swift
//  BookStore
//
//  Created by Jorge O'Neill on 08/10/2024.
//

import UIKit

final class BookDetailViewController: UIViewController {
    
    // MARK: - Private properties
    private var bookDetailView: BookDetailView!
    private let viewModel: BookDetailView.ViewModel

    // MARK: - Lifecycle
    init(viewModel: BookDetailView.ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground // Adapts to light/dark mode
        setupViews()
        setupConstraints()
    }

    // MARK: - Private methods
    private func setupViews() {
        bookDetailView = BookDetailView(viewModel: viewModel)
        view.addSubview(bookDetailView)
    }

    private func setupConstraints() {
        bookDetailView.translatesAutoresizingMaskIntoConstraints = false
        // Setting all constraints relative do safe area, allows for correct display on device rotation
        bookDetailView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        bookDetailView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        bookDetailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        bookDetailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
}
