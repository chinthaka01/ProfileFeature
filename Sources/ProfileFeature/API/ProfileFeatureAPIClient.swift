//
//  ProfileFeatureAPIClient.swift
//  ProfileFeature
//
//  Created by Chinthaka Perera on 12/23/25.
//

import Foundation
import PlatformKit

/// Concrete implementation of `ProfileFeatureAPI` used by the Profile feature.
///
/// Talks to the BFF.
public final class ProfileFeatureAPIClient: ProfileFeatureAPI {
    
    /// Shared networking abstraction injected from the shell app.
    public let networking: any Networking
    
    /// Base BFF path for users‑related endpoints.
    private let bffPath = "users"

    public init(networking: Networking) {
        self.networking = networking
    }

    /// Fetches the profile for the logged‑in user.
    ///
    /// For the demo this always loads user with id `1`,
    /// Then asynchronously persists it to disk so the Profile feature can fall back to a cached
    /// copy when the network is unavailable.
    public func fetchProfile() async throws -> User {
        let user = try await networking.fetchSingle(
            bffPath: "\(bffPath)/1",
            type: User.self
        )
        
        Task {
            /// Persist the profile in a file.
            try ProfileCache.save(user)
        }
        
        return user
    }
}
