//
//  ProfileCache.swift
//  ProfileFeature
//
//  This is reprenting local storage.
//
//  Created by Chinthaka Perera on 1/4/26.
//

import Foundation
import PlatformKit

/// Simple file‑based cache for the Profile feature.
///
/// Stores the last successfully loaded `User` as JSON in the app's Documents directory.
/// So the profile screen can show data when the network is unavailable.
enum ProfileCache {
    
    /// File name used for the cached profile JSON.
    private static let fileName = "cached_profile.json"

    /// Location of the cache file in the app's Documents directory.
    private static var fileURL: URL {
        let dir = FileManager.default.urls(for: .documentDirectory,
                                           in: .userDomainMask).first!

        return dir.appendingPathComponent(fileName)
    }

    /// Saves the given user as JSON on disk (file).
    ///
    /// - Parameter user: The profile to cache.
    static func save(_ user: User) throws {
        let data = try JSONEncoder().encode(user)
        try data.write(to: fileURL, options: .atomic)
    }

    /// Loads the cached user from file, if it exists.
    ///
    /// - Returns: The cached `User` or `nil` when no cache is available.
    static func load() throws -> User? {
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            return nil
        }
        let data = try Data(contentsOf: fileURL)
        return try JSONDecoder().decode(User.self, from: data)
    }
}

