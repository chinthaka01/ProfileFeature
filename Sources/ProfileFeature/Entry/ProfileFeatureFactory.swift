//
//  File 4.swift
//  ProfileFeature
//
//  Created by Chinthaka Perera on 12/23/25.
//

import Foundation
import PlatformKit

/// Factory that creates the Profile micro feature.
///
/// The shell app owns an instance of this type and calls `makeFeature()`
/// to obtain the tab descriptor and root view for the Profile module.
@MainActor
public struct ProfileFeatureFactory: @MainActor FeatureFactory {
    public let dependencies: ProfileDependencies
    
    public init(dependencies: ProfileDependencies) {
        self.dependencies = dependencies
    }

    @MainActor
    public func makeFeature() -> MicroFeature {
        ProfileFeatureEntry(dependencies: dependencies)
    }
}
