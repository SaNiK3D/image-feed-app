//
//  FeedPhotoView.swift
//  ImageFeedApp
//
//  Created by Aleksandr SIdorov on 28.05.2024.
//

import SwiftUI

struct FeedPhotoView: View {

    struct DataItem: Equatable {
        let url: URL
        let name: String
    }

    let dataItem: DataItem
    let didTapPhoto: () -> Void

    var body: some View {
        Color.clear.overlay {
            CachedAsyncImage(url: dataItem.url) { imagePhase in
                switch imagePhase {
                    case .empty:
                        Image(systemName: "photo")
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .overlay(alignment: .bottom) {
                                Text(dataItem.name)
                                    .frame(maxWidth: .infinity)
                                    .foregroundStyle(.foreground)
                                    .padding()
                                    .background(
                                        Gradient(colors: [Color.white.opacity(0), Color.white])
                                    )
                            }
                    case .failure:
                        Image(systemName: "photo")
                    @unknown default:
                        Image(systemName: "photo")
                }
            }
        }
        .frame(maxWidth: .infinity)
        .aspectRatio(contentMode: .fit)
    }
}

#Preview {
    FeedPhotoView(
        dataItem: .init(
            url: URL(string: "https://images.pexels.com/photos/24770134/pexels-photo-24770134.jpeg?auto=compress&cs=tinysrgb&dpr=1&fit=crop&h=200&w=280")!,
            name: "Deden Dicky Ramdhani"
        ),
        didTapPhoto: {}
    )
}
