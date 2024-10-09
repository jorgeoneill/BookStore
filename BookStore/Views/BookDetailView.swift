//
//  BookDetailView.swift
//  BookStore
//
//  Created by Jorge O'Neill on 08/10/2024.
//

import UIKit

final class BookDetailView: UIView {
    
    // MARK: - Private properties
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let titleLabel = UILabel()
    private let authorLabel = UILabel()
    private let descriptionTextView = UITextView()
    private let buyButton = UIButton(type: .system)
    private let favoriteButton = UIButton(type: .system)
    
    private let viewModel: ViewModel

    // MARK: - Lifecycle
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupSubviews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private methods
    private func setupSubviews() {
        // Configure the scroll view
        addSubview(scrollView)
        
        // Configure the content view
        scrollView.addSubview(contentView)

        // Configure Title Label
        titleLabel.text = viewModel.title
        titleLabel.font = .boldSystemFont(ofSize: 24)
        titleLabel.numberOfLines = 0
        contentView.addSubview(titleLabel)
        
        // Configure Favorite Button
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        //favoriteButton.tintColor = .systemRed
        contentView.addSubview(favoriteButton)
        updateFavoriteButton()
                
        // Configure Author Label
        authorLabel.text = viewModel.authoredBy
        authorLabel.font = .italicSystemFont(ofSize: 18)
        authorLabel.numberOfLines = 0
        contentView.addSubview(authorLabel)

        // Configure Description TextView
        descriptionTextView.attributedText = viewModel.formattedDescription
        descriptionTextView.font = .systemFont(ofSize: 16)
        //descriptionLabel.numberOfLines = 0
        descriptionTextView.isScrollEnabled = false
        descriptionTextView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        descriptionTextView.backgroundColor = .clear
        descriptionTextView.isEditable = false
        contentView.addSubview(descriptionTextView)

        // Configure Buy Button
        if viewModel.buyLink != nil {
            buyButton.setTitle(viewModel.buyButtonTitle, for: .normal)
            buyButton.addTarget(self, action: #selector(buyButtonTapped), for: .touchUpInside)
            addSubview(buyButton)
        }
    }

    private func setupConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true // Important for vertical scrolling

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: favoriteButton.leadingAnchor, constant: -16).isActive = true

        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        favoriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        authorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        authorLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        authorLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor).isActive = true
        
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextView.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 10).isActive = true
        descriptionTextView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        descriptionTextView.trailingAnchor.constraint(equalTo: favoriteButton.trailingAnchor).isActive = true
        
        // Check if the buyButton was added
        if buyButton.superview != nil {
            buyButton.translatesAutoresizingMaskIntoConstraints = false
            buyButton.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 20).isActive = true
            buyButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
            // If the buyButton is added, ensure the contentView bottom is aligned with it as the last visible element
            buyButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20).isActive = true
        } else {
            // If the buyButton is not added, ensure the contentView bottom is aligned with descriptionLabel as the last visible element
            descriptionTextView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20).isActive = true
        }
    }
    
    private func updateFavoriteButton() {
        let symbolName = viewModel.isFavorite ? Constants.UI.favoriteOnSymbolName : Constants.UI.favoriteOffSymbolName
        favoriteButton.setImage(UIImage(systemName: symbolName), for: .normal)
    }
    
    @objc private func favoriteButtonTapped() {
        viewModel.isFavorite.toggle()
        updateFavoriteButton()
    }

    @objc private func buyButtonTapped() {
        guard let buyLink = viewModel.buyLink else { return }
       
        UIApplication.shared.open(buyLink)
    }
}
