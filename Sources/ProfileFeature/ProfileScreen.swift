//
//  File.swift
//  ProfileFeature
//
//  Created by Chinthaka Perera on 12/23/25.
//

import Foundation
import SwiftUI
import PlatformKit
import DesignSystem

struct ProfileScreen: View {
    @ObservedObject var viewModel: ProfileViewModel

    var body: some View {
        ZStack {
            if viewModel.isLoading {
                ProgressView("Loading profile…")
            } else if let error = viewModel.error {
                errorView(error)
            } else if viewModel.profile == nil {
                emptyView()
            } else {
                ScrollView {
                    VStack(spacing: 0) {
                        Header(user: viewModel.profile, selfPostsCount: viewModel.selfPostsCount, loadedFromCache: viewModel.loadedFromCache)
                        Content(user: viewModel.profile)
                    }
                }
            }
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .animation(.default, value: viewModel.profile)
        .task {
            await viewModel.loadProfile()
        }
        .refreshable {
            await viewModel.loadProfile()
        }
    }
}

struct Header: View {
    let user: User?
    let selfPostsCount: Int?
    let loadedFromCache: Bool

    var body: some View {
        ZStack {
            Spacer(minLength: DSSpacing.md)

            LinearGradient(
                colors: [
                    DSColor.primary.opacity(0.8),
                    DSColor.primary.opacity(0.4)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .frame(height: 240)
            .clipShape(
                RoundedCorner(
                    radius: 32,
                    corners: .allCorners
                )
            )

            VStack(spacing: DSSpacing.sm) {
                Spacer()

                DSAvatar(name: user?.name ?? "", size: 96, font: DSTextStyle.largeAvatar)

                Text(user?.name ?? "")
                    .font(DSTextStyle.title)
                    .foregroundColor(DSColor.headerText)

                Text("@\(user?.username ?? "")")
                    .font(DSTextStyle.body)
                    .foregroundColor(DSColor.headerText.opacity(0.85))
                
                Text("Posts: \(selfPostsCount.map(String.init) ?? "N/A")")
                    .font(DSTextStyle.caption)
                    .foregroundColor(DSColor.headerText.opacity(0.85))
                
                if loadedFromCache {
                    Text("Data served from cache")
                        .font(DSTextStyle.body)
                        .foregroundColor(DSColor.warningText.opacity(0.9))
                }

                Spacer(minLength: DSSpacing.md)
            }
        }
        .padding(.horizontal, DSSpacing.md)
    }
}

struct Content: View {
    let user: User?

    var body: some View {
        VStack(spacing: DSSpacing.lg) {

            InfoSection(user: user)

            AddressSection(user: user)

            CompanySection(user: user)
        }
        .padding(.top, DSSpacing.lg)
    }
}

struct InfoSection: View {
    let user: User?

    var body: some View {
        VStack(spacing: 0) {

            InfoRow(
                icon: "globe",
                title: "Website",
                value: user?.website ?? ""
            )

            Divider()

            InfoRow(
                icon: "phone",
                title: "Phone",
                value: user?.phone ?? ""
            )
        }
        .background(DSColor.surface)
        .cornerRadius(16)
        .padding(.horizontal, DSSpacing.md)
    }
}

struct AddressSection: View {
    let user: User?

    var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.sm) {

            Text("Address")
                .font(DSTextStyle.headline)

            Text("\(user?.address.street ?? ""), \(user?.address.suite ?? "")")
            Text("\(user?.address.city ?? ""), \(user?.address.zipcode ?? "")")
                .foregroundColor(DSColor.secondaryText)

        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(DSSpacing.md)
        .background(DSColor.card)
        .cornerRadius(16)
        .padding(.horizontal, DSSpacing.md)
    }
}

struct CompanySection: View {
    let user: User?

    var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.sm) {

            Text("Company")
                .font(DSTextStyle.headline)

            Text(user?.company.name ?? "")
                .font(DSTextStyle.body.bold())

            Text(user?.company.catchPhrase ?? "")
                .italic()
                .foregroundColor(DSColor.secondaryText)

            Text(user?.company.bs ?? "")
                .font(DSTextStyle.caption)
                .foregroundColor(DSColor.secondaryText)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(DSSpacing.md)
        .background(DSColor.card)
        .cornerRadius(16)
        .padding(.horizontal, DSSpacing.md)
    }
}

struct InfoRow: View {
    let icon: String
    let title: String
    let value: String

    var body: some View {
        HStack(spacing: DSSpacing.md) {
            Image(systemName: icon)
                .foregroundColor(DSColor.primary)
                .frame(width: 24)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(DSTextStyle.caption)
                    .foregroundColor(DSColor.secondaryText)

                Text(value)
                    .font(DSTextStyle.body)
            }

            Spacer()
        }
        .padding(DSSpacing.md)
    }
}

struct RoundedCorner: Shape {
    let radius: CGFloat
    let corners: UIRectCorner

    public init(radius: CGFloat, corners: UIRectCorner) {
        self.radius = radius
        self.corners = corners
    }

    public func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

private extension ProfileScreen {
    func errorView(_ error: Error) -> some View {
        ContentUnavailableView {
            Label("Unable to Load the Profile", systemImage: "exclamationmark.triangle.fill")
        } description: {
            Text(viewModel.error?.localizedDescription ?? "")
                .font(DSTextStyle.body)
        } actions: {
            DSButton(title: "Retry", icon: "arrow.counterclockwise") {
                Task {
                    await viewModel.loadProfile()
                }
            }
        }
    }
}

private extension ProfileScreen {
    func emptyView() -> some View {
        ContentUnavailableView {
            Label("No Profile Found", systemImage: "person.slash")
        } description: {
            Text("You don’t have a profile yet.")
                .font(DSTextStyle.body)
        } actions: {
            DSButton(title: "Retry", icon: "arrow.counterclockwise") {
                Task {
                    await viewModel.loadProfile()
                }
            }
        }
    }
}
