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

enum ProfileCache {
    private static let fileName = "cached_profile.json"

    private static var fileURL: URL {
        let dir = FileManager.default.urls(for: .documentDirectory,
                                           in: .userDomainMask).first!

        return dir.appendingPathComponent(fileName)
    }

    static func save(_ user: User) throws {
        let data = try JSONEncoder().encode(user)
        try data.write(to: fileURL, options: .atomic)
    }

    static func load() throws -> User? {
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            return nil
        }
        let data = try Data(contentsOf: fileURL)
        return try JSONDecoder().decode(User.self, from: data)
    }
}

