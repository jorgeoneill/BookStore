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
    private var viewModel: BookCellView.ViewModel?

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
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)
    }
    
    private func setupConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    // MARK: - Public methods
    func configure(with viewModel: BookCellView.ViewModel) {
        self.viewModel = viewModel
        
        Task {
            if let image = await viewModel.fetchThumbnailImage() {
                self.imageView.image = image
            }
        }
    }

}


