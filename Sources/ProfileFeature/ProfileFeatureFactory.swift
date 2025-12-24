//
//  File 4.swift
//  ProfileFeature
//
//  Created by Chinthaka Perera on 12/23/25.
//

import Foundation
import PlatformKit

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
