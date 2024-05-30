//
//  ImageFeedAppApp.swift
//  ImageFeedApp
//
//  Created by Aleksandr SIdorov on 25.05.2024.
//

import SwiftUI

@main
struct ImageFeedAppApp: App {

    @State private var selectedPhoto: FullImageView.DataItem?

    var body: some Scene {
        WindowGroup {
            FeedView(viewModel: FeedViewModel())
        }
    }
}
