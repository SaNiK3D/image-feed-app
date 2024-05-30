//
//  FullImageView.swift
//  ImageFeedApp
//
//  Created by Aleksandr SIdorov on 29.05.2024.
//

import SwiftUI

struct FullImageView: View {

    struct DataItem: Equatable {
        let url: URL
        let author: String
    }

    let dataItem: DataItem
    let didTapClose: () -> Void

    var body: some View {
        Color.black
            .ignoresSafeArea()
            .overlay {
                ZStack {
                    AsyncImage(url: dataItem.url) { imagePhase in
                        switch imagePhase {
                            case .empty:
                                ProgressView()
                                    .tint(.white)
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            case .failure:
                                EmptyView()
                            @unknown default:
                                EmptyView()
                        }
                    }

                    VStack {
                        Text(dataItem.author)
                            .foregroundStyle(.white)
                            .padding(8)
                            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 8))
                            .padding(.top, 4)
                        Spacer()
                    }

                    HStack {
                        VStack(alignment: .leading) {
                            Button {
                                didTapClose()
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .tint(.white)
                                    .font(.title)
                                    .padding(8)
                            }

                            Spacer()
                        }
                        .padding(.leading)

                        Spacer()
                    }
                }
            }
            .onTapGesture(perform: didTapClose)
    }
}

#Preview {
    FullImageView(dataItem: .init(
        url: URL(string: "https://images.pexels.com/photos/24816420/pexels-photo-24816420.jpeg?auto=compress&cs=tinysrgb&dpr=1&fit=crop&h=200&w=280")!,
        author: "Deden Dicky Ramdhani"), 
        didTapClose: {}
    )
}
