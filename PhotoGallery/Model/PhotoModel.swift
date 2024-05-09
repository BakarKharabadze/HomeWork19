//
//  PhotoModel.swift
//  PhotoGallery
//
//  Created by Bakar Kharabadze on 5/8/24.
//

import Foundation

struct Photo: Codable, Equatable, Hashable {
    static func == (lhs: Photo, rhs: Photo) -> Bool {
        return lhs.urls == rhs.urls
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(urls)
    }

    let links: PhotoLinks
    let urls: PhotoUrls
}

struct PhotoUrls: Codable, Equatable, Hashable {
    let small: String
    let regular: String
    let full: String
}

struct PhotoLinks: Codable, Equatable  {
    let download: String
}
