//
//  ProfileDependenciesImpl.swift
//  ProfileFeature
//
//  Created by Chinthaka Perera on 12/23/25.
//

import Foundation
import PlatformKit

/// Concrete implementation of `ProfileDependencies
///
/// The shell app creates one of these and passes it into `ProfileFeatureFactory`.
/// So the Profile feature can access its API client and analytics without depending directly on app‑level types.
public class ProfileDependenciesImpl: ProfileDependencies {
    public let profileAPI: any ProfileFeatureAPI
    public let analytics: any Analytics
    
    
    public init(profileAPI: ProfileFeatureAPI, analytics: Analytics) {
        self.profileAPI = profileAPI
        self.analytics = analytics
    }
}
