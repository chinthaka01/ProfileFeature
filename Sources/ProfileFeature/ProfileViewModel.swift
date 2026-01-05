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
    @Published var isLoading = true
    @Published var error: Error? = nil

    init(api: ProfileFeatureAPI, analytics: Analytics) {
        self.api = api
        self.analytics = analytics
    }
    
    func loadProfile() async {
        profile = nil
        error = nil
        isLoading = true

        do {
            profile = try await api.fetchProfile()
        } catch {
            print("Failed to load profile: \(error)")
            
            let nsError = error as NSError
            if nsError.domain == NSURLErrorDomain && nsError.code == NSURLErrorNotConnectedToInternet {
                if let cached = try? ProfileCache.load() {
                    print("Loading the profile from cache.")
                    self.profile = cached
                } else {
                    self.error = error
                }
            } else {
                self.error = error
            }
        }
        
        isLoading = false
    }
}
