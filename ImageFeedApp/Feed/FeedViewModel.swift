//
//  FeedViewModel.swift
//  ImageFeedApp
//
//  Created by Aleksandr SIdorov on 25.05.2024.
//

import SwiftUI

extension FeedViewModel {

    @MainActor
    enum ViewState: Equatable {

        case empty
        case loading(dataItem: FeedView.DataItem?)
        case loaded(dataItem: FeedView.DataItem, pageState: PageState)
        case error(dataItem: FeedView.DataItem?)

        static var initial: Self = .empty

        var dataItem: FeedView.DataItem? {
            switch self {
                case .empty:
                    nil
                case .loading(let dataItem), .error(let dataItem):
                    dataItem
                case .loaded(let dataItem, _):
                    dataItem
            }
        }

        var pageState: PageState? {
            switch self {
                case .empty, .loading, .error:
                    nil
                case .loaded(_ , let pageState):
                    pageState
            }
        }

        var isLoaded: Bool {
            switch self {
                case .empty, .loading, .error:
                    false
                case .loaded:
                    true
            }
        }
    }

    enum PageState: Equatable {

        case loading
        case idle
    }

}

extension FeedViewModel {

    enum Action {

        case didAppear
        case didRefresh
        case didShowItem(FeedView.DataItem.PhotoItem)
    }
}

@MainActor
@Observable
final class FeedViewModel {

    private(set) var state: ViewState

    private let loader = PhotosLoader()

    init() {
        self.state = .initial
    }

    func handle(_ action: Action) async {

        switch action {
            case .didAppear:
                await loadPhotos()
            case .didRefresh:
                await loadPhotos()
            case .didShowItem(let item):
                guard state.pageState == .idle, let items = state.dataItem?.items, items.firstIndex(of: item) == items.count - 1 else {
                    return
                }

                await loadNextBatch()
        }
    }

    private func loadPhotos() async {

        if !state.isLoaded {
            state = .loading(dataItem: state.dataItem)
        }

        do {
            let response = try await loader.reloadPhotos()
            state = .loaded(dataItem: .init(from: response), pageState: .idle)
        } catch {
            state = .error(dataItem: state.dataItem)
        }
    }

    private func loadNextBatch() async {
        guard let dataItem = state.dataItem else { return }

        state = .loaded(dataItem: dataItem, pageState: .loading)

        do {
            let response = try await loader.loadNextBatch()
            let newItems = response.photos.map {
                FeedView.DataItem.PhotoItem(id: $0.id, preview: .init(from: $0), fullPhoto: .init(from: $0))
            }
            let updatedItems = dataItem.items + newItems
            state = .loaded(dataItem: FeedView.DataItem(items: updatedItems), pageState: .idle)
        } catch {
            state = .loaded(dataItem: dataItem, pageState: .idle)
        }
    }
}

private extension FeedView.DataItem {

    init(from response: Response) {
        items = response.photos.map {
            PhotoItem(id: $0.id, preview: .init(from: $0), fullPhoto: .init(from: $0))
        }
    }
}

private extension FeedPhotoView.DataItem {

    init(from photoDTO: Response.Photo) {
        url = photoDTO.src.tiny
        name = photoDTO.photographer
    }
}

private extension FullImageView.DataItem {

    init(from photoDTO: Response.Photo) {
        url = photoDTO.src.original
        author = photoDTO.photographer
    }
}
