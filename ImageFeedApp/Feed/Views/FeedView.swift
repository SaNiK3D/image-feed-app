//
//  ContentView.swift
//  ImageFeedApp
//
//  Created by Aleksandr SIdorov on 25.05.2024.
//

import SwiftUI

struct FeedView: View {

    struct DataItem: Equatable {
        let items: [PhotoItem]

        struct PhotoItem: Equatable, Identifiable {
            let id: Int
            let preview: FeedPhotoView.DataItem
            let fullPhoto: FullImageView.DataItem
        }
    }

    private let columns: [GridItem] = [GridItem(.flexible()), GridItem(.flexible())]
    @Namespace private var feed

    @State private var selectedPhoto: DataItem.PhotoItem?

    @State private var viewModel: FeedViewModel

    init(viewModel: FeedViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        switch viewModel.state {
            case .empty:
                Color.clear
                    .onAppear {
                        Task {
                            await viewModel.handle(.didAppear)
                        }
                    }
            case .loading:
                ProgressView()
            case .loaded(let dataItem, let pageState):
                list(dataItem: dataItem, pageState: pageState)
            case .error:
                FullscreenErrorView(didTapReload: {
                    Task {
                        await viewModel.handle(.didRefresh)
                    }
                })
        }
    }

    func list(dataItem: DataItem, pageState: FeedViewModel.PageState) -> some View {
        ZStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 8) {
                    ForEach(dataItem.items) { item in
                        Button {
                            selectedPhoto = item
                        } label: {
                            FeedPhotoView(dataItem: item.preview) {
                                selectedPhoto = item
                            }
                            .clipShape(.rect(cornerRadius: 8))
                            .shadow(radius: 10)
                            .onAppear {
                                Task {
                                    await viewModel.handle(.didShowItem(item))
                                }
                            }
                        }
                    }
                }

                if pageState == .loading {
                    ProgressView()
                        .padding()
                }
            }
            .refreshable {
                await viewModel.handle(.didRefresh)
            }

            if let photo = selectedPhoto {
                FullImageView(dataItem: photo.fullPhoto, didTapClose: { selectedPhoto = nil })
                    .zIndex(2)
                    .onTapGesture {
                        selectedPhoto = nil
                    }
                    .transition(.opacity)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .animation(.linear(duration: 0.1), value: selectedPhoto)
    }
}

#Preview {
    FeedView(viewModel: FeedViewModel())
}
