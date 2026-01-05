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
    
    private nonisolated(unsafe) var observer: NSObjectProtocol?
    
    @Published var profile: User?
    @Published var isLoading = true
    @Published var error: Error? = nil
    @Published var selfPostsCount: Int?
    @Published var loadedFromCache: Bool = false

    init(api: ProfileFeatureAPI, analytics: Analytics) {
        self.api = api
        self.analytics = analytics
        
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
        if let observer {
            NotificationCenter.default.removeObserver(observer)
        }
    }
}
