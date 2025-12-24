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

    init(dependencies: ProfileDependencies) {
        self.dependencies = dependencies
        self.tabIcon = UIImage(systemName: "person")!
        self.selectedTabIcon = UIImage(systemName: "person")!
    }

    @MainActor
    func makeRootView() -> AnyView {
        let viewModel = ProfileViewModel(
            api: dependencies.profileAPI,
            analytics: dependencies.analytics
        )
        return AnyView(ProfileRootView(viewModel: viewModel))
    }
}

