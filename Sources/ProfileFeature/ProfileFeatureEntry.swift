import SwiftUI
import UIKit
import PlatformKit
import DesignSystem

public struct ProfileFeatureEntry: MicroFeature {
    public let id = "profile"
    public let title = "Profile"
    public let tabIcon: UIImage

    private let dependencies: ProfileDependencies

    public init(
        dependencies: ProfileDependencies,
        tabIcon: UIImage = UIImage(systemName: "banknote")!
    ) {
        self.dependencies = dependencies
        self.tabIcon = tabIcon
    }

    public func makeRootView() -> AnyView {
        let viewModel = ProfileViewModel(
            api: dependencies.profileAPI,
            analytics: dependencies.analytics
        )
        return AnyView(ProfileRootView(viewModel: viewModel))
    }
}

