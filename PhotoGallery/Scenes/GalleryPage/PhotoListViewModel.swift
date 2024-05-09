//
//  PhotoListViewModel.swift
//  PhotoGallery
//
//  Created by Bakar Kharabadze on 5/8/24.
//

import Foundation
import Networking

//MARK: PhotoListViewModelDelegate
protocol PhotoListViewModelDelegate: AnyObject {
    func didFetchPhotos(_ photos: [Photo])
    func navigateToPhotoDetail(photos: [Photo], selectedPhotoIndex: Int)
}

final class PhotoListViewModel {
    
    //MARK: Properties
    private var photos: [Photo] = []
    weak var delegate: PhotoListViewModelDelegate?
    
    //MARK: Life cycle
    func viewDidLoad() {
        fetchPhotos()
    }
    
    //MARK: Fetch
    private func fetchPhotos() {
        let url = "https://api.unsplash.com/photos/?client_id=gr1283rb5XY3Dz6Ph1R5TPiYwJbwhkmQwppTvDY2gpU&fbclid=IwZXh0bgNhZW0CMTAAAR0yqElR8RksDRSgBRi6X53ejW8osE3rZPI5SymofZB9c7xAJvpV2RxZxnI_aem_ARsJBH8x6NBqPlN43ObNN-iAXAF84dKn2ca_hil7frtEin-HK4oC9whFQdyipRFtTCXhBZAI2T2b15d6WhRC0INO&per_page=100"
        
        NetworkManager.shared.request(url: url) { [weak self] (result: Result<[Photo], NetworkError>) in
            switch result {
            case .success(let photos):
                self?.photos = photos
                self?.delegate?.didFetchPhotos(photos)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func didSelectItemAt(index: Int) {
        delegate?.navigateToPhotoDetail(photos: photos, selectedPhotoIndex: index)
    }
}

