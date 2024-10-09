//
//  BookCellView.swift
//  BookStore
//
//  Created by Jorge O'Neill on 07/10/2024.
//

import UIKit

final class BookCellView: UICollectionViewCell {
    // MARK: - Identifier static property
    static let identifier = Constants.UI.bookCellViewIdentifier
    
    // MARK: - Private properties
    private let imageView = UIImageView()
    private let containerView = UIView()  // Container view for rounded corners and background
    
    private var viewModel: ViewModel?

    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    private func setupSubviews() {
        containerView.layer.cornerRadius = 10
        containerView.layer.masksToBounds = true
        containerView.backgroundColor = UIColor.systemGray3.withAlphaComponent(0.6) // Subtle background color
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)
        
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(imageView)
    }
    
    private func setupConstraints() {
        containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8).isActive = true
        containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8).isActive = true
        containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8).isActive = true
        
        imageView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
    }
    
    // MARK: - Public methods
    func configure(with viewModel: ViewModel) {
        self.viewModel = viewModel
        
        Task {
            if let image = await viewModel.fetchThumbnailImage() {
                self.imageView.image = image
            }
        }
    }
}
