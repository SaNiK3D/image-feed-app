//
//  Response.swift
//  ImageFeedApp
//
//  Created by Aleksandr SIdorov on 28.05.2024.
//

import Foundation

struct Response: Decodable {
    let photos: [Photo]

    struct Photo: Decodable, Equatable {
        let id: Int
        let src: Source
        let photographer: String
    }

    struct Source: Decodable, Equatable {
        let tiny: URL
        let original: URL
    }
}
