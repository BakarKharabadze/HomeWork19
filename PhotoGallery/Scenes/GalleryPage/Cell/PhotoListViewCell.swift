//
//  PhotoListViewCell.swift
//  PhotoGallery
//
//  Created by Bakar Kharabadze on 5/8/24.
//

import UIKit

final class PhotoListViewCell: UICollectionViewCell {
    
    //MARK: Properties
    private let photo = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupPhoto()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: SetupUI
    private func setupPhoto() {
        contentView.addSubview(photo)
        photo.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            photo.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            photo.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            photo.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            photo.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5)
        ])
        
        photo.contentMode = .scaleAspectFill
        photo.clipsToBounds = true
    }
    
    func configure(with model: Photo) {
        guard let url = URL(string: model.urls.small) else { return }
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async {
                self?.photo.image = UIImage(data: data)
            }
        }.resume()
    }
    
    func getImage() -> UIImage? {
        photo.image
    }
}
