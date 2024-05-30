//
//  PhotosLoader.swift
//  ImageFeedApp
//
//  Created by Aleksandr SIdorov on 28.05.2024.
//

import Foundation

final class PhotosLoader {

    private let url = "https://api.pexels.com/v1/curated/"
    private let auth = "" // TODO: Insert your api key here
    private let pageSize = 20

    private var currentPage = 1

    func reloadPhotos() async throws -> Response {
        currentPage = 1
        return try await loadPhotos(page: currentPage)
    }

    func loadNextBatch() async throws -> Response {
        currentPage += 1
        return try await loadPhotos(page: currentPage)
    }

    private func loadPhotos(page: Int) async throws -> Response {
        var request = URLRequest(url: URL(string: url)!)
        request.addValue(auth, forHTTPHeaderField: "Authorization")

        request.url?.append(queryItems: [
            .init(name: "page", value: "\(page)"),
            .init(name: "per_page", value: "\(pageSize)")
        ])

        let (data, _) = try await URLSession.shared.data(for: request)

        return try await Task { @MainActor in
            try JSONDecoder().decode(Response.self, from: data)
        }.value
    }
}
