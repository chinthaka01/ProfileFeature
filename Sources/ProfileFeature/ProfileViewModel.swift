//
//  File 2.swift
//  ProfileFeature
//
//  Created by Chinthaka Perera on 12/23/25.
//

import Foundation
import PlatformKit

@MainActor
final class ProfileViewModel: ObservableObject {
    let api: any ProfileFeatureAPI
    let analytics: any Analytics
    
    @Published var profile: User?

    init(api: ProfileFeatureAPI, analytics: Analytics) {
        self.api = api
        self.analytics = analytics
    }
    
    func loadProfile() async {
        do {
            profile = try await api.fetchProfile()
        } catch {
            print("Failed to load profile: \(error)")
        }
    }
}
