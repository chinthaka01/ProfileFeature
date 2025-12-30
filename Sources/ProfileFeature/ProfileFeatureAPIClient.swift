//
//  ProfileFeatureAPIClient.swift
//  ProfileFeature
//
//  Created by Chinthaka Perera on 12/23/25.
//

import Foundation
import PlatformKit

public final class ProfileFeatureAPIClient: ProfileFeatureAPI {
    
    private let bffBase = "https://jsonplaceholder.typicode.com"

    public let networking: any Networking

    public init(networking: Networking) {
        self.networking = networking
    }

    public func fetchProfile() async throws -> User? {
        let url = "\(bffBase)/users/1"

        let user = try await networking.fetchSingle(
            url: url,
            type: User.self
        )
        
        return user
    }
}
