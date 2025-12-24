//
//  ProfileDependenciesImpl.swift
//  ProfileFeature
//
//  Created by Chinthaka Perera on 12/23/25.
//

import Foundation
import PlatformKit

public class ProfileDependenciesImpl: ProfileDependencies {
    public let profileAPI: any ProfileFeatureAPI
    public let analytics: any Analytics
    
    
    public init(profileAPI: ProfileFeatureAPI, analytics: Analytics) {
        self.profileAPI = profileAPI
        self.analytics = analytics
    }
}
