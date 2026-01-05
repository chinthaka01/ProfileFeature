import SwiftUI
import UIKit
import PlatformKit
import DesignSystem

struct ProfileFeatureEntry: @MainActor MicroFeature {
    let id = "profile"
    let title = "Profile"
    let tabIcon: UIImage
    let selectedTabIcon: UIImage

    private let dependencies: ProfileDependencies
    private let viewModel: ProfileViewModel

    @MainActor
    init(dependencies: ProfileDependencies) {
        self.dependencies = dependencies
        self.tabIcon = UIImage(systemName: "person")!
        self.selectedTabIcon = UIImage(systemName: "person")!
        
        self.viewModel = ProfileViewModel(
            api: dependencies.profileAPI,
            analytics: dependencies.analytics
        )
    }

    @MainActor
    func makeRootView() -> AnyView {
        return AnyView(ProfileRootView(viewModel: viewModel))
    }
}

