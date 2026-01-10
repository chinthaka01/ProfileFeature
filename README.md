# ProfileFeature

`ProfileFeature` is a self‑contained micro frontend that implements the **Profile** tab of the Wefriends MFE demo iOS app. It is built as a Swift Package and depends only on shared abstractions from `PlatformKit` and styling from `DesignSystem`.

***

## What this feature shows

- Using **micro frontends** on iOS via a `MicroFeature` entry type and a `FeatureFactory`.
- Loading a profile from a **BFF API** through a feature‑specific protocol (`ProfileFeatureAPI`).
- **Offline‑first** behavior by caching the last profile to disk and using it when the network is unavailable.
- **Cross‑feature communication**: the Feed feature broadcasts the user’s post count, and the Profile feature displays it in the header.
- Simple **analytics demo** using an `Analytics` protocol injected from the shell.

***

## Architecture

### Public entry points

- `ProfileFeatureFactory`
  - Conforms to `FeatureFactory`.
  - Shell creates this with `ProfileDependencies` and calls `makeFeature()` to get the tab.

- `ProfileFeatureEntry`
  - Conforms to `MicroFeature`.
  - Provides:
    - `id = "profile"`
    - `title = "Profile"`
    - Tab icons (`UIImage(systemName: "person")`).
  - Builds `ProfileRootView` with an injected `ProfileViewModel`.

These two types are the only things the shell needs to know about this package; everything else is internal to the feature.

***

## Dependencies

### Protocols from PlatformKit

- `ProfileFeatureAPI`
  - `fetchProfile() async throws -> User`
- `ProfileDependencies`
  - `profileAPI: ProfileFeatureAPI`
  - `analytics: Analytics`
- `Analytics`
  - `track(_ event: AnalyticsEvent)`

### Concrete implementations in this package

- `ProfileFeatureAPIClient`
  - Uses `Networking` from `PlatformKit` to call the BFF (demo: `users/1`).
  - On every successful fetch, saves the `User` to disk using `ProfileCache`.

- `ProfileDependenciesImpl`
  - Simple container wiring `ProfileFeatureAPI` and `Analytics` for the feature.

***

## Offline cache

- `ProfileCache`
  - Encodes `User` to JSON and writes it to `Documents/cached_profile.json`.
  - Provides:
    - `save(_ user: User) throws`
    - `load() throws -> User?`

- `ProfileViewModel.loadProfile()` logic:
  - Try `api.fetchProfile()`.
  - If it fails with `NSURLErrorNotConnectedToInternet`, attempt `ProfileCache.load()`.
  - If cache exists:
    - Set `profile` from cache.
    - Set `loadedFromCache = true` so the UI shows a “Data served from cache” banner.
  - Otherwise, expose the error to the UI.

***

## Cross‑feature broadcast

The feature listens for the Feed feature’s “self posts count” broadcast:

- `AppBroadcast.selfPostsCount` (defined in `PlatformKit`) is the notification name.
- Feed posts an `Int` in `userInfo["payload_count"]`.

In `ProfileViewModel`:

- Registers an observer in `init` to update `selfPostsCount` whenever a broadcast is received.
- Exposes `@Published var selfPostsCount: Int?` which the header displays as `Posts: <count>`.

`deinit` removes the observer to avoid leaks.

***

## UI structure

Main types:

- `ProfileRootView`
  - Holds `ProfileViewModel` via `@StateObject`.
  - Sets up `NavigationStack` and hosts `ProfileScreen`.

- `ProfileScreen`
  - Drives the Profile UI based on the view model state:
    - `ProgressView` while loading.
    - `errorView` with retry on failure.
    - `emptyView` if no profile is available.
    - On success, shows a `ScrollView` containing:
      - `Header`
      - `Content`

- `Header`
  - Shows avatar, name, username.
  - Shows `Posts: <selfPostsCount>` if available.
  - Shows a “Data served from cache” label when `loadedFromCache` is `true`.
  - Uses `DesignSystem` colors and typography.

- `Content`
  - Groups three sections:
    - `InfoSection` (website, phone)
    - `AddressSection` (street, city, zip)
    - `CompanySection` (company name and details)
  - Uses design‑system spacings and cards.

- `InfoRow`
  - Small reusable row with SF Symbol + title + value.

- `RoundedCorner`
  - Helper `Shape` to round specific corners of the header background.

***

## How to wire it from the shell app

Example (pseudo‑code):

```swift
// 1. Create shared dependencies
let analytics: Analytics = AnalyticsImpl()
let networking: Networking = NetworkingImpl()

// 2. Create the feature API & dependencies
let profileAPI: ProfileFeatureAPI = ProfileFeatureAPIClient(networking: networking)
let profileDeps = ProfileDependenciesImpl(profileAPI: profileAPI, analytics: analytics)

// 3. Create the feature factory
let profileFactory = ProfileFeatureFactory(dependencies: profileDeps)

// 4. Build the MicroFeature and use it in the TabView
let profileFeature = profileFactory.makeFeature()

TabView {
    profileFeature
        .makeRootView()
        .tabItem {
            Image(uiImage: profileFeature.tabIcon)
            Text(profileFeature.title)
        }
}
```

This keeps the Profile feature fully modular: the package owns its screens, view model, API client, and cache, while the shell only provides networking and analytics through simple protocols.

***

## The Other Related Repositories

### Shell App:
Shell - https://github.com/chinthaka01/Wefriendz

### Shared contracts:
PlatformKit - https://github.com/chinthaka01/PlatformKit
DesignSystem - https://github.com/chinthaka01/DesignSystem

### Micro Frontends:
Feed Feature - https://github.com/chinthaka01/FeedFeature
Friends Feature - https://github.com/chinthaka01/FriendsFeature
Profile Feature - https://github.com/chinthaka01/ProfileFeature

### Isolate Feature Testing Apps:
Feed Feature Testing App - https://github.com/chinthaka01/FeedFeatureApp
Friends Feature Testing App - https://github.com/chinthaka01/FriendsFeatureApp
