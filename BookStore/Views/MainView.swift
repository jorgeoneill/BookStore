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
    private var viewModel: MainView.ViewModel
    
    // MARK: - Lifecycle
    init(viewModel: MainView.ViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupCollectionView()
        
        // Bind to view model updates
        viewModel.onDataUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
       // collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(BookCellView.self, forCellWithReuseIdentifier: BookCellView.identifier)
        addSubview(collectionView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
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
}

// MARK: - Collection view data source methods
extension MainView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfBooks
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
