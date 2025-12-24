//
//  ProfileFeatureAPIClient.swift
//  ProfileFeature
//
//  Created by Chinthaka Perera on 12/23/25.
//

import Foundation
import PlatformKit

public class ProfileFeatureAPIClient: ProfileFeatureAPI {
    public init() {}

    public func fetchFeeds() async throws -> any ProfileDTO {
        return ProfileDTOImpl()
    }
}
