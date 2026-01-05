//
//  ProfileViewModel.swift
//  ProfileFeature
//
//  Created by Chinthaka Perera on 12/23/25.
//

import Foundation
import PlatformKit

/// View model for the Profile feature.
///
/// Handles loading the profile from the BFF, falling back to a cached profile when offline, and
/// listening for the self posts count broadcast from the Feed feature.
@MainActor
final class ProfileViewModel: ObservableObject {
    
    /// API used to load the profile.
    let api: any ProfileFeatureAPI
    
    /// Analytics abstraction shared with other features.
    let analytics: any Analytics
    
    /// NotificationCenter observer token for the self‑posts count broadcast.
    private nonisolated(unsafe) var observer: NSObjectProtocol?
    
    /// Currently loaded profile, if any.
    @Published var profile: User?
    
    /// Whether the initial/load operation is in progress.
    @Published var isLoading = true
    
    /// Last error that occurred while loading the profile.
    @Published var error: Error? = nil
    
    /// Number of posts created by the logged‑in user (broadcast by Feed).
    @Published var selfPostsCount: Int?
    
    /// Indicates that `profile` was populated from the local cache instead of network.
    @Published var loadedFromCache: Bool = false

    init(api: ProfileFeatureAPI, analytics: Analytics) {
        self.api = api
        self.analytics = analytics
        
        // Listen for the post count broadcast from the Feed feature.
        observer = NotificationCenter.default.addObserver(
            forName: AppBroadcast.selfPostsCount,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            guard let count = notification.userInfo?["payload_count"] as? Int else { return }

            Task { @MainActor in
                self?.selfPostsCount = count
            }
        }
    }
    
    /// Loads the profile from the network, falling back to a cached copy when the device is offline.
    func loadProfile() async {
        profile = nil
        error = nil
        isLoading = true
        loadedFromCache = false

        do {
            profile = try await api.fetchProfile()
        } catch {
            print("Failed to load profile: \(error)")
            
            let nsError = error as NSError
            if nsError.domain == NSURLErrorDomain && nsError.code == NSURLErrorNotConnectedToInternet {
                if let cached = try? ProfileCache.load() {
                    print("Loading the profile from cache.")

                    self.profile = cached
                    loadedFromCache = true
                } else {
                    self.error = error
                }
            } else {
                self.error = error
            }
        }
        
        isLoading = false
    }
    
    deinit {
        
        // Explicitly remove the observer when the view model is deallocated.
        if let observer {
            NotificationCenter.default.removeObserver(observer)
        }
    }
}
