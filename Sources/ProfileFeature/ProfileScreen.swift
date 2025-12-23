//
//  File.swift
//  ProfileFeature
//
//  Created by Chinthaka Perera on 12/23/25.
//

import Foundation
import SwiftUI

struct ProfileScreen: View {
    @ObservedObject var viewModel: ProfileViewModel

    var body: some View {
        Label("test")
        .navigationTitle("Profile")
        .onAppear {
            viewModel.loadProfile()
        }
    }
}
