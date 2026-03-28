//
//  ImageUrlModel.swift
//  hotel_management_system
//
//  Created by mac on 19/3/26.
//

struct UnsplashResponse: Decodable {
    let results: [Photo]
}

struct Photo: Decodable {
    let urls: PhotoURL
}

struct PhotoURL: Decodable {
    let regular: String
}
