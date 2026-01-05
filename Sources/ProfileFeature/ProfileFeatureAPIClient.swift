//
//  ProfileFeatureAPIClient.swift
//  ProfileFeature
//
//  Created by Chinthaka Perera on 12/23/25.
//

import Foundation
import PlatformKit

public final class ProfileFeatureAPIClient: ProfileFeatureAPI {
    public let networking: any Networking
    private let bffPath = "users"

    public init(networking: Networking) {
        self.networking = networking
    }

    public func fetchProfile() async throws -> User {
        let user = try await networking.fetchSingle(
            bffPath: "\(bffPath)/1",
            type: User.self
        )
        
        Task {
            try ProfileCache.save(user)
        }
        
        return user
    }
}
