//
//  FullscreenErrorView.swift
//  ImageFeedApp
//
//  Created by Aleksandr SIdorov on 30.05.2024.
//

import SwiftUI

struct FullscreenErrorView: View {

    var didTapReload: () -> Void

    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundStyle(.yellow)
                .font(.title)

            Text("Unable to load")

            Button("Reload", action: didTapReload)
        }
    }
}

#Preview {
    FullscreenErrorView(didTapReload: {})
}
