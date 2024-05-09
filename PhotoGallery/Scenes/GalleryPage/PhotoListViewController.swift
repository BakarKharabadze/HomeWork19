//
//  PhotoListViewController.swift
//  PhotoGallery
//
//  Created by Bakar Kharabadze on 5/8/24.
//

import UIKit

final class PhotoListViewController: UIViewController {
    
    //MARK: Properties
    private let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    private let viewModel = PhotoListViewModel()
    private var dataSource: UICollectionViewDiffableDataSource<Section, Photo>!
    
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    //MARK: SetupUI
    private func setup() {
        viewModel.delegate = self
        viewModel.viewDidLoad()
        setupCollectionView()
        setupNavigationBar()
        configureDataSource()
    }
    
    private func setupCollectionView() {
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.scrollDirection = .vertical
        
        let itemsPerRow: CGFloat = 3
        let spacing: CGFloat = 0.5
        let totalSpacing = spacing * (itemsPerRow - 1)
        let availableWidth = view.bounds.width - (spacing * 2)
        let itemWidth = (availableWidth - totalSpacing) / itemsPerRow
        let itemSize = CGSize(width: itemWidth, height: itemWidth)
        collectionViewFlowLayout.itemSize = itemSize
        collectionViewFlowLayout.minimumLineSpacing = 0
        collectionViewFlowLayout.minimumInteritemSpacing = 0
        collectionViewFlowLayout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        
        collectionView.collectionViewLayout = collectionViewFlowLayout
        
        view.addSubview(collectionView)
        collectionView.isPagingEnabled = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.contentInset.top = 8
        
        collectionView.delegate = self
        collectionView.register(PhotoListViewCell.self, forCellWithReuseIdentifier: "cell")
    }
    
    private func setupNavigationBar() {
        let titleLabel = UILabel()
        titleLabel.text = "გალერეა"
        titleLabel.textColor = .blue
        titleLabel.font = UIFont.boldSystemFont(ofSize: 30)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        navigationItem.titleView = titleLabel
    }
}

//MARK: UICollectionViewDelegate
extension PhotoListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelectItemAt(index: indexPath.row)
    }
}

//MARK: PhotoListViewModelDelegate
extension PhotoListViewController: PhotoListViewModelDelegate {
    func didFetchPhotos(_ photos: [Photo]) {
        DispatchQueue.main.async {
            var snapshot = NSDiffableDataSourceSnapshot<Section, Photo>()
            snapshot.appendSections([.main])
            snapshot.appendItems(photos)
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
    
    func navigateToPhotoDetail(photos: [Photo], selectedPhotoIndex: Int) {
        let photoDetailVC = PhotoDetailViewController()
        photoDetailVC.photos = photos
        photoDetailVC.currentIndex = selectedPhotoIndex
        navigationController?.pushViewController(photoDetailVC, animated: true)
    }
}

//MARK: UICollectionViewDataSource
extension PhotoListViewController {
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Photo>(collectionView: collectionView) { (collectionView, indexPath, photo) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? PhotoListViewCell
            cell?.configure(with: photo)
            return cell
        }
    }
}

//MARK: CollectionView Sections
extension PhotoListViewController {
    enum Section {
        case main
    }
}
