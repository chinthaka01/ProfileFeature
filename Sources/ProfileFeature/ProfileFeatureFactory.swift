//
//  File 4.swift
//  ProfileFeature
//
//  Created by Chinthaka Perera on 12/23/25.
//

import Foundation
import PlatformKit

struct ProfileFeatureFactory: FeatureFactory {
    let dependencies: ProfileDependencies

    func makeFeature() -> MicroFeature {
        ProfileFeatureEntry(dependencies: dependencies)
    }
}
