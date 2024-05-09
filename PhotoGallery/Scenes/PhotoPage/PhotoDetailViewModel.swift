//
//  PhotoDetailViewModel.swift
//  PhotoGallery
//
//  Created by Bakar Kharabadze on 5/8/24.
//

import Foundation

class PhotoDetailViewModel {
    
    //MARK: Properties
    var photos: [Photo] = []
    var currentIndex: Int = 0 {
        didSet {
            if currentIndex < 0 {
                currentIndex = photos.count - 1
            } else if currentIndex >= photos.count {
                currentIndex = 0
            }
            fetchPhoto()
        }
    }
    var photoData: Data?
    var onPhotoLoaded: (() -> Void)?
    
    //MARK: Methods
    func fetchPhoto() {
        let photo = photos[currentIndex]
        guard let url = URL(string: photo.urls.regular) else {
            self.photoData = nil
            self.onPhotoLoaded?()
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                self?.photoData = nil
                self?.onPhotoLoaded?()
                return
            }
            self?.photoData = data
            self?.onPhotoLoaded?()
        }.resume()
    }
    func showPreviousPhoto() {
        currentIndex -= 1
    }
    
    func showNextPhoto() {
        currentIndex += 1
    }
}
