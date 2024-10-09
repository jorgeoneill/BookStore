//
//  MainView.swift
//  BookStore
//
//  Created by Jorge O'Neill on 07/10/2024.
//

import UIKit

final class MainView: UIView {
    
    // MARK: - Private properties
    private var collectionView: UICollectionView!
    // Displays a message when book list is empty (eg: favorite filetring is on but no favorites selected)
    private let emptyListLabel = UILabel()

    private var viewModel: ViewModel
        
    // MARK: - Lifecycle
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupCollectionView()
        setupEmptyListLabel()
        setupConstraints()
        
        // Bind to view model updates
        viewModel.onDataUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.updateView()
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Ensure the frame is set before calculating item size
    override func layoutSubviews() {
        super.layoutSubviews()
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let padding = Constants.UI.genericPadding
            let availableWidth = frame.width - padding * 3
            let itemWidth = availableWidth / 2
            layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 1.5)
            layout.minimumInteritemSpacing = padding
            layout.minimumLineSpacing = padding
            layout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        }
    }
    
    // MARK: - Private methods
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(BookCellView.self, forCellWithReuseIdentifier: BookCellView.identifier)
        addSubview(collectionView)
    }
    
    private func setupEmptyListLabel() {
        emptyListLabel.text = viewModel.emptyListMessage
        emptyListLabel.textAlignment = .center
        emptyListLabel.textColor = .gray // Works well on light/dark modes
        emptyListLabel.font = UIFont.systemFont(ofSize: 20)
        emptyListLabel.isHidden = true // Initially hidden
        addSubview(emptyListLabel)
    }
    
    private func setupConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        emptyListLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyListLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        emptyListLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        emptyListLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
    
    private func updateView() {
        collectionView.reloadData()
        let hasBooks = viewModel.numberOfBooks > 0
        collectionView.isHidden = !hasBooks
        emptyListLabel.isHidden = hasBooks
        
    }
    
}

// MARK: - Collection view data source methods
extension MainView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfBooks
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookCellView.identifier, for: indexPath) as? BookCellView else {
            return UICollectionViewCell()
        }
        
        let cellViewModel = viewModel.bookCellViewModel(at: indexPath.item)
        cell.configure(with: cellViewModel)
        return cell
    }
}

// MARK: - Collection view data delegate methods
extension MainView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedBook = viewModel.book(at: indexPath.item) else { return }
        
        viewModel.onBookSelected?(selectedBook)
    }
}
