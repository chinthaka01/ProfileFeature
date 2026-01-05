//
//  File 3.swift
//  ProfileFeature
//
//  Created by Chinthaka Perera on 12/23/25.
//

import Foundation
import SwiftUI
import PlatformKit
import DesignSystem

/// Root container for the Profile feature.
///
/// Sets up the navigation stack for all Profile screens.
struct ProfileRootView: View {
    @StateObject private var viewModel: ProfileViewModel

    /// Injects an existing view model created by `ProfileFeatureEntry`.
    init(viewModel: ProfileViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            ProfileScreen(viewModel: viewModel)
        }
    }
}
